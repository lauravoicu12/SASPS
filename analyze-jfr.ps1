param(
    [Parameter(Mandatory=$true)]
    [string]$RecordingFile,

    [Parameter(Mandatory=$false)]
    [switch]$Detailed
)
if (-not (Test-Path $RecordingFile)) {
    Write-Host "✗ Recording file not found: $RecordingFile" -ForegroundColor Red
    exit 1
}

Write-Host "Analyzing: $RecordingFile" -ForegroundColor Green
Write-Host ""

Write-Host "=== GENERAL SUMMARY ===" -ForegroundColor Yellow
jfr summary $RecordingFile
Write-Host ""

Write-Host "=== CPU LOAD ANALYSIS ===" -ForegroundColor Yellow
jfr print --events jdk.CPULoad $RecordingFile | Select-Object -Last 20
Write-Host ""

Write-Host "=== DATABASE ACCESS DURATION ===" -ForegroundColor Yellow
$jdbcOutput = jfr print --events jdk.JDBCQuery,jdk.JDBCExecute $RecordingFile
if ($jdbcOutput) {
    $jdbcOutput | Select-Object -Last 30
} else {
    Write-Host "No JDBC events recorded (application may not have executed queries yet)" -ForegroundColor Gray
}
Write-Host ""

Write-Host "=== MEMORY ALLOCATIONS ===" -ForegroundColor Yellow
jfr print --events jdk.ThreadAllocationStatistics $RecordingFile | Select-Object -Last 20
Write-Host ""

if ($Detailed) {
    Write-Host "=== DETAILED CPU SAMPLING ===" -ForegroundColor Yellow
    jfr print --events jdk.ExecutionSample $RecordingFile | Select-Object -Last 50
    Write-Host ""

    Write-Host "=== DETAILED ALLOCATIONS ===" -ForegroundColor Yellow
    jfr print --events jdk.ObjectAllocationInNewTLAB,jdk.ObjectAllocationOutsideTLAB $RecordingFile | Select-Object -Last 50
    Write-Host ""

    Write-Host "=== GARBAGE COLLECTION ===" -ForegroundColor Yellow
    jfr print --events jdk.GarbageCollection $RecordingFile
    Write-Host ""
}

$jsonFile = $RecordingFile -replace '\.jfr$', '-analysis.json'
Write-Host "Exporting full analysis to JSON: $jsonFile" -ForegroundColor Cyan
jfr print --json $RecordingFile > $jsonFile
Write-Host "✓ Analysis complete! JSON export saved to: $jsonFile" -ForegroundColor Green
Write-Host ""
