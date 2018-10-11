##############################################################################
####Prepare script
##############################################################################
<#
NOTES
Admin:tech@theburgesshillacademy.org.uk
https://practical365.com/blog/office-365-administration-portals-powershell-connections/

https://technet.microsoft.com/en-gb/library/dn568015.aspx

#>


##Import required modules
Import-Module MSOnline


##Define some stuff
$Line = "*********************************************************************"
$Title = "Taners O365 Admin Tools v0.1"
$FCol1 = "Yellow"
$BCol1 = "Black"
$FCol2 = "Green"
$BCol2 = "Black"


#$AdminUsername = "Admin@hollingtonprimaryacademy.org.uk"

$AdminUsername = "tech@theburgesshillacademy.org.uk"
#$AdminUsername = "tech@theburgesshillacademy.org.uk"



#$TestUser = "bgates@theburgesshillacademy.org.uk"
$TestUser = "MAylward@theburgesshillacademy.org.uk"
#$TestUser = "principal@theburgesshillacademy.org.uk"


$TBHAStaffLicence1 = "theburgesshillacademy:STANDARDWOFFPACK_FACULTY"
$TBHAStaffLicence2 = "theburgesshillacademy:STANDARDWOFFPACK_FACULTY"



$TBHAStudentLicences = "theburgesshillacademy:CLASSDASH_PREVIEW theburgesshillacademy:STANDARDWOFFPACK_STUDENT theburgesshillacademy:OFFICESUBSCRIPTION_STUDENT"




##############################################################################
####Functions go here
##############################################################################

Function ListAdmins{
$role = Get-MsolRole -RoleName "Company Administrator"
Get-MsolRoleMember -RoleObjectId $role.ObjectId
}


Function GetTenantInfo{
Write-Host "[i]-Getting O365 Tenant information..." -ForegroundColor $FCol2 -BackgroundColor $BCol2
Get-MsolCompanyInformation

Write-Host "[i]-Getting O365 Tenant information (MSol Domain)..." -ForegroundColor $FCol2 -BackgroundColor $BCol2
 Get-MsolDomain |
 foreach {
   new-object psobject -Property @{
                                    Name = $_.name
                                    Status = $_.status
                                    }
 }



Write-Host "[i]-Getting O365 Tenant information (Msol Subscription)..." -ForegroundColor $FCol2 -BackgroundColor $BCol2
#MSOnlineExtended\Get-MsolSubscription

Get-msolsubscription | select skupartnumber, totallicenses | ft –autosize

$skuid | select skupartnumber,activeunits,consumedunits,@{label='FriendlyName';expression={$skuid.servicestatus.serviceplan.servicetype}} | format-table

}

Function GetTenantLicenceOverview{
Get-MsolAccountSku
}

Function CheckDomain{
Resolve-DnsName -Name theburgesshillacademy.org.uk -Type MX

}

Function CheckUserGeneral{
Get-MsolUser -UserPrincipalName $TestUser | Select-Object *


}

Function CheckSingleUserLicence{

Write-Host "[i]-Checking licence status for $TestUser..."

#(Get-MsolUser -UserPrincipalName $TestUser).Licenses[0].ServiceStatus
#(Get-MsolUser -UserPrincipalName $TestUser).Licenses.ServiceStatus

Get-MsolUser -UserPrincipalName $TestUser | Select-Object -ExpandProperty Licenses | Select-Object -ExpandProperty ServiceStatus | FT
Get-MsolUser -UserPrincipalName $TestUser | Format-List DisplayName,Licenses

}

Function AddStaffLicences{

Write-Host "[i]-Checking that $TestUser has a valid -UsageLocation..."

$UL = (Get-MsolUser -UserPrincipalName $TestUser | Select-Object UsageLocation -ExpandProperty UsageLocation)

If ($UL -eq $null) 
{Write-Host "[!]-No Usage Location entry detected, setting value 'GB' now..."
Set-MsolUser -UserPrincipalName $TestUser -UsageLocation GB}
else
{Write-Host "[i]-Detected a value present..."}

If ($UL -eq "GB")
{Write-Host "[OK]-GB detected! Thats what we want, moving on...." }
else
{Write-Host "[i]-No GB detected! Maybe US is set?...Checking..." }


If ($UL -eq "US")
{Write-Host "[OK]-US detected! Thats not really what we want, but it will work. Moving on...." }
else
{Write-Host "[i]-No US detected! Maybe something else is set?...Who cares!?..." }


Write-Host "[i]-Applying licences for $TestUser..." -NoNewline
Write-Host "Licence one..." -NoNewline
Set-MsolUserLicense -UserPrincipalName $TestUser -AddLicenses "theburgesshillacademy:STANDARDWOFFPACK_FACULTY" #-LicenseOptions $l1
Write-Host "Licence two..." 
Set-MsolUserLicense -UserPrincipalName $TestUser -AddLicenses "theburgesshillacademy:OFFICESUBSCRIPTION_FACULTY"

#Set-MsolUserLicense -UserPrincipalName $TestUser -AddLicenses $TBHAStaffLicences #-LicenseOptions $l1


}

