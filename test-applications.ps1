$repoUrl = "http://localhost:8081"
$ormUrl = "http://localhost:8082"

Write-Host "Waiting for applications to start..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

function Test-Endpoint {
    param($url, $name)
    try {
        $response = Invoke-WebRequest -Uri $url -Method GET -UseBasicParsing -TimeoutSec 2
        Write-Host "[OK] $name - Status: $($response.StatusCode)" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "[FAIL] $name - $_" -ForegroundColor Red
        return $false
    }
}

Write-Host "Testing Repository Application (port 8081)..." -ForegroundColor Cyan
$repoReady = Test-Endpoint "$repoUrl/api/users" "Repository /api/users"

Write-Host ""
Write-Host "Testing ORM Application (port 8082)..." -ForegroundColor Cyan
$ormReady = Test-Endpoint "$ormUrl/api/users" "ORM /api/users"

Write-Host ""

if ($repoReady -or $ormReady) {
    Write-Host " Generating Test Traffic" -ForegroundColor Yellow

    # Make multiple requests to generate data
    for ($i = 1; $i -le 10; $i++) {
        Write-Host "Request batch $i/10..." -ForegroundColor Cyan

        if ($repoReady) {
            try {
                Invoke-WebRequest -Uri "$repoUrl/api/users" -Method GET -UseBasicParsing -TimeoutSec 2 | Out-Null
                Invoke-WebRequest -Uri "$repoUrl/api/tasks" -Method GET -UseBasicParsing -TimeoutSec 2 | Out-Null
            } catch { }
        }

        if ($ormReady) {
            try {
                Invoke-WebRequest -Uri "$ormUrl/api/users" -Method GET -UseBasicParsing -TimeoutSec 2 | Out-Null
                Invoke-WebRequest -Uri "$ormUrl/api/tasks" -Method GET -UseBasicParsing -TimeoutSec 2 | Out-Null
            } catch { }
        }

        Start-Sleep -Milliseconds 500
    }
} else {
    Write-Host "Applications are not ready yet. Please wait and try again." -ForegroundColor Red
}