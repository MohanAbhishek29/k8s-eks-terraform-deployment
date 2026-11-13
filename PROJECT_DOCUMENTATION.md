# 🚀 Project Showcase & Verification Report
## Ephemeral EKS Microservices Architecture on AWS

**Author:** J Mohan Abhishek  
**Role:** Cloud & DevOps Engineer  
**Target Platform:** Amazon Web Services (AWS)  
**Tools:** Terraform, Kubernetes (EKS v1.30), Docker, Node.js, AWS VPC, AWS ECR, AWS ELB  

---

## 📌 Executive Summary
This project demonstrates an enterprise-grade, cost-optimized, and **ephemeral** microservices architecture deployed on **AWS Elastic Kubernetes Service (EKS)**. The entire infrastructure—including a dedicated multi-AZ VPC, subnets, NAT gateway, EKS cluster, managed node groups, and application deployment—is completely automated via **Terraform** and **declarative Kubernetes manifests**.

---

## 📸 Portfolio Screenshots Checklist

Follow this exact guide to capture professional screenshots for your **LinkedIn Post**, **GitHub README**, or **Project Presentation**.

---

### 1️⃣ Screenshot 1: Local Docker Container Verification
* **What to capture:** Your web browser at `http://localhost:3000` showing the **Ephemeral EKS Microservice** web dashboard and your terminal running `curl http://localhost:3000/health`.
* **Key Highlight:** Shows that the containerized Node.js REST API was verified locally before touching the cloud.
* **Suggested Caption:** *"Phase 1: Local testing of containerized Node.js microservice with health probes and task management API."*

---

### 2️⃣ Screenshot 2: Terraform Infrastructure Automation (`apply`)
* **What to capture:** Terminal output showing:
  ```text
  Apply complete! Resources: 22 added, 0 changed, 0 destroyed.
  Outputs:
  cluster_name = "ephemeral-eks-cluster"
  aws_region = "us-east-1"
  ```
* **Key Highlight:** Demonstrates Infrastructure as Code (IaC) provisioning 22 cloud resources automatically without manual console clicks.
* **Suggested Caption:** *"Phase 2: Automated end-to-end VPC, Subnets, and EKS Cluster provisioning using Terraform."*

---

### 3️⃣ Screenshot 3: AWS Console Verification (EKS & EC2)
* **What to capture:** 
  1. AWS Console ➔ **EKS** ➔ Clusters ➔ `ephemeral-eks-cluster` (Status: **Active**).
  2. Compute tab showing the **Managed Node Group** with 2 `t3.medium` instances.
* **Key Highlight:** Real-time proof of active AWS Kubernetes control plane and worker nodes.
* **Suggested Caption:** *"Phase 3: EKS Cluster v1.30 running live in us-east-1 with 2x t3.medium EC2 worker nodes."*

---

### 4️⃣ Screenshot 4: Kubernetes Pods & LoadBalancer CLI
* **What to capture:** Terminal output running these 3 commands:
  ```powershell
  kubectl get nodes -o wide
  kubectl get pods -o wide
  kubectl get service ephemeral-api-service
  ```
* **Key Highlight:** Proves 2 replicas are running on separate worker nodes and AWS Elastic Load Balancer (ELB) has provisioned an external DNS hostname.
* **Suggested Caption:** *"Phase 4: Kubernetes manifests deployed—2 replicas with self-healing and AWS LoadBalancer external endpoint."*

---

### 5️⃣ Screenshot 5: Live AWS Microservice via LoadBalancer
* **What to capture:** Web browser opened to the **AWS Load Balancer URL** (e.g. `http://a123...elb.amazonaws.com`).
* **Key Highlight:** Add a new task in the UI, then refresh the page to show the **Serving Pod (Hostname)** alternating between the two replicas (proving round-robin load balancing).
* **Suggested Caption:** *"Phase 5: Live application running on AWS EKS serving traffic across multiple Kubernetes pods via AWS ELB."*

---

### 6️⃣ Screenshot 6: Interactive Showcase & Architecture Explorer
* **What to capture:** Browser opened to `docs/index.html` showing the interactive topology inspector and live traffic simulator.
* **Key Highlight:** Demonstrates deep architectural thinking, cloud cost awareness, and high-impact presentation.
* **Suggested Caption:** *"Phase 6: Interactive system architecture and cloud cost comparison model."*

---

### 7️⃣ Screenshot 7: Ephemeral Teardown (Zero Cloud Waste)
* **What to capture:** Terminal output running:
  ```powershell
  .\scripts\destroy-aws.ps1
  ```
  Ending with `Destroy complete! Resources: 22 destroyed.`
* **Key Highlight:** Emphasizes cloud financial governance (FinOps)—spinning up on demand and destroying immediately to save 99.8% on cloud bills.
* **Suggested Caption:** *"Phase 7: Complete automated teardown ensuring zero orphan resources and zero recurring cloud bills."*

---

## 💼 LinkedIn Post Draft (Ready to Copy & Paste)

```markdown
🚀 Excited to share my latest Cloud & DevOps project: Ephemeral EKS Microservices Architecture on AWS! 🐳☸️

Running 24/7 Kubernetes clusters in the cloud can easily cost hundreds of dollars every month. To solve this, I designed and automated an "Ephemeral Infrastructure" pattern where production-grade EKS clusters are spun up on-demand, tested, and destroyed automatically.

🛠️ Key Highlights of this Architecture:
✅ Infrastructure as Code: 100% automated VPC (Multi-AZ), Subnets, and EKS Cluster (v1.30) provisioning via Terraform.
✅ Cost Optimization: Engineered a Single NAT Gateway architecture saving 50% on AWS hourly NAT fees.
✅ Containerized Microservice: Built an optimized multi-stage Alpine Docker image for a Node.js REST API with health probes.
✅ High Availability: Deployed 2 Kubernetes replicas across EC2 t3.medium nodes with an AWS Elastic Load Balancer (ELB).
✅ Zero Cloud Waste: Automated safe teardown script deleting K8s services first to avoid orphan ELBs/ENIs, cutting ongoing cloud costs by 99.8%!

Check out the full project, Terraform code, and interactive architecture explorer here:
👉 GitHub: https://github.com/your-username/k8s-eks-terraform-deployment

#AWS #Kubernetes #Terraform #DevOps #CloudEngineering #Docker #FinOps #EKS #NodeJS
```

