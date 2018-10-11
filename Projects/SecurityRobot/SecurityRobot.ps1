Cls







############################################################################
#Import Required Modules
############################################################################

#[Imports here]

############################################################################
#Set error handling and verbose & debug options
############################################################################

#$VerbosePreference = "SilentlyContinue" #No verbose output
$VerbosePreference = "Continue" #Show vebose output
#$VerbosePreference = "Inquire" #Prompt user for choice

Write-Verbose "[i] - Setting ErrorActionPreference..."
$ErrorActionPreference = "SilentlyContinue"
#$ErrorActionPreference = "Continue"
#$ErrorActionPreference = "Stop"

Write-Verbose "[i] - Setting DebugPreference..."
#$DebugPreference = "SilentlyContinue" #No debug output
#$DebugPreference = "Continue" #Show debug output
#$DebugPreference = "Inquire" #Prompt user for choice
#End Section

############################################################################
#Script Variables
############################################################################

$ScriptName = "UOBAT Powershell Security Robot - SecRob: v0.1 - 03/10/18 "
$Line1 = "----------------------------------------------------------------------------------"
$Color1 = "Cyan"
$Color2 = "Black"
$Color3 = "Green"
$Color4 = "Red"

$LogsDirectory = "$PSScriptRoot\Logs"
$ScriptLogFile = "$LogsDirectory\SecurityRobot_Log.txt"

############################################################################
#Script Functions
############################################################################

###Setup script file / folder structure
##Check if log folder exists, if not, create it
Write-Verbose "[i] - Checking if log folder exists..."

If(!(test-path $LogsDirectory))
{
    Write-Verbose "[i] - Log folder missing! Creating folder now..."
    New-Item -ItemType Directory -Force -Path $LogsDirectory | Out-Null
}
Else{
    Write-Verbose "[i] - Log folder found =]"

}



###Check for local and domain admin rights 
Function RightsCheck{
$NTIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
$NTPrincipal = new-object Security.Principal.WindowsPrincipal $NTIdentity
$IsLocalAdmin = $NTPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
$IsDomainAdmin = $NTPrincipal.IsInRole("Domain Admins")

If ($IsLocalAdmin -eq $true)
{
#Write-Host "[i] - Local admin rights confirmed for $env:USERNAME !" -ForegroundColor Green
Write-Verbose "[i] - Local admin rights confirmed for $env:USERNAME !"
$Global:LocalAdminOK = "Confirmed"
}
Else 
{
#Write-Host "[i] - Local admin rights not assigned to $env:USERNAME !" -ForegroundColor Red
Write-Verbose "[i] - Local admin rights not assigned to $env:USERNAME !"
$Global:LocalAdminOK = "Failed"
}

If ($IsDomainAdmin -eq $true)
{
#Write-Host "[i] - Domain admin rights confirmed for $env:USERNAME !" -ForegroundColor Green
Write-Verbose "[i] - Domain admin rights confirmed for $env:USERNAME !" 
$Global:DomainAdminOK = "Confirmed"
}
Else 
{
#Write-Host "[i] - Domain admin rights not assigned to $env:USERNAME !" -ForegroundColor Green
Write-Verbose "[i] - Domain admin rights not assigned to $env:USERNAME !" 
$Global:DomainAdminOK = "Failed"
}
}

###Get Some info from AD
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

<#



#>

}


Function DiscoverShares{
 
ForEach ($svr in $Global:ServersList){

$cim = New-CimSession -ComputerName $Svr
Get-SmbShare -CimSession $cim

}



}


############################################################################
#Call Functions
############################################################################

RightsCheck
GatherADClientInfo

$Global:ServersList

DiscoverShares