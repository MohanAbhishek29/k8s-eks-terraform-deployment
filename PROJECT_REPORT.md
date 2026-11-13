# 🚀 Project Verification & Portfolio Report
## Ephemeral EKS Microservices Architecture on AWS

**Engineer:** J Mohan Abhishek  
**Target Platform:** Amazon Web Services (AWS)  
**Infrastructure as Code:** Terraform  
**Orchestration:** Kubernetes (Amazon EKS v1.30)  
**Language & Framework:** Node.js (Express REST API)  
**Containerization:** Docker (Multi-stage Alpine)  

---

## 📌 1. Project Overview & Business Value

In modern cloud engineering, running 24/7 Kubernetes clusters for non-production environments is one of the largest sources of budget wastage. 

This project demonstrates the **Ephemeral Infrastructure Pattern**:
* Entire multi-AZ VPC, subnets, NAT gateway, EKS cluster, and worker nodes are provisioned in minutes via **Terraform**.
* A containerized microservice with 2 replicas is deployed with an AWS Elastic Load Balancer (ELB).
* After testing and demonstration, an automated teardown sequence completely destroys all cloud resources.
* **Cost Result:** The entire end-to-end execution cost was **under $0.20 USD (~₹16)**, achieving **99.8% cost savings** compared to an idle 24/7 monthly cluster ($164.20/month).

---

## 🏛️ 2. Architectural Blueprint

| Layer | Component | AWS Implementation | Function |
| :--- | :--- | :--- | :--- |
| **Ingress** | Traffic Balancing | AWS Elastic Load Balancer | Public port 80 routing with health monitoring |
| **Control Plane**| K8s Master | Amazon EKS Cluster (v1.30) | Multi-AZ managed Kubernetes API server |
| **Worker Nodes** | Compute Layer | Managed Node Group (`t3.small`) | AutoScaling group in private subnets |
| **Networking** | Virtual Private Cloud | Custom VPC `10.0.0.0/16` | 2 Public & 2 Private subnets across 2 AZs |
| **Egress** | Outbound Gateway | Cost-Optimized 1x NAT Gateway | Private subnet image pulls with 50% NAT savings |
| **Microservice**| Containerized App | 2 Replicas (`ephemeral-api:v1.0.0`) | High-availability Node.js REST API with health probes |

---

## 📸 3. Evidence & Verification Catalog (Live Screenshots)

### 1. Live Microservice on AWS Elastic Load Balancer
![Live Microservice](<eks project screenshots/website_ss.png>)

### 2. AWS Elastic Load Balancer Configuration
![Load Balancer Overview](<eks project screenshots/load_balancer_overview.png>)

### 3. Load Balancer Target Instances (2 of 2 InService)
![Target Instances](<eks project screenshots/load_balancers_with_targetinstances_names.png>)

### 4. Amazon EKS Control Plane Overview (v1.30 Active)
![EKS Cluster Overview](<eks project screenshots/eks_cluster_overview.png>)

### 5. EKS Managed Node Group & Worker Nodes
![EKS Cluster Nodes](<eks project screenshots/eks_cluster_nodes_names.png>)

### 6. Kubernetes Workloads Status
![EKS Workloads](<eks project screenshots/eks_cluster_workload_pods_names_ss.png>)

### 7. Microservice Pod Replicas Running
![EKS Pods Running](<eks project screenshots/eks_cluster_pods_running_ss.png>)

### 8. Pod Health Conditions & Readiness Probes
![Pod Conditions](<eks project screenshots/eks_cluster_pods_and_conditions_names_ss.png>)

### 9. EC2 Management Console (Worker Instances)
![EC2 Instances Main](<eks project screenshots/ec2_instances_main_ss.png>)

### 10. Worker Node 1 Configuration (`10.0.10.166`)
![Node 1 Overview](<eks project screenshots/cluster_ip_10.0.10.166 node overview.png>)

### 11. Worker Node 1 CPU & Memory Allocation
![Node 1 Capacity](<eks project screenshots/cluster_ip_10.0.10.166 node capacity allocation ss.png>)

### 12. Worker Node 2 Configuration (`10.0.11.100`)
![Node 2 Overview](<eks project screenshots/cluster_ip_10.0.11.100 node overview ss.png>)

### 13. EC2 Instance Summary: Worker Node 1
![Node 1 Summary](<eks project screenshots/Ec2_nstance_summary_node1.png>)

### 14. EC2 Instance Summary: Worker Node 2
![Node 2 Summary](<eks project screenshots/Ec2_instance_summary_node2.png>)

### 15. Custom Amazon VPC (`10.0.0.0/16`)
![VPC Overview](<eks project screenshots/Vpc_overview.png>)

### 16. Multi-AZ Public & Private Subnets
![Subnets Overview](<eks project screenshots/Subnets_overview.png>)

### 17. Cost-Optimized Single NAT Gateway
![NAT Gateway Overview](<eks project screenshots/NAT_gateway_overview.png>)

### 18. Amazon ECR Docker Image Repository
![ECR Overview](<eks project screenshots/ecr_overview.png>)

### 19. PowerShell CLI Deployment & Orchestration Output
![PowerShell CLI](<eks project screenshots/powershell_ss.png>)

---

## 🛑 4. Safe Teardown Protocol

To prevent orphaned AWS Load Balancers from locking VPC subnets, the teardown strictly followed a 2-step sequence:
1. `kubectl delete -f k8s/` (releases ELB & ENIs from AWS subnets).
2. Waited 60 seconds.
3. `terraform destroy -auto-approve` (destroys EKS cluster, node groups, NAT GW, and VPC).
4. `aws ecr delete-repository --repository-name ephemeral-api --force`

---

## 📄 How to Export to PDF & Word
* **To Export to PDF:** Open [`PROJECT_REPORT.html`](PROJECT_REPORT.html) in your browser and press `Ctrl + P` ➔ Choose **Save as PDF**!
* **To Open in Word:** Right-click [`PROJECT_REPORT.html`](PROJECT_REPORT.html) ➔ **Open with** ➔ **Microsoft Word**!
