# 🛠️ Major Incident Tracker – 3-Tier Kubernetes App on AWS

[![Infrastructure](https://img.shields.io/badge/Infrastructure-Terraform-5C4EE5?logo=terraform)](https://www.terraform.io/)
[![Platform](https://img.shields.io/badge/Platform-AWS-232F3E?logo=amazon-aws)](https://aws.amazon.com/)
[![Container](https://img.shields.io/badge/Container-Docker-2496ED?logo=docker)](https://www.docker.com/)
[![Backend](https://img.shields.io/badge/Backend-Flask-000000?logo=flask)](https://flask.palletsprojects.com/)
[![Frontend](https://img.shields.io/badge/Frontend-React-61DAFB?logo=react)](https://reactjs.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## 📝 Project Summary

This project is a production-style **3-tier web application** simulating a **Major Incident Tracker** for DevOps and IT operations teams. It allows logging and viewing infrastructure incidents via a **React frontend**, **Flask API backend**, and **PostgreSQL RDS database**, all deployed in a private VPC using **EKS on AWS**.

Infrastructure is provisioned with **Terraform**, workloads containerized with **Docker**, and deployed using **raw Kubernetes YAML** and **Helm** for the ALB controller. The app demonstrates real-world AWS experience including IAM, ALB integration, and secure service-to-database communication.

> ⚠️ **Note**: The React frontend was generated using AI-assisted tools. This allowed me to focus on infrastructure provisioning, backend development, Kubernetes deployments, and end-to-end system integration.
---

## 📚 Table of Contents

- [📽 Demo](#-demo)
- [🧱 Architecture](#-architecture)
- [🧰 Technologies & Services Used](#-technologies--services-used)
- [📦 Infrastructure Provisioning (Terraform)](#-infrastructure-provisioning-terraform)
- [🧾 Checking the AWS Console for EKS Cluster Creation](#-checking-the-aws-console-for-eks-cluster-creation)
- [🛠️ Manual Console Adjustments](#️-manual-console-adjustments)
- [⚙️ EKS & ALB Controller Setup](#️-eks--alb-controller-setup)
- [🔧 Backend Deployment (Flask API)](#-backend-deployment-flask-api)
- [🎨 Frontend Deployment (React UI)](#-frontend-deployment-react-ui)
- [✅ End-to-End Application Flow](#-end-to-end-application-flow)
- [🔍 How the App Works](#-how-the-app-works)
- [🔗 Connecting Frontend & Backend](#-connecting-frontend--backend)
- [❤️ Health Checks & Load Balancing](#️-health-checks--load-balancing)
- [📁 Project File Tree](#-project-file-tree)
- [🧠 Key Takeaways](#-key-takeaways)
- [🔭 Planned Improvements](#-planned-improvements)
- [👨‍💻 Author](#-author)

---

## 📽 Demo

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

## 🧾 Checking the AWS Console for EKS Cluster Creation

After deploying the EKS infrastructure via Terraform, I verified the cluster and node group creation through the AWS Console.

### EKS Cluster
![EKS Cluster](screenshots/EKS%20cluster%20.png)

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

> ### 📦 Why Helm & ALB Controller?
> This setup follows AWS's recommended approach for managing external load balancers with EKS. The **AWS Load Balancer Controller**, installed via **Helm**, is the official method for provisioning and managing **ALBs** in Kubernetes. It enables advanced routing, integrates with IAM OIDC for secure access, and allows seamless traffic flow to services running in the EKS cluster.
> 
> The AWS Load Balancer Controller is responsible for dynamically provisioning **Application Load Balancers (ALBs)** for Kubernetes Ingress resources. Helm simplifies its installation by handling complex Kubernetes manifests and resource dependencies.  
>  
> In this project, the ALB controller automatically created and managed an external ALB that routes traffic from the internet to the frontend pods, making the application accessible to users.

---

## 🔧 Backend Deployment (Flask API)

> 📄 **Key Files:**
> - [`backend-deployment.yaml`](k8s/backend-deployment.yaml)
> - [`backend-service.yaml`](k8s/backend-service.yaml)
> - [`create-table-job.yaml`](k8s/create-table-job.yaml)
> - [`create-database-job.yaml`](k8s/create-database-job.yaml)
>   
> These Kubernetes manifests define the backend Deployment (`backend-deployment.yaml`), a ClusterIP Service for internal access (`backend-service.yaml`), and two Job resources (`create-database-job.yaml`, `create-table-job.yaml`) used to initialize the database and set up the required table for storing incident data.
>
> The database-specific Jobs enable automatic initialization of the schema during deployment, following Infrastructure-as-Code best practices. This approach eliminates the need for manual RDS access and ensures consistent, repeatable setup in a cloud-native environment.

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
![](screenshots/testing%20local%20host%20incidents%20.png)
- ### Port Forwarding Backend
![](screenshots/testing%20local%20host%20incidents%20pf.png)
- ### Testing Curl Connection to Backend
![](screenshots/seeing%20if%20localhost%20responds%20to%20curl%20.png)

---

## 🎨 Frontend Deployment (React UI)

### 💡 How the Frontend Works (React)

Although the frontend UI was generated using AI tools, it was fully integrated, tested, and containerized within the project. Here’s how it operates:

- Built using **React**, the frontend is served through **Nginx** inside a Docker container.
- Users can **submit incidents via a form**, which sends a `POST` request to `/api/incidents` (proxied to the Flask backend).
- A `GET` request to the same endpoint retrieves and **displays all logged incidents** in real-time.
- Routing and API logic are handled within React’s component state and lifecycle hooks.

This reflects a typical **single-page application (SPA)** pattern, using RESTful APIs for communication and state updates.

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

## 🔗 Connecting Frontend & Backend

The React frontend and Flask backend communicate seamlessly within the Kubernetes cluster using REST API calls. This connection is made possible through:

- ✅ **Nginx Reverse Proxy**:  
  The frontend container includes a custom [`nginx.conf`](frontend/nginx.conf) that proxies any API requests (e.g., `/api/incidents`) to the backend service. This prevents CORS issues and enables clean routing in a production-like environment.

- ✅ **Service Discovery in Kubernetes**:  
  Kubernetes services (`ClusterIP`) allow internal DNS-based discovery between pods. The Nginx proxy forwards requests to the backend using the Kubernetes service name (`http://backend-service:5000`), ensuring decoupled but connected components.

- ✅ **Consistent Environment Variables**:  
  Both frontend and backend containers rely on shared environment variables or service references to ensure that API endpoints resolve correctly in-cluster.

This setup reflects a **real-world microservice architecture**, where different application tiers communicate securely and efficiently across a private network.

---

### ❤️ Health Checks & Load Balancing

To ensure high availability, **two levels of health checks** are implemented:

- **Application Load Balancer (ALB) Health Check**:  
  The ALB routinely sends HTTP requests to the `/health` endpoint exposed by the frontend container (via Nginx). This allows the ALB to verify that the application is responsive before routing traffic.

- **Backend Pod Readiness Probe**:  
  The Flask backend exposes a `/health` endpoint that responds with a `200 OK` if the application is up. Kubernetes uses this as a readiness probe to ensure the pod is ready before accepting traffic from internal services.

These checks work together to ensure that only healthy, responsive containers serve user requests — improving fault tolerance and uptime.

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

## Jenkins CI/CD Pipeline

### Overview of the Pipeline

This section documents the Jenkins CI/CD pipeline used to automate the build, push, and deployment of the Major Incident Tracker application.

The pipeline is driven by the `Jenkinsfile` located in the root of the GitHub repository. It automates the following steps:

- **Build backend and frontend Docker images** based on the application source code.  
- **Push the images to AWS Elastic Container Registry (ECR)**.  
- **Update the Kubernetes deployments** running in Amazon EKS using `kubectl set image`, triggering a rolling update of the pods.

The goal is to provide a repeatable and automated way to deploy new application versions into the cluster with minimal manual intervention.

---

## EC2 Instance Setup and IAM Role

A dedicated EC2 instance was provisioned to host Jenkins:

- **Ubuntu 24.04 LTS**  
- Security group allowing:  
  - Port **22** for SSH  
  - Port **8080** for Jenkins web interface  
- An **IAM Role** was attached to the EC2 instance to allow:  
  - Pushing/pulling Docker images to/from ECR  
  - Interacting with EKS via `kubectl`

### EC2 Security Group and Role Attached

![EC2 Security Group and Role Attached](screenshots/jenkins-sg-role-attached.png)

### EC2 Security Group Inbound Rules

![EC2 Security Group Inbound Rules](screenshots/jenkins-sg.png)

### IAM Role and Permissions Attached to Jenkins EC2

![IAM Role and Permissions](screenshots/iam-jenkins-role-policy.png)

---

## Installing Required Packages on EC2 via SSH

The following packages were installed on the Jenkins EC2 instance to support the pipeline operations:

- **Installing Docker**  
  ![Installing Docker](screenshots/install-docker-ecr-jenkins.png)

- **Installing AWS CLI**  
  ![Installing AWS CLI](screenshots/install-aws-cli-jenkins-ec2.png)

- **Installing kubectl**  
  ![Installing kubectl](screenshots/install-kubectl-jenkins-ec2.png)

- **Installing Node.js and npm**  
  ![Installing Node.js and npm](screenshots/install-js-npm-outputs.png)

---

## Enabling and Starting Jenkins

![Enabling and Starting Jenkins](screenshots/jenkins-enabled-running-on-boot.png)

## Verifying Jenkins is Running

![Verifying Jenkins is Running](screenshots/jenkins-running-in-bash.png)

---

## Preparing the Application

To simulate the application being live, I manually re-applied the Kubernetes deployment YAML files before testing the pipeline:

```bash
kubectl apply -f backend-deployment.yaml
kubectl apply -f frontend-deployment.yaml
```

### Applying Kubernetes Deployment YAML Files

![Applying Kubernetes YAMLs](screenshots/jenkins-redeploying-frontend-backend-yamls.png)

---

## Before Pipeline Run — Baseline Checks

### Kubernetes Deployments and Pods Before Jenkins Build

![Kubernetes Deployments and Pods Before](screenshots/backend-frontend-before-jenkins.png)

---

## Running the Jenkins Pipeline

The Jenkins pipeline was configured to pull the code from GitHub and execute the stages defined in the `Jenkinsfile`. The screenshot bellow shows access credential secrets for AWS and Github.

### Jenkins Pipeline Configuration — GitHub Credentials

![Jenkins Pipeline GitHub Credentials](screenshots/jenkins-pipeline-git-creds.png)

### Jenkins Global AWS & GitHub Credentials

![Jenkins AWS Credentials](screenshots/Github-aws-keys.png)

### Jenkins Pipeline Idle State Before Build

![Jenkins Pipeline Idle Before Build](screenshots/jenkins-idle-pre-build-1.png)

---

## After Pipeline Run — Verifying Results

### Jenkins Stages Success — Stages View

![Jenkins Stages Success](screenshots/jenkins-stages-success.png)

### Jenkins Pipeline Success — Console Log Output

![Jenkins Pipeline Console Success](screenshots/jenkins-pipeline-success-console.png)

---

## After Pipeline Run — Post-Deployment Checks

### Backend ECR After Jenkins

![Backend ECR After Jenkins](screenshots/backend-ecr-after-cicd.png)

### Frontend ECR After Jenkins

![Frontend ECR After Jenkins](screenshots/frontend-ecr-after-cicd.png)

### Kubernetes Deployments After Jenkins

![Kubernetes Deployments After Jenkins](screenshots/jenkins-kube-deployments-after-cicd.png)

### Kubernetes Pods After Jenkins

![Kubernetes Pods After Jenkins](screenshots/pods-running-after-cicd.png)


---

## Handling Dummy Secrets for Backend Pod Startup

Since the RDS instance was not live during this test, a dummy Kubernetes Secret was created to allow the backend pods to start correctly:

### Creating Dummy Secret

![Creating Dummy Secret](screenshots/creating-dummy-secret-cicd-test.png)

---

## Final Summary

This Jenkins CI/CD pipeline successfully automated the build and deployment workflow for my Major Incident Tracker application:

✅ Build backend and frontend Docker images  
✅ Push images to ECR  
✅ Update Kubernetes deployments in EKS  
✅ Perform zero-downtime rolling updates of pods  
✅ Fully automated pipeline flow — tested and validated  

---

## Key Benefits of this CI/CD Setup

- Provides a **repeatable deployment process** integrated with GitHub source control.  
- Uses **AWS native services** (ECR, EKS, IAM) securely.  
- Demonstrates **infrastructure automation and CI/CD best practices**.  
- Supports **rolling updates** with no manual redeployment of Kubernetes resources required.

---

## 👨‍💻 Author

**Harvey Aland**  
AWS Certified Solutions Architect – Associate  
[GitHub](https://github.com/HarveyAland) • [LinkedIn](https://www.linkedin.com/in/harvey-aland-172542295)
