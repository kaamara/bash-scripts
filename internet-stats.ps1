Write-Host "-----------------------------"
Write-Host "        NETWORK STATS        "
Write-Host "-----------------------------"

Write-Host "==================="
Write-Host "----IP ADDRESS-----"
Write-Host "==================="
$defaultRoute = Get-NetRoute -DestinationPrefix "0.0.0.0/0" | Sort-Object RouteMetric | Select-Object -First 1
$interface = (Get-NetAdapter -InterfaceIndex $defaultRoute.InterfaceIndex).Name
$ip = (Get-NetIPAddress -InterfaceIndex $defaultRoute.InterfaceIndex -AddressFamily IPv4).IPAddress
Write-Host "IP Address: $ip"
Write-Host "Interface: $interface"

Write-Host "==================="
Write-Host "-----GATEWAY------"
Write-Host "==================="
$gateway = $defaultRoute.NextHop
Write-Host "Gateway: $gateway"

Write-Host "==================="
Write-Host "----DNS SERVERS----"
Write-Host "==================="
$dns = (Get-DnsClientServerAddress -InterfaceIndex $defaultRoute.InterfaceIndex -AddressFamily IPv4).ServerAddresses -join " "
Write-Host "DNS Servers: $dns"

Write-Host "==================="
Write-Host "---INTERNET TEST---"
Write-Host "==================="
if (Test-Connection 8.8.8.8 -Count 3 -Quiet) {
    Write-Host "Internet:  ONLINE"
} else {
    Write-Host "Internet:  OFFLINE"
}
Write-Host "-----------------------------"
