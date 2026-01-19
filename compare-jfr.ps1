$ormRecording = "orm-recording.jfr"
$repoRecording = "repository-recording.jfr"

$ormExists = Test-Path $ormRecording
$repoExists = Test-Path $repoRecording

if (-not $ormExists -or -not $repoExists) {
    Write-Host "✗ Missing recording files!" -ForegroundColor Red
    if (-not $ormExists) { Write-Host "  Not found: $ormRecording" -ForegroundColor Red }
    if (-not $repoExists) { Write-Host "  Not found: $repoRecording" -ForegroundColor Red }
    Write-Host ""
    Write-Host "Please run both applications first to generate recordings." -ForegroundColor Yellow
    exit 1
}

Write-Host "✓ Found both recordings" -ForegroundColor Green
Write-Host ""

function Get-JFRStats {
    param($file, $label)

    Write-Host "=== $label ===" -ForegroundColor Yellow
    Write-Host ""

    Write-Host "Summary:" -ForegroundColor Cyan
    jfr summary $file
    Write-Host ""

    return @{
        File = $file
        Label = $label
    }
}

Write-Host " 1. CPU USAGE COMPARISON" -ForegroundColor Cyan

Write-Host "--- ORM Application CPU ---" -ForegroundColor Magenta
jfr print --events jdk.CPULoad $ormRecording | Select-Object -Last 10
Write-Host ""

Write-Host "--- Repository Application CPU ---" -ForegroundColor Magenta
jfr print --events jdk.CPULoad $repoRecording | Select-Object -Last 10
Write-Host ""

Write-Host " 2. DATABASE ACCESS DURATION" -ForegroundColor Cyan

Write-Host "--- ORM Application JDBC Queries ---" -ForegroundColor Magenta
$ormJdbc = jfr print --events jdk.JDBCQuery,jdk.JDBCExecute $ormRecording
if ($ormJdbc) {
    $ormJdbc | Select-Object -Last 15
} else {
    Write-Host "No JDBC events in ORM recording" -ForegroundColor Gray
}
Write-Host ""

Write-Host "--- Repository Application JDBC Queries ---" -ForegroundColor Magenta
$repoJdbc = jfr print --events jdk.JDBCQuery,jdk.JDBCExecute $repoRecording
if ($repoJdbc) {
    $repoJdbc | Select-Object -Last 15
} else {
    Write-Host "No JDBC events in Repository recording" -ForegroundColor Gray
}
Write-Host ""

Write-Host " 3. MEMORY ALLOCATIONS" -ForegroundColor Cyan

Write-Host "--- ORM Application Allocations ---" -ForegroundColor Magenta
jfr print --events jdk.ThreadAllocationStatistics $ormRecording | Select-Object -Last 10
Write-Host ""

Write-Host "--- Repository Application Allocations ---" -ForegroundColor Magenta
jfr print --events jdk.ThreadAllocationStatistics $repoRecording | Select-Object -Last 10
Write-Host ""

Write-Host " 4. GARBAGE COLLECTION" -ForegroundColor Cyan

Write-Host "--- ORM Application GC ---" -ForegroundColor Magenta
$ormGc = jfr print --events jdk.GarbageCollection $ormRecording
if ($ormGc) {
    $ormGc | Select-Object -Last 10
} else {
    Write-Host "No GC events in ORM recording" -ForegroundColor Gray
}
Write-Host ""

Write-Host "--- Repository Application GC ---" -ForegroundColor Magenta
$repoGc = jfr print --events jdk.GarbageCollection $repoRecording
if ($repoGc) {
    $repoGc | Select-Object -Last 10
} else {
    Write-Host "No GC events in Repository recording" -ForegroundColor Gray
}
Write-Host ""

Write-Host "Exporting ORM analysis to JSON..." -ForegroundColor Cyan
jfr print --json $ormRecording > orm-analysis.json
Write-Host "✓ Saved: orm-analysis.json" -ForegroundColor Green

Write-Host "Exporting Repository analysis to JSON..." -ForegroundColor Cyan
jfr print --json $repoRecording > repository-analysis.json
Write-Host "✓ Saved: repository-analysis.json" -ForegroundColor Green