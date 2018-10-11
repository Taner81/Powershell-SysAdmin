cls
$TheUser = "KScorgie"
$UserEMail = "KScorgie@theburgesshillacademy.org.uk"
$Line = "**********************************************************************************************************"
$Days = "-14"

Function MobileDevices{
Write-Host $Line
$MobileDevices = (Get-MobileDeviceStatistics -Mailbox:$TheUser | Select FirstSyncTime, LastSyncAttemptTime, LastSuccessSync, DeviceType, DeviceID, DeviceUserAgent  | FT)

If ($MobileDevices -eq $Null){Write-Host "No connected mobile devices...."}
Else
{$MobileDevices}
}


Function SentRcdList{

Write-Host $Line
Write-Host "[i] - E_Mail Sent and recieved in last $Days hours..."
Get-MessageTrace -StartDate (Get-Date).Adddays($Days) -EndDate (Get-Date) -SenderAddress $UserEMail
Get-MessageTrace -StartDate (Get-Date).Adddays($Days) -EndDate (Get-Date) -RecipientAddress $UserEMail
Write-Host $Line
<#
Get-MessageTrace -StartDate (Get-Date).Adddays(-1) -EndDate (Get-Date) -SenderAddress $UserEMail | select messageid -unique | measure
Get-MessageTrace -StartDate (Get-Date).Adddays(-1) -EndDate (Get-Date) -RecipientAddress $UserEMail | select messageid -unique | measure
#>
}


Function SentRcdSummary{
Write-Host $Line
$SentAmt = (Get-MessageTrace -StartDate (Get-Date).Adddays($Days) -EndDate (Get-Date) -SenderAddress $UserEMail | select messageid | measure | Select-Object -expand count)
Write-Host "[i] - $UserEMail has sent $SentAmt E-Mails in the last $Days hours"

$RcdAmt = (Get-MessageTrace -StartDate (Get-Date).Adddays($Days) -EndDate (Get-Date) -RecipientAddress $UserEMail | select messageid | measure | Select-Object -expand count)
Write-Host "[i] - $UserEMail has recieved $RcdAmt E-Mails in the last $Days hours"

}

MobileDevices
SentRcdSummary
SentRcdList