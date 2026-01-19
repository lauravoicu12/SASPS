for ($i = 45; $i -gt 0; $i--) {
    Write-Host "  $i seconds remaining..." -ForegroundColor Gray
    Start-Sleep -Seconds 1
}

$repoUrl = "http://localhost:8081"
$ormUrl = "http://localhost:8082"

$repoReady = $false
try {
    $response = Invoke-WebRequest -Uri "$repoUrl/api/users" -Method GET -UseBasicParsing -TimeoutSec 5 -ErrorAction Stop
    Write-Host "  Repository Application: READY (port 8081)" -ForegroundColor Green
    $repoReady = $true
} catch {
    Write-Host "  Repository Application: NOT READY (port 8081)" -ForegroundColor Red
}

$ormReady = $false
try {
    $response = Invoke-WebRequest -Uri "$ormUrl/api/users" -Method GET -UseBasicParsing -TimeoutSec 5 -ErrorAction Stop
    Write-Host "  ORM Application: READY (port 8082)" -ForegroundColor Green
    $ormReady = $true
} catch {
    Write-Host "  ORM Application: NOT READY (port 8082)" -ForegroundColor Red
}

Write-Host ""

if (-not $repoReady -and -not $ormReady) {
    Write-Host "ERROR: No applications are ready!" -ForegroundColor Red
    Write-Host "Please check the application logs and try again." -ForegroundColor Yellow
    exit 1
}

$totalRequests = 50
$successRepo = 0
$successOrm = 0

for ($i = 1; $i -le $totalRequests; $i++) {
    Write-Progress -Activity "Generating Traffic" -Status "Request $i of $totalRequests" -PercentComplete (($i / $totalRequests) * 100)

    if ($repoReady) {
        try {
            Invoke-WebRequest -Uri "$repoUrl/api/users" -Method GET -UseBasicParsing -TimeoutSec 3 -ErrorAction Stop | Out-Null
            Invoke-WebRequest -Uri "$repoUrl/api/tasks" -Method GET -UseBasicParsing -TimeoutSec 3 -ErrorAction Stop | Out-Null
            $successRepo += 2
        } catch { }
    }

    if ($ormReady) {
        try {
            Invoke-WebRequest -Uri "$ormUrl/api/users" -Method GET -UseBasicParsing -TimeoutSec 3 -ErrorAction Stop | Out-Null
            Invoke-WebRequest -Uri "$ormUrl/api/tasks" -Method GET -UseBasicParsing -TimeoutSec 3 -ErrorAction Stop | Out-Null
            $successOrm += 2
        } catch { }
    }

    Start-Sleep -Milliseconds 200
}

Write-Progress -Activity "Generating Traffic" -Completed

Write-Host ""
Write-Host "  Repository: $successRepo successful requests" -ForegroundColor Cyan
Write-Host "  ORM: $successOrm successful requests" -ForegroundColor Cyan
Write-Host ""

Write-Host "[4/4] Stopping applications and saving JFR recordings..." -ForegroundColor Yellow

$javaProcesses = Get-Process -Name java -ErrorAction SilentlyContinue

Write-Host "  Stopping $($javaProcesses.Count) Java process(es)..." -ForegroundColor Gray
foreach ($proc in $javaProcesses) {
    try {
        $pid = $proc.Id
        jcmd $pid JFR.stop name=Repository-Recording 2>$null | Out-Null
        jcmd $pid JFR.stop name=ORM-Recording 2>$null | Out-Null
        Start-Sleep -Milliseconds 500
        Stop-Process -Id $pid -Force -ErrorAction SilentlyContinue
    } catch { }
}

Start-Sleep -Seconds 3

Write-Host " Recording Complete!" -ForegroundColor Green

$recordings = @()
if (Test-Path "repository-recording.jfr") {
    $size = [math]::Round((Get-Item "repository-recording.jfr").Length / 1MB, 2)
    Write-Host "  repository-recording.jfr ($size MB)" -ForegroundColor Cyan
    $recordings += "repository-recording.jfr"
}

if (Test-Path "orm-recording.jfr") {
    $size = [math]::Round((Get-Item "orm-recording.jfr").Length / 1MB, 2)
    Write-Host "  orm-recording.jfr ($size MB)" -ForegroundColor Cyan
    $recordings += "orm-recording.jfr"
}

Write-Host ""

if ($recordings.Count -eq 0) {
    Write-Host "WARNING: No JFR recordings found!" -ForegroundColor Red
    Write-Host "The recordings may not have been saved properly." -ForegroundColor Yellow
} else {
    Write-Host "Next step: Run comparison analysis" -ForegroundColor Yellow
    Write-Host "  .\compare-jfr.ps1" -ForegroundColor Cyan
}

Write-Host ""
