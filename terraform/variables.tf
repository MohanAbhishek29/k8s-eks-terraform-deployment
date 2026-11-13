variable "aws_region" {
  type        = string
  description = "AWS Region to deploy resources (e.g. us-east-1, ap-south-1)"
  default     = "us-east-1"
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS Cluster"
  default     = "ephemeral-eks-cluster"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes Version for EKS"
  default     = "1.30"
}

variable "node_instance_types" {
  type        = list(string)
  description = "EC2 instance types for EKS worker nodes"
  default     = ["t3.small"]
}

variable "desired_nodes" {
  type        = number
  description = "Desired number of worker nodes"
  default     = 2
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "owner" {
  type        = string
  description = "Owner tag for resource attribution"
  default     = "DevOps-Learner"
}

