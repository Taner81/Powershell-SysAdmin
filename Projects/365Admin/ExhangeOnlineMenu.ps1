

$ScriptASCIIHeader = @'

  ____    __ _____               _           _                  ______          _                            
 |___ \  / /| ____|     /\      | |         (_)                |  ____|        | |                           
   __) |/ /_| |__      /  \   __| |_ __ ___  _ _ __    ______  | |__  __  _____| |__   __ _ _ __   __ _  ___ 
  |__ <| '_ \___ \    / /\ \ / _` | '_ ` _ \| | '_ \  |______| |  __| \ \/ / __| '_ \ / _` | '_ \ / _` |/ _ \
  ___) | (_) |__) |  / ____ \ (_| | | | | | | | | | |          | |____ >  < (__| | | | (_| | | | | (_| |  __/
 |____/ \___/____/  /_/    \_\__,_|_| |_| |_|_|_| |_|          |______/_/\_\___|_| |_|\__,_|_| |_|\__, |\___|
                                                                                                   __/ |     
                                                                                                  |___/      
'@



##############################################################################
####Prepare script
##############################################################################
Cls
##Import required modules
Import-Module MSOnline

##Define some stuff
$Line = "*********************************************************************"
$Title = "Taners O365 Admin Tools v0.1"
$FCol1 = "Yellow"
$BCol1 = "Black"
$FCol2 = "Green"
$BCol2 = "Black"

$LocalUser = $env:USERNAME
$LocalMachine = $env:COMPUTERNAME
$ScriptLocation = $PSScriptRoot

$Global:Site = "[None Set]"
$Global:AdminUsername = "[None Set]"
$Global:ActiveMBCount = "[No Data]"
$Global:TargetUser = "[None Set]"
$Global:TargetEMail = "3006adi@gmail.com"
$Global:SiteEMailSuffix = "[None Set]"

##############################################################################
####Main Menu [Site Selection]
##############################################################################

