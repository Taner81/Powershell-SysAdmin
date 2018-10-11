
$Line = "*******************************************"
$subnet = "10.188.18.11"
$subnet2 = "10.188.18"

$start = 1
$end = 254
$ping = 1
while ($start -le $end) {
$IP = "$subnet2.$start" 
$TestResult = Test-Connection -ComputerName $IP -count 1 -Quiet 
Write-Host ("Pinging", $IP, $TestResult)
IF ($TestResult) {
Write-Host "[i] - Resolving NETBIOS . . . " -ForegroundColor Cyan
[Net.DNS]::GetHostByAddress($IP).HostName

}

$start++
Write-Host $Line
}