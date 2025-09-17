# Setup the Variables

$initials = "nw"
$generation = "251"

$resourceGroupName = "linkasa-rg"
$aksClusterName = "linkasa-aks-cluster"
$acrName = "qualif" + $initials.ToLower() + $generation

# Starting the ACR

Write-Host "--- Starting Azure & Docker Operations ---" -ForegroundColor Green

Write-Host "Step 1: Creating ACR named '$acrName'..."
az acr create --resource-group $resourceGroupName --name $acrName --sku Basic --admin-enabled true
if ($LASTEXITCODE -ne 0) { throw "Failed to create ACR." }

Write-Host "Step 2: Logging into ACR..."
az acr login --name $acrName
if ($LASTEXITCODE -ne 0) { throw "Failed to log into ACR." }

Write-Host "Step 3: Processing backend image..."
Set-Location ./backend
docker build -t linkasa-backend .
docker tag linkasa-backend "$acrName.azurecr.io/linkasa-backend:v1"
docker push "$acrName.azurecr.io/linkasa-backend:v1"
if ($LASTEXITCODE -ne 0) { throw "Failed to push backend image." }
Set-Location ..

Write-Host "Step 4: Processing frontend image..."
Set-Location ./frontend
docker build --no-cache -t linkasa-frontend .
docker tag linkasa-frontend "$acrName.azurecr.io/linkasa-frontend:final"
docker push "$acrName.azurecr.io/linkasa-frontend:final"
if ($LASTEXITCODE -ne 0) { throw "Failed to push frontend image." }
Set-Location ..

Write-Host "Step 5: Attaching ACR to AKS cluster..."
az aks update --name $aksClusterName --resource-group $resourceGroupName --attach-acr $acrName
if ($LASTEXITCODE -ne 0) { throw "Failed to attach ACR to AKS." }

Write-Host "--- All operations completed successfully! ---" -ForegroundColor Green