Function SiteSelectionMenu{
Write-host "----------------=Menu=----------------"
[int]$xMenuChoiceA = 0
while ( $xMenuChoiceA -lt 1 -or $xMenuChoiceA -gt 4 ){
Write-host "1. Hastings & St Leonards (365)"
Write-host "2. Hastings & St Leonards (On-Prem)"
Write-host "3. Burgess Hill (365)"
Write-host "4. Academies Central"
Write-host "5. Quit and exit"
Write-host "----------------=Menu=----------------"
[Int]$xMenuChoiceA = read-host "Please enter an option 1 to 4..." }
Switch( $xMenuChoiceA ){
  1{
        $Global:Site = "Hastings & St Leonards" 
        #$AdminUsername = "tech@theburgesshillacademy.org.uk"
        $Global:AdminUsername = "t.sapolyo@hasla.org.uk"
        $Global:SiteEMailSuffix = "@hasla.org.uk"
        Connect365Outlook  
  }
  2{<#run an action or call a function here #>}
  3{
        $Global:Site = "Burgess Hill" 
        #$AdminUsername = "tech@theburgesshillacademy.org.uk"
        $Global:AdminUsername = "t.sapolyo@theburgesshillacademy.org.uk"
        $Global:SiteEMailSuffix = "@theburgesshillacademy.org.uk"
        Connect365Outlook  
  }
  4{<#run an action or call a function here #>}
default{<#run a default action or call a function here #>}


}
}

##############################################################################
####Functions Menu
##############################################################################

Function FunctionsMenu{

[int]$xMenuChoiceA = 0
while ( $xMenuChoiceA -lt 1 -or $xMenuChoiceA -gt 4 ){
Write-host "1. User (Passive) actions"
Write-host "2. User (Active) actions"
Write-host "3. Tenant (Passive actions)"
Write-host "4. Misc actions"
Write-host "5. Quit and exit"
[Int]$xMenuChoiceA = read-host "Please enter an option 1 to 4..." }
Switch( $xMenuChoiceA ){
  1{$Global:TargetUser = read-host "Please enter a Username"
    RunSummary
    UserActionsPassiveMenu
    }
  2{<#run an action or call a function here #>}
  3{
    TenantActionsPassiveMenu
    }
  4{<#run an action or call a function here #>}
default{<#run a default action or call a function here #>}
}
}

##############################################################################
####Single User actions menu
##############################################################################

Function UserActionsPassiveMenu{

[int]$xMenuChoiceA = 0
while ( $xMenuChoiceA -lt 1 -or $xMenuChoiceA -gt 4 ){
Write-host "1. Get Mailbox details for $Global:TargetUser"
Write-host "2. Sent and recieved summary for $Global:TargetUser"
Write-host "3. N/A"
Write-host "4. ..."
Write-host "5. Quit and exit"
[Int]$xMenuChoiceA = read-host "Please enter an option 1 to 4..." }
Switch( $xMenuChoiceA ){
  1{GetUserMailboxDetails}
  2{SentRcdSummary}
  3{
  }
  4{<#run an action or call a function here #>}
default{<#run a default action or call a function here #>}
}
}

##############################################################################
####Single User actions menu
##############################################################################

Function TenantActionsPassiveMenu{

[int]$xMenuChoiceA = 0
while ( $xMenuChoiceA -lt 1 -or $xMenuChoiceA -gt 4 ){
Write-host "1. [Test]"
Write-host "2. Trace incoming e-mails from XXX"
Write-host "3. N/A"
Write-host "4. ..."
Write-host "5. Quit and exit"
[Int]$xMenuChoiceA = read-host "Please enter an option 1 to 4..." }
Switch( $xMenuChoiceA ){
  1{GetDGroups}
  2{
  TraceIncomingEMails
  }
  3{
  }
  4{<#run an action or call a function here #>}
default{<#run a default action or call a function here #>}
}
}

##############################################################################
####Main Script Functions
##############################################################################

Function RunSummary{
cls
$ScriptASCIIHeader

Write-Host $Line -Fore $FCol1
Write-Host "Script Location:      $ScriptLocation"  -Fore $FCol1
Write-Host "Connected site:       $Site" -Fore $FCol1
Write-Host "Admin username:       $AdminUsername" -Fore $FCol1
Write-Host "Target user:          $Global:TargetUser" -Fore $FCol1
Write-Host "Active Mailbox Count: $Global:ActiveMBCount" -Fore $FCol1
Write-Host $Line -Fore $FCol1
}


Function Connect365Outlook{

##Get some credentials
Write-Host "[i]-Gimme some credentials dude!..." -ForegroundColor $FCol1 -BackgroundColor $BCol1
$O365Cred = Get-Credential -Credential $AdminUsername


#$O365Cred = Get-Credential
$O365Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $O365Cred -Authentication Basic -AllowRedirection
Import-PSSession $O365Session -AllowClobber

}

##############################################################################
####Single user action functions
##############################################################################

Function LastLogon{

$objUserMailbox = get-mailboxstatistics -Identity $Global:TargetUser | Select LastLogonTime 
         
        #Prepare UserPrincipalName variable 
        $strUserPrincipalName = $objUser.UserPrincipalName 
         
        #Check if they have a last logon time. Users who have never logged in do not have this property 
        if ($objUserMailbox.LastLogonTime -eq $null) 
        { 
            #Never logged in, update Last Logon Variable 
            $strLastLogonTime = "Never Logged In" 
        } 
        else 
        { 
            #Update last logon variable with data from Office 365 
            $strLastLogonTime = $objUserMailbox.LastLogonTime 
        } 
         
        #Output result to screen for debuging (Uncomment to use) 
        write-host "$Global:TargetUser Last logged on: $strLastLogonTime" 

}



Function GetUserMailboxDetails{
$CompoundIdentity = ($Global:TargetUser + $Global:SiteEMailSuffix)

LastLogon

Get-MobileDeviceStatistics -Mailbox:$Global:TargetUser | Select FirstSyncTime, LastSyncAttemptTime, LastSuccessSync, DeviceType, DeviceID, DeviceUserAgent  | FT


# Get total item count in the mailbox (all items) 
$TotalItemsCount = Get-MailboxStatistics -Identity $Global:TargetUser  

# Print the results 
Write-Host "[i] - $Global:TargetUser has " -NoNewline
$TotalItemsCount.ItemCount 
Write-Host " items in the mailbox."

Write-Host "[i] - E_Mail Sent..."
Get-MessageTrace -StartDate (Get-Date).Adddays(-2) -EndDate (Get-Date) -SenderAddress $CompoundIdentity


Write-Host "[i] - E_Mail recieved..."
Get-MessageTrace -StartDate (Get-Date).Adddays(-2) -EndDate (Get-Date) -RecipientAddress $CompoundIdentity

#Get-Mailbox -Identity $Global:TargetUser | select * | Out-String -Stream | sort



}

Function SentRcdSummary{
LastLogon

$dateEnd = get-date 
$dateStart = $dateEnd.AddHours(-48)

$CompoundIdentity = ($Global:TargetUser + $Global:SiteEMailSuffix)

Get-MessageTrace -StartDate $dateStart -EndDate $dateEnd -SenderAddress $CompoundIdentity | Select-Object Received, SenderAddress, RecipientAddress, Subject, Status, ToIP, FromIP, Size, MessageID, MessageTraceID | FT -AutoSize

<#
$dateEnd = get-date 
$dateStart = $dateEnd.AddHours(-48)

Get-MessageTrace -StartDate $dateStart -EndDate $dateEnd | Select-Object Received, SenderAddress, RecipientAddress, Subject, Status, ToIP, FromIP, Size, MessageID, MessageTraceID | Out-GridView 

#>




}

##############################################################################
####Tenant (Passive) functions
##############################################################################


Function GetDGroupsCount{

Get-DistributionGroup | select DisplayName,PrimarySmtpAddress,@{n="MemberCount";e={(Get-DistributionGroupMember $_.PrimarySmtpAddress | measure).Count}} | FT -AutoSize

}

Function TraceIncomingEMails{
#cls

Write-Host "[i] - 365 incoming E-Mail trace..."

#$Global:TargetEMail = "3006adi@gmail.com"
#$Global:TargetEMail = "PASM@hasla.org.uk"


$Global:TargetEMail = Read-Host "[?] - What EMail to trace?" 

$HoursInput = Read-Host "[?] - How many hours do you want to go back? " 
$Hours = ("-"+$HoursInput)

$dateEnd = get-date 
$dateStart = $dateEnd.AddHours($Hours)


Get-MessageTrace -SenderAddress $Global:TargetEMail -StartDate $dateStart -EndDate $dateEnd | Select-Object Received, SenderAddress, RecipientAddress, Subject, Status, ToIP, FromIP, Size, MessageID, MessageTraceID | FT


}



Function CheckHealth{

Get-SCEvent -SCSession $O365Session

}


Function Test{

$Global:ActiveMBCount = ((Get-Mailbox -resultsize unlimited).count)
Write-Host "[i] - Total Mailboxes: $Global:ActiveMBCount"

###List all mailboxes and last logon time. 
#Get-Mailbox -ResultSize Unlimited -RecipientTypeDetails UserMailbox,SharedMailbox | Get-MailboxStatistics | Sort-Object lastlogontime -Descending | Select-Object DisplayName,LastLogonTime


}

Function CountMBXs{

$Global:ActiveMBCount = ((Get-Mailbox -resultsize unlimited).count)
#Write-Host "[i] - Total Mailboxes: $Global:ActiveMBCount"

}



Function GetCalPermsOverviewEXAMPLE{
cls
#Get-MailboxCalendarFolder -Identity zvice@theburgesshillacademy.org.uk:\Calendar
#Get-MailboxFolderPermission -Identity t.sapolyo@theburgesshillacademy.org.uk:\Calendar

$Users = "t.sapolyo@theburgesshillacademy.org.uk", "zvice@theburgesshillacademy.org.uk", "principal@theburgesshillacademy.org.uk" 

ForEach ($User in $Users){

Write-Host ""
Write-Host "Checking calander permissions for $User ..." -ForegroundColor Cyan
$QryName = "$User"+":\Calendar"
Get-MailboxFolderPermission -Identity $QryName

}

}

##############################################################################
####Main run script section
##############################################################################

RunSummary
SiteSelectionMenu
CountMBXs
RunSummary
FunctionsMenu


#test
#GetCalPermsOverviewEXAMPLE