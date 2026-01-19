param(
    [Parameter(Mandatory=$false)]
    [string]$AppType = "both", # "orm", "repository", or "both"

    [Parameter(Mandatory=$false)]
    [int]$Iterations = 50,

    [Parameter(Mandatory=$false)]
    [int]$ConcurrentUsers = 5
)

$repoUrl = "http://localhost:8081"
$ormUrl = "http://localhost:8082"

$testUsers = @()
$testTasks = @()

$results = @{
    Repository = @{
        Create = @()
        Read = @()
        Update = @()
        Delete = @()
        Errors = 0
    }
    ORM = @{
        Create = @()
        Read = @()
        Update = @()
        Delete = @()
        Errors = 0
    }
}

function Test-AppReady {
    param($url, $name)
    try {
        $response = Invoke-WebRequest -Uri "$url/api/users" -Method GET -UseBasicParsing -TimeoutSec 3 -ErrorAction Stop
        Write-Host "[OK] $name is READY" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "[FAIL] $name is NOT READY" -ForegroundColor Red
        return $false
    }
}

function Invoke-CreateUser {
    param($baseUrl, $username, $email)
    $body = @{
        username = $username
        email = $email
        password = "Test123!"
    } | ConvertTo-Json

    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/api/users" -Method POST -Body $body -ContentType "application/json" -TimeoutSec 10
        $sw.Stop()
        return @{ Success = $true; Time = $sw.ElapsedMilliseconds; Data = $response }
    } catch {
        $sw.Stop()
        return @{ Success = $false; Time = $sw.ElapsedMilliseconds; Error = $_.Exception.Message }
    }
}

function Invoke-ReadUsers {
    param($baseUrl)
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/api/users" -Method GET -TimeoutSec 10
        $sw.Stop()
        return @{ Success = $true; Time = $sw.ElapsedMilliseconds; Data = $response }
    } catch {
        $sw.Stop()
        return @{ Success = $false; Time = $sw.ElapsedMilliseconds; Error = $_.Exception.Message }
    }
}

function Invoke-ReadUser {
    param($baseUrl, $userId)
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/api/users/$userId" -Method GET -TimeoutSec 10
        $sw.Stop()
        return @{ Success = $true; Time = $sw.ElapsedMilliseconds; Data = $response }
    } catch {
        $sw.Stop()
        return @{ Success = $false; Time = $sw.ElapsedMilliseconds; Error = $_.Exception.Message }
    }
}

function Invoke-UpdateUser {
    param($baseUrl, $userId, $username, $email)
    $body = @{
        id = $userId
        username = $username
        email = $email
        password = "Updated123!"
    } | ConvertTo-Json

    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/api/users/$userId" -Method PUT -Body $body -ContentType "application/json" -TimeoutSec 10
        $sw.Stop()
        return @{ Success = $true; Time = $sw.ElapsedMilliseconds; Data = $response }
    } catch {
        $sw.Stop()
        return @{ Success = $false; Time = $sw.ElapsedMilliseconds; Error = $_.Exception.Message }
    }
}

function Invoke-DeleteUser {
    param($baseUrl, $userId)
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    try {
        Invoke-RestMethod -Uri "$baseUrl/api/users/$userId" -Method DELETE -TimeoutSec 10 | Out-Null
        $sw.Stop()
        return @{ Success = $true; Time = $sw.ElapsedMilliseconds }
    } catch {
        $sw.Stop()
        return @{ Success = $false; Time = $sw.ElapsedMilliseconds; Error = $_.Exception.Message }
    }
}

function Invoke-CreateTask {
    param($baseUrl, $title, $userId)
    $body = @{
        title = $title
        description = "Load test task created at $(Get-Date)"
        status = "PENDING"
        priority = "MEDIUM"
        userId = $userId
    } | ConvertTo-Json

    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/api/tasks" -Method POST -Body $body -ContentType "application/json" -TimeoutSec 10
        $sw.Stop()
        return @{ Success = $true; Time = $sw.ElapsedMilliseconds; Data = $response }
    } catch {
        $sw.Stop()
        return @{ Success = $false; Time = $sw.ElapsedMilliseconds; Error = $_.Exception.Message }
    }
}

