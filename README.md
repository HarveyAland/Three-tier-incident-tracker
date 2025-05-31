# 🛠️ Major Incident Tracker – 3-Tier Kubernetes App on AWS

[![Infrastructure](https://img.shields.io/badge/Infrastructure-Terraform-5C4EE5?logo=terraform)](https://www.terraform.io/)
[![Platform](https://img.shields.io/badge/Platform-AWS-232F3E?logo=amazon-aws)](https://aws.amazon.com/)
[![Container](https://img.shields.io/badge/Container-Docker-2496ED?logo=docker)](https://www.docker.com/)
[![Backend](https://img.shields.io/badge/Backend-Flask-000000?logo=flask)](https://flask.palletsprojects.com/)
[![Frontend](https://img.shields.io/badge/Frontend-React-61DAFB?logo=react)](https://reactjs.org/)

---

## 📝 Project Summary

This project is a production-style **3-tier web application** simulating a **Major Incident Tracker** for DevOps and IT operations teams. It allows logging and viewing infrastructure incidents via a **React frontend**, **Flask API backend**, and **PostgreSQL RDS database**, all deployed in a private VPC using **EKS on AWS**.

Infrastructure is provisioned with **Terraform**, workloads containerized with **Docker**, and deployed using **raw Kubernetes YAML** and **Helm** for the ALB controller. The app demonstrates real-world AWS experience including IAM, ALB integration, and secure service-to-database communication.

> ⚠️ **Note**: The React frontend was generated using AI-assisted tools. This allowed me to focus on infrastructure provisioning, backend development, Kubernetes deployments, and end-to-end system integration.
---

## 📽️ Demo

![App Demo](screenshots/App-Working-GIF.gif)

> Demonstrates logging an incident via the frontend UI and confirming persistence in the backend.

---

## 🧱 Architecture

### 📸 Architecture Diagram

![Project Diagram](screenshots/Project-diagram.png)

Internet  
  ↓  
AWS ALB (Helm Controller)  
  ↓  
React Frontend → LoadBalancer Service  
  ↓  
Flask API → ClusterIP Service  
  ↓  
PostgreSQL RDS (Private Subnet)  

![EKS Cluster](screenshots/EKS%20cluster%20.png)

> 🔐 **Networking Note**:  
> The PostgreSQL RDS instance is hosted in **private subnets**, while the frontend LoadBalancer (ALB) and EKS control plane are exposed via **public subnets**. The node group spans both to allow secure app-to-db communication without direct exposure.

---

## 🧰 Technologies & Services Used

- **Terraform** – Infrastructure provisioning
- **AWS EKS** – Managed Kubernetes cluster
- **Helm** – For ALB controller deployment
- **Amazon RDS (PostgreSQL)** – Relational DB backend
- **React** – Frontend UI
- **Flask** – Backend API
- **Docker** – Container packaging
- **IAM, VPC, ALB, Subnets** – Core AWS services

---

## 📦 Infrastructure Provisioning (Terraform)

```bash
terraform init
terraform plan
terraform apply 
```

**Screenshots:**
- ![](screenshots/TF%20init%20.png)
- ![](screenshots/TF%20plan.png)
- ![](screenshots/TF%20apply.png)
- ![](screenshots/TF-Apply-RDS.png)
- ![](screenshots/tf%20apply%20with%20outputs.png)

---

## ⚙️ EKS & ALB Controller Setup

- Generate kubeconfig & check nodes  
- Setup IAM OIDC & ALB policy  
- Install ALB controller via Helm  

Screenshots:  
- ![](screenshots/Building%20kubeconfig%20and%20getting%20nodes%20in%20bash%20terminal%20.png)  
- ![](screenshots/Nodes%20running%20in%20node%20group.png)  
- ![](screenshots/created%20IAM%20Open%20ID%20Connect%20provider%20for%20cluster.png)  
- ![](screenshots/Getting%20IAM%20policy%20for%20ALB%20controller.png)  
- ![](screenshots/helm%20install.png)  
- ![](screenshots/showing%20controller%20is%20deployed.png)

---

## 🔧 Backend Deployment (Flask API)

> 📄 **Key Files:**
> - [`backend-deployment.yaml`](k8s/backend-deployment.yaml)
> - [`backend-service.yaml`](k8s/backend-service.yaml)
> - [`create-table-job.yaml`](k8s/create-table-job.yaml)
> - [`create-database-job.yaml`](k8s/create-database-job.yaml)
> These Kubernetes manifests define the backend Deployment (`backend-deployment.yaml`), a ClusterIP Service for internal access (`backend-service.yaml`), and two Job resources (`create-database-job.yaml`, `create-table-job.yaml`) used to initialize the database and set up the required table for storing incident data.

### 🔐 Environment Variables & Secret Management

Secrets are created using `kubectl create secret` and injected via `envFrom`. For production, AWS Secrets Manager is recommended.

**Screenshots:**
- ![](screenshots/Creating-DB-secrets.png)
- ![](screenshots/editing%20the%20existing%20db%20secret%20via%20file.png)
- ![](screenshots/applying-restarting-backend.png)
- ![](screenshots/db%20table%20created%20.png)
- ![](screenshots/Building-backend-image.png)
- ![](screenshots/backend-tag-login-ecr.png)
- ![](screenshots/backend-dockerpush.png)
- ![](screenshots/testing%20local%20host%20incidents.png)
- ![](screenshots/testing%20local%20host%20incidents%20pf.png)
- ![](screenshots/seeing%20if%20localhost%20responds%20to%20curl%20.png)

---

## ❗ RDS Access Issue & Fix

The backend couldn’t connect to RDS initially. I fixed this by allowing port `5432` access **from the EKS node group security group**.

> 📸 Screenshot:  
> ![](screenshots/trying%20to%20connect%20to%20rds%20instance%20from%20eks%20pod.png)

---

## 🎨 Frontend Deployment (React UI)

> 📄 **Key Files:**
> - [`frontend-deployment.yaml`](k8s/frontend-deployment.yaml)

**Screenshots:**
- ![](screenshots/npm%20install.png)
- ![](screenshots/npm%20build.png)
- ![](screenshots/Building-frontend-image.png)
- ![](screenshots/building%20frontend%20docker%20image.png)
- ![](screenshots/frontend%20image%20tagged%20and%20pushed.png)
- ![](screenshots/frontend%20running%20pods%20live.png)
- ![](screenshots/kubernetes%20frontend%20deployment%20restarted%20.png)
- ![](screenshots/tagging%20the%20alb%20to%20the%20pub%20subs.png)

---

## ✅ End-to-End Application Flow

1. User accesses frontend via ALB
2. Submits an incident
3. Frontend calls Flask backend
4. Backend writes to RDS
5. Incident is returned & displayed

**Screenshots:**
- ![](screenshots/Logged%20incident%20with%20the%20http%20dns%20from%20alb%20.png)
- ![](screenshots/Creating%20db%20in%20bash.png)

---

## 🔍 How the App Works

- Frontend exposed via ALB
- API runs behind ClusterIP
- RDS in private subnet
- Traffic flows securely via EKS services

---

## 📁 Project File Tree

![](screenshots/file%20tree.png)

---

## 🧠 Key Takeaways

- Deployed full 3-tier app to EKS
- Used Terraform for AWS infra
- Integrated Helm for ALB controller
- Solved real-world RDS connectivity issues
- Gained practical DevOps + Kubernetes experience

---

## 🔭 Planned Improvements

- [ ] Add Jenkins CI/CD pipeline
- [ ] Add JWT authentication
- [ ] Enforce PodSecurityPolicies/OPA
- [ ] Implement HTTPS with ACM certs

---

## 👨‍💻 Author

**Harvey Aland**  
AWS Certified Solutions Architect – Associate  
[GitHub](https://github.com/HarveyAland) • [LinkedIn](https://www.linkedin.com/in/harvey-aland-172542295)