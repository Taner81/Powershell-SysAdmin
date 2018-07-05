#$servers = get-content "C:\ScriptEngine\TargetLists\ServersTimeCheck.txt"
$Global:Servers = (Get-ADComputer -Filter { OperatingSystem -Like '*Windows Server*' }| Select-Object -ExpandProperty Name)

$ErrorActionPreference = silentlycontinue



########################################################################################Servers


Function GetNTPServersetting{
foreach ($server in $servers){

    $ntps = w32tm /query /computer:$server /configuration | ?{$_ -match 'ntpserver:'} | %{($_ -split ":\s\b")[1]}
    new-object psobject -property @{
    Server = $Server
    NTPSource = $ntps
    }
}
}

Function GetServerTime{
foreach ($server in $servers){
    Try {
    $time = ([WMI]'').ConvertToDateTime((gwmi win32_operatingsystem -computername $server).LocalDateTime)
    Write-Host "[info]- $server - $time"}
    Catch {
		Write-Output "[ERROR]-$server was not accessible.";
	}
}
}

########################################################################################Client PCs

Function GetPCTime{
    #$PC = "TSLA-ADML324"
    $PC = "THA-ICT13"

    $time = ([WMI]'').ConvertToDateTime((gwmi win32_operatingsystem -computername $PC).LocalDateTime)
    $PC + '  ' + $time
}

Function GetNTPPCsetting{
    #$PC = "TSLA-ADML324"
    $PC = "THA-ICT13"

    $ntps = w32tm /query /computer:$PC /configuration | ?{$_ -match 'ntpserver:'} | %{($_ -split ":\s\b")[1]}
    new-object psobject -property @{
    Server = $PC
    NTPSource = $ntps
    }
}


cls

#########################Servers
GetServerTime
#GetNTPServersetting

#########################Client PCs
#GetPCTime
#GetNTPPCsetting
