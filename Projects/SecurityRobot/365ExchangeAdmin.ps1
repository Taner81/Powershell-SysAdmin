














#https://sysadmin.compxtreme.ro/editing-calendar-permissions-office-365-with-powershell/


Function Connect365Outlook{
$O365Cred = Get-Credential
$O365Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $O365Cred -Authentication Basic -AllowRedirection
Import-PSSession $O365Session -AllowClobber
}

Function GetCalPermsSpecificUserEXAMPLE{
###Broken?
$Test = (Get-MailboxFolderPermission -Identity zvice@theburgesshillacademy.org.uk:\Calendar -User PRidley@theburgesshillacademy.org.uk)
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


Function GrantCalPermsEXAMPLE{


$UserCal = ""


Add-MailboxFolderPermission -Identity zvice@theburgesshillacademy.org.uk:\calendar -user PRidley@theburgesshillacademy.org.uk -AccessRights Reviewer


}


Function FindBadMail{


Get-MessageTrackingLog -ResultSize Unlimited | where {$_.Sender -like "*3006adi@gmail.com"} | select-object Timestamp, <#SourceContext,#> ClientIp, Source, EventId, MessageSubject, Sender, {$_.Recipients} | FT -AutoSize #| export-csv C:\TroubleEMailWithSenderIP.csv



}

Connect365Outlook

FindBadMail

#Connect365Outlook
#GetCalPermsSpecificUserEXAMPLE
#GetCalPermsOverviewEXAMPLE
#GrantCalPermsEXAMPLE
#GetCalPermsOverviewEXAMPLE