function Invoke-ReadTasks {
    param($baseUrl)
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/api/tasks" -Method GET -TimeoutSec 10
        $sw.Stop()
        return @{ Success = $true; Time = $sw.ElapsedMilliseconds; Data = $response }
    } catch {
        $sw.Stop()
        return @{ Success = $false; Time = $sw.ElapsedMilliseconds; Error = $_.Exception.Message }
    }
}

function Invoke-UpdateTask {
    param($baseUrl, $taskId, $title, $userId)
    $body = @{
        id = $taskId
        title = $title
        description = "Updated task at $(Get-Date)"
        status = "IN_PROGRESS"
        priority = "HIGH"
        userId = $userId
    } | ConvertTo-Json

    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/api/tasks/$taskId" -Method PUT -Body $body -ContentType "application/json" -TimeoutSec 10
        $sw.Stop()
        return @{ Success = $true; Time = $sw.ElapsedMilliseconds; Data = $response }
    } catch {
        $sw.Stop()
        return @{ Success = $false; Time = $sw.ElapsedMilliseconds; Error = $_.Exception.Message }
    }
}

function Invoke-DeleteTask {
    param($baseUrl, $taskId)
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    try {
        Invoke-RestMethod -Uri "$baseUrl/api/tasks/$taskId" -Method DELETE -TimeoutSec 10 | Out-Null
        $sw.Stop()
        return @{ Success = $true; Time = $sw.ElapsedMilliseconds }
    } catch {
        $sw.Stop()
        return @{ Success = $false; Time = $sw.ElapsedMilliseconds; Error = $_.Exception.Message }
    }
}

function Invoke-CRUDCycle {
    param($baseUrl, $appName, $userIndex, $iteration)

    $username = "loadtest_${appName}_${userIndex}_${iteration}"
    $email = "loadtest_${appName}_${userIndex}_${iteration}@test.com"
    $taskTitle = "Task for $username"

    $cycleResults = @{
        Create = @()
        Read = @()
        Update = @()
        Delete = @()
    }

    # CREATE USER
    $createUserResult = Invoke-CreateUser -baseUrl $baseUrl -username $username -email $email
    $cycleResults.Create += $createUserResult.Time

    if (-not $createUserResult.Success) {
        return $cycleResults
    }

    $userId = $createUserResult.Data.id

    # CREATE TASK
    $createTaskResult = Invoke-CreateTask -baseUrl $baseUrl -title $taskTitle -userId $userId
    $cycleResults.Create += $createTaskResult.Time

    if (-not $createTaskResult.Success) {
        return $cycleResults
    }

    $taskId = $createTaskResult.Data.id

    # READ OPERATIONS
    $readUsersResult = Invoke-ReadUsers -baseUrl $baseUrl
    $cycleResults.Read += $readUsersResult.Time

    $readUserResult = Invoke-ReadUser -baseUrl $baseUrl -userId $userId
    $cycleResults.Read += $readUserResult.Time

    $readTasksResult = Invoke-ReadTasks -baseUrl $baseUrl
    $cycleResults.Read += $readTasksResult.Time

    # UPDATE OPERATIONS
    $updateUserResult = Invoke-UpdateUser -baseUrl $baseUrl -userId $userId -username "${username}_updated" -email "${email}"
    $cycleResults.Update += $updateUserResult.Time

    $updateTaskResult = Invoke-UpdateTask -baseUrl $baseUrl -taskId $taskId -title "${taskTitle}_updated" -userId $userId
    $cycleResults.Update += $updateTaskResult.Time

    # DELETE OPERATIONS
    $deleteTaskResult = Invoke-DeleteTask -baseUrl $baseUrl -taskId $taskId
    $cycleResults.Delete += $deleteTaskResult.Time

    $deleteUserResult = Invoke-DeleteUser -baseUrl $baseUrl -userId $userId
    $cycleResults.Delete += $deleteUserResult.Time

    return $cycleResults
}

Write-Host "Checking application availability..." -ForegroundColor Yellow
Write-Host ""

$repoReady = $false
$ormReady = $false

if ($AppType -eq "repository" -or $AppType -eq "both") {
    $repoReady = Test-AppReady -url $repoUrl -name "Repository Application"
}

if ($AppType -eq "orm" -or $AppType -eq "both") {
    $ormReady = Test-AppReady -url $ormUrl -name "ORM Application"
}

Write-Host ""

