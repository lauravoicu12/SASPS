Write-Host " STEP 1: Starting Applications" -ForegroundColor Cyan

Write-Host "Cleaning up existing Java processes..." -ForegroundColor Yellow
Get-Process java -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

Write-Host "Starting Repository Application (port 8081)..." -ForegroundColor Green
$repoJob = Start-Job -ScriptBlock {
    Set-Location $using:PSScriptRoot
    $env:JAVA_HOME = "C:\Users\laura\.jdks\graalvm-jdk-21.0.7"
    $env:MAVEN_OPTS = "-XX:StartFlightRecording=filename=repository-recording.jfr,settings=jfr-config.jfc,name=Repository-Recording"
    .\mvnw.cmd spring-boot:run "-Dspring-boot.run.profiles=repository" "-Dspring-boot.run.main-class=sasps.repository.RepositoryApplication"
}

Start-Sleep -Seconds 5

Write-Host "Starting ORM Application (port 8082)..." -ForegroundColor Green
$ormJob = Start-Job -ScriptBlock {
    Set-Location $using:PSScriptRoot
    $env:JAVA_HOME = "C:\Users\{user}\.jdks\graalvm-jdk-21.0.7"
    $env:MAVEN_OPTS = "-XX:StartFlightRecording=filename=orm-recording.jfr,settings=jfr-config.jfc,name=ORM-Recording"
    .\mvnw.cmd spring-boot:run "-Dspring-boot.run.profiles=orm" "-Dspring-boot.run.main-class=sasps.orm.OrmApplication"
}

for ($i = 60; $i -gt 0; $i--) {
    Write-Progress -Activity "Waiting for Applications" -Status "$i seconds remaining..." -PercentComplete ((60 - $i) / 60 * 100)
    Start-Sleep -Seconds 1
}
$repoReady = $false
$ormReady = $false

try {
    $response = Invoke-WebRequest -Uri "http://localhost:8081/api/users" -Method GET -UseBasicParsing -TimeoutSec 5 -ErrorAction Stop
    Write-Host "  Repository Application: READY ✓" -ForegroundColor Green
    $repoReady = $true
} catch {
    Write-Host "  Repository Application: NOT READY ✗" -ForegroundColor Red
}

try {
    $response = Invoke-WebRequest -Uri "http://localhost:8082/api/users" -Method GET -UseBasicParsing -TimeoutSec 5 -ErrorAction Stop
    Write-Host "  ORM Application: READY ✓" -ForegroundColor Green
    $ormReady = $true
} catch {
    Write-Host "  ORM Application: NOT READY ✗" -ForegroundColor Red
}

Write-Host ""

if (-not $repoReady -and -not $ormReady) {
    Write-Host "ERROR: No applications started successfully!" -ForegroundColor Red
    Write-Host "Check the logs for errors." -ForegroundColor Yellow

    Stop-Job $repoJob -ErrorAction SilentlyContinue
    Stop-Job $ormJob -ErrorAction SilentlyContinue
    Remove-Job $repoJob -ErrorAction SilentlyContinue
    Remove-Job $ormJob -ErrorAction SilentlyContinue

    exit 1
}
& "$PSScriptRoot\crud-load-test.ps1" -Iterations 50 -ConcurrentUsers 5

Write-Host "Stopping applications and saving JFR recordings..." -ForegroundColor Yellow

Stop-Job $repoJob -ErrorAction SilentlyContinue
Stop-Job $ormJob -ErrorAction SilentlyContinue
Remove-Job $repoJob -ErrorAction SilentlyContinue
Remove-Job $ormJob -ErrorAction SilentlyContinue

Get-Process java -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

Write-Host "Waiting for JFR files to be written..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

Write-Host ""
Write-Host "Checking JFR recordings..." -ForegroundColor Yellow

if (Test-Path "repository-recording.jfr") {
    $size = [math]::Round((Get-Item "repository-recording.jfr").Length / 1MB, 2)
    Write-Host "  repository-recording.jfr: $size MB ✓" -ForegroundColor Green
} else {
    Write-Host "  repository-recording.jfr: NOT FOUND ✗" -ForegroundColor Red
}

if (Test-Path "orm-recording.jfr") {
    $size = [math]::Round((Get-Item "orm-recording.jfr").Length / 1MB, 2)
    Write-Host "  orm-recording.jfr: $size MB ✓" -ForegroundColor Green
} else {
    Write-Host "  orm-recording.jfr: NOT FOUND ✗" -ForegroundColor Red
}

Write-Host " AUTOMATED TESTING COMPLETE!" -ForegroundColor Green
