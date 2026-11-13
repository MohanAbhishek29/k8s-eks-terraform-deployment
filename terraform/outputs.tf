output "cluster_name" {
  description = "Name of the provisioned AWS EKS Cluster"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "EKS Cluster API Server Endpoint"
  value       = aws_eks_cluster.main.endpoint
}

output "aws_region" {
  description = "AWS Region of deployment"
  value       = var.aws_region
}

output "vpc_id" {
  description = "VPC ID where EKS is deployed"
  value       = aws_vpc.main.id
}

output "configure_kubectl_command" {
  description = "Execute this command in your terminal to connect kubectl to your new EKS cluster"
  value       = "aws eks --region ${var.aws_region} update-kubeconfig --name ${aws_eks_cluster.main.name}"
}

output "ephemeral_billing_reminder" {
  description = "Critical reminder to avoid unexpected AWS charges"
  value       = "⚠️ EPHEMERAL NOTICE: Destroy resources immediately after recording your demo! Run 'kubectl delete -f ../k8s/' first, then 'terraform destroy -auto-approve'."
}