if (-not $repoReady -and -not $ormReady) {
    Write-Host "ERROR: No applications are ready!" -ForegroundColor Red
    Write-Host "Please start the applications first:" -ForegroundColor Yellow
    Write-Host "  .\run-both-with-jfr.ps1" -ForegroundColor Cyan
    exit 1
}

$totalTests = 0
if ($repoReady) { $totalTests += $Iterations * $ConcurrentUsers }
if ($ormReady) { $totalTests += $Iterations * $ConcurrentUsers }

$currentTest = 0

if ($repoReady) {
    Write-Host "Testing Repository Application..." -ForegroundColor Green
    Write-Host ""

    for ($user = 1; $user -le $ConcurrentUsers; $user++) {
        Write-Host "  User $user/$ConcurrentUsers:" -ForegroundColor Cyan

        for ($iter = 1; $iter -le $Iterations; $iter++) {
            $currentTest++
            $percent = [math]::Round(($currentTest / $totalTests) * 100)
            Write-Progress -Activity "CRUD Load Testing" -Status "Repository - User $user, Iteration $iter/$Iterations" -PercentComplete $percent

            $cycleResults = Invoke-CRUDCycle -baseUrl $repoUrl -appName "repo" -userIndex $user -iteration $iter

            $results.Repository.Create += $cycleResults.Create
            $results.Repository.Read += $cycleResults.Read
            $results.Repository.Update += $cycleResults.Update
            $results.Repository.Delete += $cycleResults.Delete
        }

        Write-Host "    Completed $Iterations iterations" -ForegroundColor Gray
    }

    Write-Host ""
}

if ($ormReady) {
    Write-Host "Testing ORM Application..." -ForegroundColor Green
    Write-Host ""

    for ($user = 1; $user -le $ConcurrentUsers; $user++) {
        Write-Host "  User $user/$ConcurrentUsers:" -ForegroundColor Cyan

        for ($iter = 1; $iter -le $Iterations; $iter++) {
            $currentTest++
            $percent = [math]::Round(($currentTest / $totalTests) * 100)
            Write-Progress -Activity "CRUD Load Testing" -Status "ORM - User $user, Iteration $iter/$Iterations" -PercentComplete $percent

            $cycleResults = Invoke-CRUDCycle -baseUrl $ormUrl -appName "orm" -userIndex $user -iteration $iter

            $results.ORM.Create += $cycleResults.Create
            $results.ORM.Read += $cycleResults.Read
            $results.ORM.Update += $cycleResults.Update
            $results.ORM.Delete += $cycleResults.Delete
        }

        Write-Host "    Completed $Iterations iterations" -ForegroundColor Gray
    }

    Write-Host ""
}

Write-Progress -Activity "CRUD Load Testing" -Completed

function Get-Stats {
    param($times)

    if ($times.Count -eq 0) {
        return @{
            Count = 0
            Min = 0
            Max = 0
            Avg = 0
            Median = 0
            P95 = 0
            Total = 0
        }
    }

    $sorted = $times | Sort-Object
    $count = $sorted.Count

    return @{
        Count = $count
        Min = $sorted[0]
        Max = $sorted[-1]
        Avg = ($sorted | Measure-Object -Average).Average
        Median = $sorted[[math]::Floor($count / 2)]
        P95 = $sorted[[math]::Floor($count * 0.95)]
        Total = ($sorted | Measure-Object -Sum).Sum
    }
}

Write-Host " CRUD LOAD TEST RESULTS" -ForegroundColor Cyan

