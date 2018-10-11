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

$Global:Site = ""
$Global:TargetUser = "[None Set]"


Function SiteSelectionMenu{

[int]$xMenuChoiceA = 0
while ( $xMenuChoiceA -lt 1 -or $xMenuChoiceA -gt 4 ){
Write-host "1. Hastings"
Write-host "2. St Leonards"
Write-host "3. Burgess Hill"
Write-host "4. Academies Central"
Write-host "5. Quit and exit"
[Int]$xMenuChoiceA = read-host "Please enter an option 1 to 4..." }
Switch( $xMenuChoiceA ){
  1{<#run an action or call a function here #>}
  2{<#run an action or call a function here #>}
  3{
  $Global:Site = "Burgess Hill" 
  #$AdminUsername = "tech@theburgesshillacademy.org.uk"
  $Global:AdminUsername = "t.sapolyo@theburgesshillacademy.org.uk"
  Connect365Outlook  
  }
  4{<#run an action or call a function here #>}
default{<#run a default action or call a function here #>}


}
}


Function FunctionsMenu{

[int]$xMenuChoiceA = 0
while ( $xMenuChoiceA -lt 1 -or $xMenuChoiceA -gt 4 ){
Write-host "1. User Actions"
Write-host "2. Tenant Actions"
Write-host "3. N/A"
Write-host "4. N/A"
Write-host "5. Quit and exit"
[Int]$xMenuChoiceA = read-host "Please enter an option 1 to 4..." }
Switch( $xMenuChoiceA ){
  1{$Global:TargetUser = read-host "Please enter a Username"
    RunSummary
    UserActionsMenu
    }
  2{<#run an action or call a function here #>}
  3{
  }
  4{<#run an action or call a function here #>}
default{<#run a default action or call a function here #>}
}
}

Function UserActionsMenu{

[int]$xMenuChoiceA = 0
while ( $xMenuChoiceA -lt 1 -or $xMenuChoiceA -gt 4 ){
Write-host "1. Get Mailbox details for $Global:TargetUser"
Write-host "2. N/A"
Write-host "3. N/A"
Write-host "4. ..."
Write-host "5. Quit and exit"
[Int]$xMenuChoiceA = read-host "Please enter an option 1 to 4..." }
Switch( $xMenuChoiceA ){
  1{GetUserMailboxDetails}
  2{<#run an action or call a function here #>}
  3{
  }
  4{<#run an action or call a function here #>}
default{<#run a default action or call a function here #>}
}
}

Function RunSummary{
cls
Write-Host $Line
Write-Host "Connected site:     $Site"
Write-Host "Admin username:     $AdminUsername"
Write-Host "Target user:        $Global:TargetUser"

Write-Host $Line
}


Function Connect365Outlook{

##Get some credentials
Write-Host "[i]-Gimme some credentials dude!..." -ForegroundColor $FCol1 -BackgroundColor $BCol1
$O365Cred = Get-Credential -Credential $AdminUsername


#$O365Cred = Get-Credential
$O365Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $O365Cred -Authentication Basic -AllowRedirection
Import-PSSession $O365Session -AllowClobber

}


Function GetUserMailboxDetails{

Get-Mailbox -Identity $Global:TargetUser | select * | Out-String -Stream | sort

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


SiteSelectionMenu
RunSummary
FunctionsMenu




#test


#GetCalPermsOverviewEXAMPLE