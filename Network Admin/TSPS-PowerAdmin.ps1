cls

# https://github.com/aikoncwd/vbs-ad-health-report
# Need to ensure all scripts are sanitised before commit and push to GitHub. 
# Standard script headers. 
#
# PS Profile project push
# PS Projectes push  




###############################################################################################################
#Define script variables
###############################################################################################################
$VerbosePreference = "Continue"
$ScriptName = "TS Domain Admin Tools"
$ScriptVersion = "v0.1"
$Line = "******************************************************************************************************"
$Col1 = "Cyan"
$Col2 = "Green"
$Col3 = "Red"

$CDomain = $env:USERDOMAIN

$Global:ServersList = $Null
$Global:ServersCount = $Null

$Global:XPClientsList = $Null 
$Global:XPClientsCount = $Null

$Global:W7ClientsList = $Null
$Global:W7ClientsCount = $Null

$Global:W10ClientsList = $Null
$Global:W10ClientsCount = $Null

$ErrorActionPreference = "SilentlyContinue"


###############################################################################################################
#Define script funtions
###############################################################################################################


Function GatherADClientInfo{
Write-Verbose "[i] - Getting AD list [Servers]" 
$Global:ServersList = (Get-ADComputer -Filter { OperatingSystem -Like '*Windows Server*' }| Select-Object -ExpandProperty Name) 
$Global:ServersCount = $ServersList.count

Write-Verbose "[i] - Getting AD list [XP]" 
$Global:XPClientsList = (Get-ADComputer -Filter { OperatingSystem -Like '*Windows XP*' }| Select-Object -ExpandProperty Name) 
$Global:XPClientsCount = $XPClientsList.count

Write-Verbose "[i] - Getting AD list [W7]" 
$Global:W7ClientsList = (Get-ADComputer -Filter { OperatingSystem -Like '*Windows 7*' }| Select-Object -ExpandProperty Name) 
$Global:W7ClientsCount = $W7ClientsList.count

Write-Verbose "[i] - Getting AD list [W10]" 
$Global:W10ClientsList = (Get-ADComputer -Filter { OperatingSystem -Like '*Windows 10*' }| Select-Object -ExpandProperty Name) 
$Global:W10ClientsCount = $W10ClientsList.count
}

Function ListDCs{

    Write-Host "[i] - Listing Domain Controller Information. . . " -ForegroundColor $Col1

    $DCs = Get-ADDomainController -Filter *
    $Results = New-Object -TypeName System.Collections.ArrayList
    foreach($DC in $DCs){
        [string]$OMRoles = ""
        $ThisResult = New-Object -TypeName System.Object
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name Name -Value $DC.Name
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name Site -Value $DC.Site
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name IPv4Address -Value $DC.IPv4Address
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name OperatingSystemVersion -Value $DC.OperatingSystemVersion
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name IsGlobalCatalog -Value $DC.IsGlobalCatalog
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name IsReadOnly -Value $DC.IsReadOnly
        foreach($OMRole in $DC.OperationMasterRoles){
                $OMRoles += ([string]$OMRole+" ")
        }
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name OperationMasterRoles -Value $OMRoles
        $Results.Add($ThisResult) | Out-Null
    }
    $Results = $Results | Sort-Object -Property Site
    $Results | Format-Table -AutoSize
}

Function ListAllServersDetail{

    #$ServersList = (Get-ADComputer -Filter { OperatingSystem -Like '*Windows Server*' } | ForEach-Object {$_.Name})
    Get-ADComputer -Filter { OperatingSystem -Like '*Windows Server*' } -Properties Name, OperatingSystem, IPv4Address, Description | Select Name, OperatingSystem, IPv4Address, Description #| Format-Table -AutoSize C:\Script\server_systems.txt
    $ServersCount = $ServersList.count
    Write-Host "Known Servers=" $ServersCount
    
}

Function RemoteChecks{
    Write-Host "[i] - Testing $Svr..." 
    PingCheck
    RDPCheck
    RRCheck
    WMICheck
}

Function CheckSvrs{
#Write-Host $ServersList
 
    ForEach ($Svr in $ServersList){
    
    Write-Host "[i] - Testing $Svr..." 
    PingCheck
    RDPCheck
    RRCheck
    WMICheck
    #PSVersionCheck

    }
}