if ($repoReady) {
    Write-Host "REPOSITORY APPLICATION RESULTS" -ForegroundColor Green

    $createStats = Get-Stats -times $results.Repository.Create
    $readStats = Get-Stats -times $results.Repository.Read
    $updateStats = Get-Stats -times $results.Repository.Update
    $deleteStats = Get-Stats -times $results.Repository.Delete

    Write-Host "CREATE Operations ($($createStats.Count)):" -ForegroundColor Yellow
    Write-Host "  Min:     $($createStats.Min) ms"
    Write-Host "  Max:     $($createStats.Max) ms"
    Write-Host "  Average: $([math]::Round($createStats.Avg, 2)) ms"
    Write-Host "  Median:  $($createStats.Median) ms"
    Write-Host "  P95:     $($createStats.P95) ms"
    Write-Host "  Total:   $($createStats.Total) ms"
    Write-Host ""

    Write-Host "READ Operations ($($readStats.Count)):" -ForegroundColor Yellow
    Write-Host "  Min:     $($readStats.Min) ms"
    Write-Host "  Max:     $($readStats.Max) ms"
    Write-Host "  Average: $([math]::Round($readStats.Avg, 2)) ms"
    Write-Host "  Median:  $($readStats.Median) ms"
    Write-Host "  P95:     $($readStats.P95) ms"
    Write-Host "  Total:   $($readStats.Total) ms"
    Write-Host ""

    Write-Host "UPDATE Operations ($($updateStats.Count)):" -ForegroundColor Yellow
    Write-Host "  Min:     $($updateStats.Min) ms"
    Write-Host "  Max:     $($updateStats.Max) ms"
    Write-Host "  Average: $([math]::Round($updateStats.Avg, 2)) ms"
    Write-Host "  Median:  $($updateStats.Median) ms"
    Write-Host "  P95:     $($updateStats.P95) ms"
    Write-Host "  Total:   $($updateStats.Total) ms"
    Write-Host ""

    Write-Host "DELETE Operations ($($deleteStats.Count)):" -ForegroundColor Yellow
    Write-Host "  Min:     $($deleteStats.Min) ms"
    Write-Host "  Max:     $($deleteStats.Max) ms"
    Write-Host "  Average: $([math]::Round($deleteStats.Avg, 2)) ms"
    Write-Host "  Median:  $($deleteStats.Median) ms"
    Write-Host "  P95:     $($deleteStats.P95) ms"
    Write-Host "  Total:   $($deleteStats.Total) ms"
    Write-Host ""

    $totalOps = $createStats.Count + $readStats.Count + $updateStats.Count + $deleteStats.Count
    $totalTime = $createStats.Total + $readStats.Total + $updateStats.Total + $deleteStats.Total
    Write-Host "TOTAL: $totalOps operations in $totalTime ms" -ForegroundColor Cyan
    Write-Host "Throughput: $([math]::Round($totalOps / ($totalTime / 1000), 2)) ops/sec" -ForegroundColor Cyan
    Write-Host ""
}

if ($ormReady) {
    Write-Host "ORM APPLICATION RESULTS" -ForegroundColor Green

    $createStats = Get-Stats -times $results.ORM.Create
    $readStats = Get-Stats -times $results.ORM.Read
    $updateStats = Get-Stats -times $results.ORM.Update
    $deleteStats = Get-Stats -times $results.ORM.Delete

    Write-Host "CREATE Operations ($($createStats.Count)):" -ForegroundColor Yellow
    Write-Host "  Min:     $($createStats.Min) ms"
    Write-Host "  Max:     $($createStats.Max) ms"
    Write-Host "  Average: $([math]::Round($createStats.Avg, 2)) ms"
    Write-Host "  Median:  $($createStats.Median) ms"
    Write-Host "  P95:     $($createStats.P95) ms"
    Write-Host "  Total:   $($createStats.Total) ms"
    Write-Host ""

    Write-Host "READ Operations ($($readStats.Count)):" -ForegroundColor Yellow
    Write-Host "  Min:     $($readStats.Min) ms"
    Write-Host "  Max:     $($readStats.Max) ms"
    Write-Host "  Average: $([math]::Round($readStats.Avg, 2)) ms"
    Write-Host "  Median:  $($readStats.Median) ms"
    Write-Host "  P95:     $($readStats.P95) ms"
    Write-Host "  Total:   $($readStats.Total) ms"
    Write-Host ""

    Write-Host "UPDATE Operations ($($updateStats.Count)):" -ForegroundColor Yellow
    Write-Host "  Min:     $($updateStats.Min) ms"
    Write-Host "  Max:     $($updateStats.Max) ms"
    Write-Host "  Average: $([math]::Round($updateStats.Avg, 2)) ms"
    Write-Host "  Median:  $($updateStats.Median) ms"
    Write-Host "  P95:     $($updateStats.P95) ms"
    Write-Host "  Total:   $($updateStats.Total) ms"
    Write-Host ""

    Write-Host "DELETE Operations ($($deleteStats.Count)):" -ForegroundColor Yellow
    Write-Host "  Min:     $($deleteStats.Min) ms"
    Write-Host "  Max:     $($deleteStats.Max) ms"
    Write-Host "  Average: $([math]::Round($deleteStats.Avg, 2)) ms"
    Write-Host "  Median:  $($deleteStats.Median) ms"
    Write-Host "  P95:     $($deleteStats.P95) ms"
    Write-Host "  Total:   $($deleteStats.Total) ms"
    Write-Host ""

    $totalOps = $createStats.Count + $readStats.Count + $updateStats.Count + $deleteStats.Count
    $totalTime = $createStats.Total + $readStats.Total + $updateStats.Total + $deleteStats.Total
    Write-Host "TOTAL: $totalOps operations in $totalTime ms" -ForegroundColor Cyan
    Write-Host "Throughput: $([math]::Round($totalOps / ($totalTime / 1000), 2)) ops/sec" -ForegroundColor Cyan
    Write-Host ""
}

