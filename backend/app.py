from flask import Flask, jsonify, request
import psycopg2
import os

app = Flask(__name__)

# Connect to PostgreSQL using env vars injected by Kubernetes Secret
def get_db_connection():
    return psycopg2.connect(
        host=os.environ["DB_HOST"],
        database=os.environ["DB_NAME"],
        user=os.environ["DB_USER"],
        password=os.environ["DB_PASS"]
    )

@app.route("/incidents", methods=["GET"])
def get_incidents():
    conn = get_db_connection()
    cur = conn.cursor()
    # Fetch all incidents, newest first
    cur.execute("""
        SELECT id, service_name, summary, severity, timestamp
        FROM major_incidents
        ORDER BY timestamp DESC;
    """)
    rows = cur.fetchall()
    cur.close()
    conn.close()
    # Build JSON-friendly list
    incidents = [
        {
            "id": r[0],
            "service_name": r[1],
            "summary": r[2],
            "severity": r[3],
            "timestamp": r[4].isoformat()
        }
        for r in rows
    ]
    return jsonify(incidents)

@app.route("/submit", methods=["POST"])
def submit_incident():
    data = request.get_json() or {}
    service_name = data.get("service_name", "").strip()
    summary      = data.get("summary", "").strip()
    severity     = data.get("severity", "Low")

    if not service_name or not summary:
        return jsonify({"error": "service_name and summary are required"}), 400

    conn = get_db_connection()
    cur = conn.cursor()
    # Insert a new incident; timestamp defaults to NOW()
    cur.execute("""
        INSERT INTO major_incidents (service_name, summary, severity)
        VALUES (%s, %s, %s);
    """, (service_name, summary, severity))
    conn.commit()
    cur.close()
    conn.close()

    return jsonify({"message": "Incident logged"}), 201

@app.route("/health", methods=["GET"])
def health():
    # Used by Kubernetes and ALB readiness/liveness
    return jsonify({"status": "ok"})

if __name__ == "__main__":
    # Listen on port 5000 for Docker/Kubernetes
    app.run(host="0.0.0.0", port=5000)