Function CheckTest{
#Write-Host $ServersList
 
 
 
    ForEach ($Svr in $W10ClientsList){
    
    Write-Host "[i] - Testing $Svr..." 
    PingCheck
    RDPCheck
    RRCheck
    WMICheck
    #PSVersionCheck
    Write-Host $Line
    }

}

Function PingCheck{

    $PingRequest = Test-Connection -ComputerName $Svr -Quiet -Count 1
    if ($PingRequest -eq $false){
        Write-Host "   [!!] - $Svr DOWN! [Ping-Check] " -ForegroundColor $Col3}
    Else{
        Write-Host "   [OK] - $Svr UP! [Ping-Check]" -ForegroundColor $Col2}
    
}

Function RDPCheck{

    $RDPRequest = Test-NetConnection -ComputerName $Svr -CommonTCPPort RDP -InformationLevel Quiet
    if ($RDPRequest -eq $false){
        Write-Host "   [!!] - No RDP port open on $Svr [RDP-Check] " -ForegroundColor $Col3}
    Else{
        Write-Host "   [OK] - RDP port open on $Svr [RDP-Check]" -ForegroundColor $Col2}
   
}

Function RRCheck{

    $regkey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine,$Svr)
    $ref = $regkey.OpenSubKey("SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall")
    If (!$ref) {
        Write-Host "   [!!] - No Remote registry service running on $Svr [RR-Check] " -ForegroundColor $Col3}
   Else {
        Write-Host "   [OK] - Remote registry service running on $Svr [RR-Check] " -ForegroundColor $Col2}
}

Function WMICheck{
    
    $wmi = GWMI -Query "Select * from Win32_PingStatus where Address = '$Svr'"
    If (!$wmi) {
        Write-Host "   [OK] - Remote WMI running on $Svr [WMI-Check] " -ForegroundColor $Col3}

    Else {
        Write-Host "   [OK] - Remote WMI running on $Svr [WMI-Check] " -ForegroundColor $Col2}

}

Function PSVersionCheck{

    Try
    {
        Write-Host "Checking Computer $Svr"
        $path = "\\$Svr\C$\windows\System32\WindowsPowerShell\v1.0\powershell.exe"
        if (test-path $path) { (ls $path).VersionInfo }
        else
        {
            Write-Host "Powershell isn't installed" -ForegroundColor 'Red'
        }
        Write-Host "Finished Checking Computer $Svr"
    }

    catch { }

}

Function ServerRoles{
ForEach ($Svr in $ServersList){
Write-Host "[i] - Installed Features on $Svr..."
Get-WindowsFeature -ComputerName $Svr | Where-Object {$_. installstate -eq "installed"} | Format-Table Name,Installstate | more
}
}

Function ServerServicesCheck{

ForEach ($Svr in $ServersList){
Write-Host "[i] - Checking critical services on $Svr..."
Get-Service -name ntds,adws,dns,dncache,kdc,w32time,netlogon,dhcpserver,dhcp -ComputerName $Svr

}
}


function Get-LoggedOnUser
 {
     [CmdletBinding()]
     param
     (
         [Parameter()]
         [ValidateScript({ Test-Connection -ComputerName $_ -Quiet -Count 1 })]
         [ValidateNotNullOrEmpty()]
         [string[]]$ComputerName = $env:COMPUTERNAME
     )
     foreach ($comp in $ComputerName)
     {
         $output = @{ 'ComputerName' = $comp }
         $output.UserName = (Get-WmiObject -Class win32_computersystem -ComputerName $comp).UserName
         [PSCustomObject]$output
     }
 }

Function Test{


Get-LoggedOnUser C7-Teacher

}




###############################################################################################################
#Script header
###############################################################################################################

Function ScriptHeader{
Write-Host $Line
Write-Host "Script Name:       $ScriptName " 
Write-Host "Script Version:    $ScriptVersion "
Write-Host "Domain:            $CDomain"
Write-Host "Servers in AD:     $Global:ServersCount"
Write-Host "XP Clients in AD:  $XPClientsCount"
Write-Host "W7 Clients in AD:  $W7ClientsCount"
Write-Host "W10 Clients in AD: $W10ClientsCount"
Write-Host $Line


}





###############################################################################################################
#Main script start
###############################################################################################################

GatherADClientInfo
ScriptHeader

#CheckSvrs
#CheckTest
ListAllServersDetail
#ServerServicesCheck
#Test

Get-LoggedOnUser ADMIN-ASM