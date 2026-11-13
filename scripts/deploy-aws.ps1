# ==============================================================================
# AWS EKS Ephemeral Microservices Deployment Script
# ==============================================================================
$ErrorActionPreference = "Stop"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "☁️ Ephemeral EKS Microservices Deployment Starting..." -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Check AWS Credentials
Write-Host "`n[1/5] Verifying AWS Credentials..." -ForegroundColor Yellow
try {
    $identity = aws sts get-caller-identity --output json | ConvertFrom-Json
    Write-Host "✅ Authenticated as Account: $($identity.Account) (ARN: $($identity.Arn))" -ForegroundColor Green
} catch {
    Write-Host "❌ AWS Credentials not found! Please run 'aws configure' first." -ForegroundColor Red
    exit 1
}

# 2. Terraform Init & Apply
Write-Host "`n[2/5] Provisioning EKS Infrastructure via Terraform..." -ForegroundColor Yellow
Set-Location -Path "$PSScriptRoot\..\terraform"

terraform init
if ($LASTEXITCODE -ne 0) { exit 1 }

Write-Host "Applying Terraform plan (This usually takes 10-15 minutes on AWS EKS)..." -ForegroundColor Cyan
terraform apply -auto-approve
if ($LASTEXITCODE -ne 0) { exit 1 }

$clusterName = terraform output -raw cluster_name
$awsRegion = terraform output -raw aws_region

# 3. Configure kubectl
Write-Host "`n[3/5] Configuring kubectl for cluster '$clusterName' in region '$awsRegion'..." -ForegroundColor Yellow
aws eks --region $awsRegion update-kubeconfig --name $clusterName

# 4. Deploy Kubernetes Manifests
Write-Host "`n[4/5] Deploying Microservice to EKS..." -ForegroundColor Yellow
Set-Location -Path "$PSScriptRoot\..\k8s"

kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

# 5. Wait for LoadBalancer URL
Write-Host "`n[5/5] Waiting for AWS LoadBalancer External Hostname (takes 1-2 minutes)..." -ForegroundColor Yellow
$timeout = 24
$lbHostname = ""

for ($i = 0; $i -lt $timeout; $i++) {
    Start-Sleep -Seconds 10
    $svc = kubectl get service ephemeral-api-service -o json | ConvertFrom-Json
    $lbHostname = $svc.status.loadBalancer.ingress[0].hostname
    if ($lbHostname) {
        break
    }
    Write-Host "Waiting for ELB DNS propagation... ($(($i+1)*10)s elapsed)" -ForegroundColor Gray
}

if ($lbHostname) {
    Write-Host "`n==========================================================" -ForegroundColor Green
    Write-Host "🎉 SUCCESS! Your EKS Microservice is LIVE at:" -ForegroundColor Green
    Write-Host "http://$lbHostname" -ForegroundColor Cyan
    Write-Host "==========================================================" -ForegroundColor Green
    Write-Host "`n🎬 ACTION ITEM: Open the URL above, start your screen recording," -ForegroundColor Yellow
    Write-Host "show the dashboard & pod load balancing, then IMMEDIATELY run:" -ForegroundColor Yellow
    Write-Host ".\scripts\destroy-aws.ps1" -ForegroundColor Red
} else {
    Write-Host "⚠️ Service deployed, but ELB DNS is still provisioning." -ForegroundColor Yellow
    Write-Host "Run 'kubectl get svc ephemeral-api-service' in a moment to see the external URL." -ForegroundColor White
}

