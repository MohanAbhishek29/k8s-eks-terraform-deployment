# ==============================================================================
# Local Testing Script for Ephemeral Microservice
# ==============================================================================
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "🐳 Step 1: Building Docker Image Locally..." -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$ImageName = "ephemeral-api:local"
$ContainerName = "ephemeral-api-container"

# Stop existing container if running
docker rm -f $ContainerName 2>$null

# Build image
docker build -t $ImageName ./app
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Docker build failed! Please make sure Docker Desktop is running." -ForegroundColor Red
    exit 1
}

Write-Host "✅ Docker image built successfully: $ImageName" -ForegroundColor Green

Write-Host "`n🚀 Step 2: Running Container on http://localhost:3000..." -ForegroundColor Cyan
docker run -d -p 3000:3000 --name $ContainerName $ImageName

Start-Sleep -Seconds 3

Write-Host "`n🔍 Step 3: Checking Health Endpoint..." -ForegroundColor Cyan
try {
    $health = Invoke-RestMethod -Uri "http://localhost:3000/health" -Method Get
    Write-Host "✅ Health Check Passed!" -ForegroundColor Green
    Write-Host ($health | ConvertTo-Json -Depth 2) -ForegroundColor Gray
} catch {
    Write-Host "⚠️ Health check warning: $($_.Exception.Message)" -ForegroundColor Yellow
}

Write-Host "`n🌐 Opening Web Dashboard in your browser..." -ForegroundColor Cyan
Start-Process "http://localhost:3000"

Write-Host "`n----------------------------------------------------------" -ForegroundColor Yellow
Write-Host "When you are done testing locally, run:" -ForegroundColor Yellow
Write-Host "docker rm -f $ContainerName" -ForegroundColor White
Write-Host "----------------------------------------------------------" -ForegroundColor Yellow

