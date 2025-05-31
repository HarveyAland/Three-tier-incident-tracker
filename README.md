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
- ### Terraform Init
![](screenshots/TF%20init%20.png)
- ### Terraform Plan
![](screenshots/TF%20plan.png)
- ### Terraform Apply
![](screenshots/TF%20apply.png)
- ### RDS Apply Output
![](screenshots/TF-Apply-RDS.png)
- ### Terraform Outputs
![](screenshots/tf%20apply%20with%20outputs.png)

---

## 🛠️ Manual Console Adjustments

While the majority of the infrastructure was provisioned using Terraform, a few manual steps were necessary within the AWS Console to ensure full application functionality:

### 🔖 Tagged Public Subnets for ALB Discovery

To allow the AWS Load Balancer Controller to provision ALBs correctly, I manually tagged the public subnets used by EKS with:

`kubernetes.io/role/elb = 1`

This tag is required for ALB resources to be placed correctly by the controller.

### ❗ RDS Access Issue & Fix

The Flask backend initially couldn’t connect to the PostgreSQL RDS instance. To resolve this, I modified the RDS security group to **allow inbound access on port 5432 from the EKS Node Group's security group**. This ensured secure, private communication between the Kubernetes pods and the RDS instance hosted in private subnets.

> 📸 Screenshot:  
> ### Testing RDS Connection from Pod
![](screenshots/trying%20to%20connect%20to%20rds%20instance%20from%20eks%20pod.png)

---

## ⚙️ EKS & ALB Controller Setup

- Generate kubeconfig & check nodes  
- Setup IAM OIDC & ALB policy  
- Install ALB controller via Helm  

Screenshots:  
- ### Build Kubeconfig & Check Nodes
![](screenshots/Building%20kubeconfig%20and%20getting%20nodes%20in%20bash%20terminal%20.png)  
- ### EKS Node Group Running
![](screenshots/Nodes%20running%20in%20node%20group.png)  
- ### IAM OIDC Provider
![](screenshots/created%20IAM%20Open%20ID%20Connect%20provider%20for%20cluster.png)  
- ### IAM Policy for ALB Controller
![](screenshots/Getting%20IAM%20policy%20for%20ALB%20controller.png)  
- ### Helm Install for ALB Controller
![](screenshots/helm%20install.png)  
- ### ALB Controller Deployed
![](screenshots/showing%20controller%20is%20deployed.png)

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
- ### Creating DB Secrets
![](screenshots/Creating-DB-secrets.png)
- ### Editing DB Secrets
![](screenshots/editing%20the%20existing%20db%20secret%20via%20file.png)
- ### Applying and Restarting Backend
![](screenshots/applying-restarting-backend.png)
- ### DB Table Created
![](screenshots/db%20table%20created%20.png)
- ### Building Backend Docker Image
![](screenshots/Building-backend-image.png)
- ### Tagging Backend Image for ECR
![](screenshots/backend-tag-login-ecr.png)
- ### Backend Docker Image Push
![](screenshots/backend-dockerpush.png)
- ### Localhost Incident Testing
![](screenshots/testing%20local%20host%20incidents.png)
- ### Port Forwarding Backend
![](screenshots/testing%20local%20host%20incidents%20pf.png)
- ### Testing Curl Connection to Backend
![](screenshots/seeing%20if%20localhost%20responds%20to%20curl%20.png)

---

## 🎨 Frontend Deployment (React UI)

> 📄 **Key Files:**
> - [`frontend-deployment.yaml`](k8s/frontend-deployment.yaml)

**Screenshots:**
- ### NPM Install
![](screenshots/npm%20install.png)
- ### NPM Build
![](screenshots/npm%20build.png)
- ### Building Frontend Docker Image
![](screenshots/Building-frontend-image.png)
- ### Tagging Frontend Docker Image
![](screenshots/building%20frontend%20docker%20image.png)
- ### Frontend Image Pushed to ECR
![](screenshots/frontend%20image%20tagged%20and%20pushed.png)
- ### Frontend Pods Running
![](screenshots/frontend%20running%20pods%20live.png)
- ### Restarting Frontend Deployment
![](screenshots/kubernetes%20frontend%20deployment%20restarted%20.png)
- ### Tagging ALB to Subnets
![](screenshots/tagging%20the%20alb%20to%20the%20pub%20subs.png)

---

## ✅ End-to-End Application Flow

1. User accesses frontend via ALB
2. Submits an incident
3. Frontend calls Flask backend
4. Backend writes to RDS
5. Incident is returned & displayed

**Screenshots:**
- ### Live App – Incident Logged
![](screenshots/logged-incident-final.png)

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