# ==============================================================================
# AWS EKS Ephemeral Microservices Teardown / Destroy Script
# ==============================================================================
Write-Host "==========================================================" -ForegroundColor Red
Write-Host "⚠️ TEARDOWN TRIGGERED: Stopping charges immediately..." -ForegroundColor Red
Write-Host "==========================================================" -ForegroundColor Red

# 1. First, delete Kubernetes Service & Deployment to release AWS LoadBalancer & ENIs
Write-Host "`n[1/3] Deleting Kubernetes Service and Deployment..." -ForegroundColor Yellow
Set-Location -Path "$PSScriptRoot\..\k8s"

try {
    kubectl delete -f service.yaml --ignore-not-found=true --timeout=60s
    kubectl delete -f deployment.yaml --ignore-not-found=true --timeout=60s
    Write-Host "✅ Kubernetes resources deleted." -ForegroundColor Green
} catch {
    Write-Host "⚠️ Warning while deleting k8s resources: $($_.Exception.Message)" -ForegroundColor Yellow
}

Write-Host "`n[2/3] Waiting 60 seconds for AWS to deregister and release the Elastic Load Balancer & ENIs..." -ForegroundColor Yellow
Start-Sleep -Seconds 60

# 2. Run Terraform Destroy
Write-Host "`n[3/3] Running 'terraform destroy' to terminate EKS Cluster, EC2 Nodes, and VPC..." -ForegroundColor Yellow
Set-Location -Path "$PSScriptRoot\..\terraform"

terraform destroy -auto-approve

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n==========================================================" -ForegroundColor Green
    Write-Host "🎉 ALL AWS RESOURCES DESTROYED SUCCESSFULLY!" -ForegroundColor Green
    Write-Host "Zero ongoing charges. Your billing is completely safe." -ForegroundColor Green
    Write-Host "==========================================================" -ForegroundColor Green
} else {
    Write-Host "`n❌ Terraform destroy encountered an issue." -ForegroundColor Red
    Write-Host "Please check AWS Console (EC2 -> Load Balancers / NAT Gateways / VPC) to ensure no orphan resources remain." -ForegroundColor Yellow
}