# Comparison
if ($repoReady -and $ormReady) {

    $repoCreateAvg = ($results.Repository.Create | Measure-Object -Average).Average
    $ormCreateAvg = ($results.ORM.Create | Measure-Object -Average).Average
    $createDiff = [math]::Round((($ormCreateAvg - $repoCreateAvg) / $ormCreateAvg) * 100, 2)

    $repoReadAvg = ($results.Repository.Read | Measure-Object -Average).Average
    $ormReadAvg = ($results.ORM.Read | Measure-Object -Average).Average
    $readDiff = [math]::Round((($ormReadAvg - $repoReadAvg) / $ormReadAvg) * 100, 2)

    $repoUpdateAvg = ($results.Repository.Update | Measure-Object -Average).Average
    $ormUpdateAvg = ($results.ORM.Update | Measure-Object -Average).Average
    $updateDiff = [math]::Round((($ormUpdateAvg - $repoUpdateAvg) / $ormUpdateAvg) * 100, 2)

    $repoDeleteAvg = ($results.Repository.Delete | Measure-Object -Average).Average
    $ormDeleteAvg = ($results.ORM.Delete | Measure-Object -Average).Average
    $deleteDiff = [math]::Round((($ormDeleteAvg - $repoDeleteAvg) / $ormDeleteAvg) * 100, 2)

    Write-Host "CREATE Operations:" -ForegroundColor Yellow
    Write-Host "  Repository: $([math]::Round($repoCreateAvg, 2)) ms avg"
    Write-Host "  ORM:        $([math]::Round($ormCreateAvg, 2)) ms avg"
    if ($createDiff -gt 0) {
        Write-Host "  → Repository is $createDiff% FASTER" -ForegroundColor Green
    } else {
        Write-Host "  → ORM is $([math]::Abs($createDiff))% FASTER" -ForegroundColor Red
    }
    Write-Host ""

    Write-Host "READ Operations:" -ForegroundColor Yellow
    Write-Host "  Repository: $([math]::Round($repoReadAvg, 2)) ms avg"
    Write-Host "  ORM:        $([math]::Round($ormReadAvg, 2)) ms avg"
    if ($readDiff -gt 0) {
        Write-Host "  → Repository is $readDiff% FASTER" -ForegroundColor Green
    } else {
        Write-Host "  → ORM is $([math]::Abs($readDiff))% FASTER" -ForegroundColor Red
    }
    Write-Host ""

    Write-Host "UPDATE Operations:" -ForegroundColor Yellow
    Write-Host "  Repository: $([math]::Round($repoUpdateAvg, 2)) ms avg"
    Write-Host "  ORM:        $([math]::Round($ormUpdateAvg, 2)) ms avg"
    if ($updateDiff -gt 0) {
        Write-Host "  → Repository is $updateDiff% FASTER" -ForegroundColor Green
    } else {
        Write-Host "  → ORM is $([math]::Abs($updateDiff))% FASTER" -ForegroundColor Red
    }
    Write-Host ""

    Write-Host "DELETE Operations:" -ForegroundColor Yellow
    Write-Host "  Repository: $([math]::Round($repoDeleteAvg, 2)) ms avg"
    Write-Host "  ORM:        $([math]::Round($ormDeleteAvg, 2)) ms avg"
    if ($deleteDiff -gt 0) {
        Write-Host "  → Repository is $deleteDiff% FASTER" -ForegroundColor Green
    } else {
        Write-Host "  → ORM is $([math]::Abs($deleteDiff))% FASTER" -ForegroundColor Red
    }
    Write-Host ""
}

Write-Host " Load Testing Complete!" -ForegroundColor Green
