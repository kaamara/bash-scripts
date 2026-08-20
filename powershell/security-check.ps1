Write-Host "------------------------------------------"
Write-Host "       SYSTEM HEALTH & SECURITY CHECK     "
Write-Host "------------------------------------------"

Write-Host "======================"
Write-Host "--- logged in users ---"
Write-Host "======================"
quser 2>$null
if (-not $?) { Write-Host "Logged in: $env:USERNAME" }
Write-Host ""

Write-Host "======================"
Write-Host "--- last 5 logins ----"
Write-Host "======================"
try {
    Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4624} -MaxEvents 5 -ErrorAction Stop |
        ForEach-Object { Write-Host ("{0}  user: {1}" -f $_.TimeCreated, $_.Properties[5].Value) }
} catch {
    Write-Host "No access to Security log (run as Administrator)"
}
Write-Host ""

Write-Host "=========================="
Write-Host "--- failed login attempts ---"
Write-Host "=========================="
try {
    $failed = Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4625; StartTime=(Get-Date).AddDays(-1)} -ErrorAction Stop
    Write-Host "Failed logins (last 24h): $($failed.Count)"
    $failed | Select-Object -First 3 |
        ForEach-Object { Write-Host ("{0}  user: {1}" -f $_.TimeCreated, $_.Properties[5].Value) }
} catch {
    if ($_.Exception.Message -match "No events") {
        Write-Host "Failed logins (last 24h): 0"
    } else {
        Write-Host "No access to Security log (run as Administrator)"
    }
}
Write-Host ""

Write-Host "========================"
Write-Host "--- failed services ---"
Write-Host "========================"
$failed_services = Get-Service | Where-Object { $_.StartType -eq 'Automatic' -and $_.Status -ne 'Running' }
if (-not $failed_services) {
    Write-Host "All services:  OK"
} else {
    Write-Host "STOPPED services (autostart):"
    $failed_services | ForEach-Object { Write-Host $_.Name }
}
Write-Host ""

Write-Host "=========================="
Write-Host "--- open ports (listen) ---"
Write-Host "=========================="
Get-NetTCPConnection -State Listen |
    Sort-Object LocalPort -Unique |
    ForEach-Object { Write-Host ("tcp`t{0}:{1}" -f $_.LocalAddress, $_.LocalPort) }
Write-Host ""

Write-Host "========================"
Write-Host "--- pending updates ---"
Write-Host "========================"
try {
    $searcher = (New-Object -ComObject Microsoft.Update.Session).CreateUpdateSearcher()
    $updates = $searcher.Search("IsInstalled=0 and Type='Software'").Updates
    Write-Host "Updates to install: $($updates.Count)"
} catch {
    Write-Host "Could not query Windows Update"
}
Write-Host ""

Write-Host "=========================="
Write-Host "--- reboot required? ---"
Write-Host "=========================="
$rebootKeys = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending",
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired"
)
if ($rebootKeys | Where-Object { Test-Path $_ }) {
    Write-Host "Reboot:  REQUIRED"
} else {
    Write-Host "Reboot:  not needed"
}
Write-Host "------------------------------------------"