Function RemoveAllUserLicences{

(get-MsolUser -UserPrincipalName $TestUser).licenses.AccountSkuId |
foreach{
    Set-MsolUserLicense -UserPrincipalName $TestUser -RemoveLicenses $_
}

}



Function ListAllUnlicencedUsers{
Get-MsolUser -All -UnlicensedUsersOnly
}

Function ListAllLicencedUsers{
Get-MsolUser -All | where {$_.isLicensed -eq $true}
}

Function ListAllUsersWithExchangeLicence{
#users who have not been enabled for Exchange Online
Get-MsolUser -All | Where-Object {$_.isLicensed -eq $true -and $_.Licenses[0].ServiceStatus[8].ProvisioningStatus -eq "Disabled"} 
}

Function GetLastAD-O365SyncTime{
Get-MsolCompanyInformation | Select-Object -ExpandProperty LastDirSyncTime 
}

Function GetCCO365Tenant{
Get-MsolCompanyInformation | Select-Object -ExpandProperty DisplayName
}

Function ExportUserLicenceList{
#Get-MSOLUser -All | select userprincipalname,islicensed,{$_.Licenses.AccountSkuId}| Export-CSV c:\O365userlist.csv -NoTypeInformation

Get-MsolAccountSku | Select -ExpandProperty ServiceStatus
$UserLicFile="C:\Temp\UserLicensesPerUser.CSV"
    IF (test-Path $UserLicFile)
    {
    Remove-Item $UserLicFile
    }
    $STR = "User Principal Name, Office 365 Plan, Office 365 Service,Service Status"
    Add-Content $UserLicFile $STR
    $GetAllUsers=Get-MsolUser -All | Select-Object UserPrincipalName -ExpandProperty Licenses
    ForEach ($AllU in $GetAllUsers)
    {
    $SelUserUPN = $AllU.UserPrincipalName
    $T = $AllU
    $i = 0
    ForEach ($AllITems in $T)
    {
    $T.Count
    $T[$i].AccountSkuId
    $Account = $T[$i].AccountSkuId
    $TTT = $T[$i].ServiceStatus
    ForEach ($AllR in $TTT)
    {
    $GR = $AllR.ServicePlan.ServiceType
    $GZ = $AllR.ProvisioningStatus
    $STRNow = $SelUserUPN + "," + $Account + "," + $GR + "," + $GZ
    Add-Content $UserLicFile $STRNow
    }
    $i = $i + 1
    }
    }


}

Function Dev{
$customformat = @{expr={$_.AccountSkuID};label="AccountSkuId"},
         @{expr={$_.ActiveUnits};label="Total"},
         @{expr={$_.ConsumedUnits};label="Assigned"},
        @{expr={$_.activeunits-$_.consumedunits};label="Unassigned"},
        @{expr={$_.WarningUnits};label="Warning"}
Get-MsolAccountSku | sort activeunits -desc | select $customformat | Ft #| Export-CSV C:\reports\MSOL_Users_with_licenses.csv -NoTypeInformation

}

Function GetCurrentConnectionInfo{

Write-Host "[i]-Last AD -> O365 Sync:" (GetLastAD-O365SyncTime) -ForegroundColor $FCol1 -BackgroundColor $BCol1  
Write-Host "[i]-Connected Tenant:" (GetCCO365Tenant) -ForegroundColor $FCol1 -BackgroundColor $BCol1
Write-Host $Line
Pause

}

Function FinishUp{
Write-Host $Line
Write-Host "[TS]-All done. Have a nice day"
Write-Host "=]"
Write-Host $Line

}


##############################################################################
####Start the script
##############################################################################


##Clear the screen because we like tidy
cls

Write-Host $Line
Write-Host $Title
Write-Host $Line


##Get some credentials
Write-Host "[i]-Gimme some credentials dude!..." -ForegroundColor $FCol1 -BackgroundColor $BCol1
$cred = get-credential -Credential $AdminUsername



##Attemting to connect to the tenant
Write-Host "[i]-Attempting to connect with the credentials supplied..." -ForegroundColor $FCol1 -BackgroundColor $BCol1
Connect-msolservice –credential $cred

GetCurrentConnectionInfo


##############################################################################
####Call the functions
##############################################################################

###This one gets some detail about the tenant...
#GetTenantInfo

ListAdmins

#CheckDomain

#RemoveAllUserLicences
###Check details of a single user
#CheckUserGeneral
#CheckSingleUserLicence



#GetTenantLicenceOverview | Out-File C:\O365Licences.txt

#CheckO365Users
#ExportUserLicenceList

#AddStaffLicences

#Dev
#FinishUp




