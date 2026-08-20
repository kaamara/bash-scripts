Write-Host "------------------------------------------"
Write-Host "        SERVER PERFORMANCE STATS          "
Write-Host "------------------------------------------"

Write-Host "==================="
Write-Host "--- system info ---"
Write-Host "==================="
$os = Get-CimInstance Win32_OperatingSystem
Write-Host $os.Caption
$uptime = (Get-Date) - $os.LastBootUpTime
Write-Host ("up {0} days, {1} hours, {2} minutes" -f $uptime.Days, $uptime.Hours, $uptime.Minutes)
Write-Host ""

Write-Host "=================="
Write-Host "--- cpu usage ---"
Write-Host "=================="
$cpu_usage = (Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average
Write-Host "total cpu usage: $cpu_usage%"
Write-Host ""

Write-Host "===================="
Write-Host "--- memory usage ---"
Write-Host "===================="
$totalMB = [math]::Round($os.TotalVisibleMemorySize / 1KB)
$freeMB = [math]::Round($os.FreePhysicalMemory / 1KB)
$usedMB = $totalMB - $freeMB
$memPct = [math]::Round($usedMB * 100 / $totalMB, 2)
Write-Host ("used: {0}MB | free: {1}MB | usage: {2}%" -f $usedMB, $freeMB, $memPct)
Write-Host ""

Write-Host "==================="
Write-Host "--- disk usage ---"
Write-Host "==================="
$disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"
$totalGB = [math]::Round(($disks | Measure-Object -Property Size -Sum).Sum / 1GB, 1)
$freeGB = [math]::Round(($disks | Measure-Object -Property FreeSpace -Sum).Sum / 1GB, 1)
$usedGB = $totalGB - $freeGB
$diskPct = [math]::Round($usedGB * 100 / $totalGB)
Write-Host ("Used: {0}GB | Free: {1}GB | Usage: {2}%" -f $usedGB, $freeGB, $diskPct)
Write-Host ""

Write-Host "===================================="
Write-Host "--- top 5 processes by cpu usage ---"
Write-Host "===================================="
Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 |
    ForEach-Object { Write-Host ("{0}`t{1}`t{2}" -f $_.Id, [math]::Round($_.CPU, 1), $_.ProcessName) }
Write-Host ""

Write-Host "========================================"
Write-Host "--- top 5 Processes by memory usage ---"
Write-Host "========================================"
Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 5 |
    ForEach-Object { Write-Host ("{0}`t{1}MB`t{2}" -f $_.Id, [math]::Round($_.WorkingSet / 1MB), $_.ProcessName) }
Write-Host ""

Write-Host "------------------------------------------"
