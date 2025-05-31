import React, { useState, useEffect } from "react";
import axios from "axios";

const backendUrl = "/api";

function App() {
  const [form, setForm] = useState({
    service_name: "",
    summary: "",
    severity: "Low"
  });

  const [incidents, setIncidents] = useState([]);

  const fetchIncidents = async () => {
    try {
      const res = await axios.get(`${backendUrl}/incidents`);
      setIncidents(res.data);
    } catch (err) {
      console.error("Error fetching incidents:", err);
    }
  };

  useEffect(() => {
    fetchIncidents();
  }, []);

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await axios.post(`${backendUrl}/submit`, form);
      fetchIncidents();
      setForm({ service_name: "", summary: "", severity: "Low" });
    } catch (err) {
      console.error("Submission failed:", err);
    }
  };

  return (
    <div style={{ padding: "2rem", fontFamily: "Arial, sans-serif" }}>
      <h1>🚨 Major Incident Tracker</h1>

      <form onSubmit={handleSubmit}>
        <input
          type="text"
          placeholder="Service Name"
          value={form.service_name}
          onChange={(e) => setForm({ ...form, service_name: e.target.value })}
          required
        />
        <br />
        <textarea
          placeholder="Summary"
          value={form.summary}
          onChange={(e) => setForm({ ...form, summary: e.target.value })}
          required
        />
        <br />
        <select
          value={form.severity}
          onChange={(e) => setForm({ ...form, severity: e.target.value })}
        >
          <option>Low</option>
          <option>Medium</option>
          <option>High</option>
          <option>Critical</option>
        </select>
        <br />
        <button type="submit">Log Incident</button>
      </form>

      <h2>📝 Logged Incidents</h2>
      <ul>
        {incidents.map((incident, i) => (
          <li key={i}>
            <strong>{incident.service_name}</strong>: {incident.summary} —{" "}
            <em>{incident.severity}</em>
          </li>
        ))}
      </ul>
    </div>
  );
}

export default App;
