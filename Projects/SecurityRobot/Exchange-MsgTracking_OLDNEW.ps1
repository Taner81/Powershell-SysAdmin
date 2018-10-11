cls



#get-transportserver | get-messagetrackinglog -Recipients:A.Tyson@HASLA.org.uk -EventID "RECEIVE" -MessageSubject "HegartyMaths" -Start "10/05/2018 12:54:00" -End "14/05/2018 13:04:00"



Function Test{
Write-Host "===================="
Write-Host "=Received log. . . ="
Write-Host "===================="
#get-transportserver | get-messagetrackinglog -Recipients:A.Tyson@HASLA.org.uk -Sender "contact@hegartymaths.com" -EventID "RECEIVE" -Start "13/05/2018 12:54:00" -End "14/05/2018 13:04:00" | FT Sender, Recipients, TimeStamp, MessageSubject

get-transportserver | get-messagetrackinglog -Recipients:A.Tyson@HASLA.org.uk -Sender "postmaster@mail.hegartymaths.com" | FT Sender, Recipients, TimeStamp, MessageSubject

#contact@hegartymaths.com 
Write-Host "===================="
Write-Host "+Delivered log. . .="
Write-Host "===================="
#Get-TransportServer | get-messagetrackinglog -Recipients:A.Tyson@HASLA.org.uk -Sender "contact@hegartymaths.com" -EventID "DELIVER" -Start "13/05/2018 12:54:00" -End "14/05/2018 13:04:00" | SELECT Sender, Recipients, TimeStamp, MessageSubject



}



#get-transportserver | get-messagetrackinglog -Sender "Tim.Walker@asteccomputing.co.uk" -EventID "DELIVER" -Start "01/01/2018 12:54:00" -End "14/05/2018 13:04:00"

#get-transportserver | get-messagetrackinglog -Sender: "Tim.Walker@asteccomputing.co.uk" | Select MessageSubject, timestamp, EventID, recipients
 
#get-transportserver | get-messagetrackinglog -Recipients: "Tim.Walker@asteccomputing.co.uk" | Select MessageSubject, timestamp, EventID, Sender 

#get-transportserver | get-messagetrackinglog -Recipients: "david.mercer@compassfostering.com" -Sender: "T.Flynn@hasla.org.uk" | Select MessageSubject, timestamp, EventID, recipients, recipientstatus | Out-GridView

#get-transportserver | Get-MessageTrackingLog |ft MessageSubject,Sender,Timestamp,ClientIp,ClientHostname

Function 24HRStats{
$CountSentTest = (Get-TransportServer | get-messagetrackinglog -EventID "SEND" -Start (Get-Date).AddHours(-24) -ResultSize Unlimited).count
Write-Host "[i] - Total E-mails sent in last 24hrs = $CountSentTest"

$CountRcdTest = (Get-TransportServer | get-messagetrackinglog -EventID "RECEIVE" -Start (Get-Date).AddHours(-24) -ResultSize Unlimited).count
Write-Host "[i] - Total E-mails recieved in last 24hrs = $CountRcdTest"

$CountDvrdTest = (Get-TransportServer | get-messagetrackinglog -EventID "DELIVER" -Start (Get-Date).AddHours(-24) -ResultSize Unlimited).count
Write-Host "[i] - Total E-mails delivered in last 24hrs = $CountDvrdTest"

$CountFailTest = (Get-TransportServer | get-messagetrackinglog -EventID "FAIL" -Start (Get-Date).AddHours(-24) -ResultSize Unlimited).count
Write-Host "[i] - Total E-mails failed in last 24hrs = $CountFailTest"
}

#24HRStats

###Get all errors in last 24hrs 
#Get-TransportServer | get-messagetrackinglog -EventID "FAIL" -Start (Get-Date).AddHours(-24) -ResultSize Unlimited | Select <#MessageSubject,#> Timestamp, EventID, Sender, Recipients, Recipientstatus #| FT


Function Test2 {

#get-transportserver | Get-MessageTrackingLog -ResultSize Unlimited -Start (Get-Date).AddHours(-24) | where {$_.Sender -like "*@mail.hegartymaths.com"} | select-object Timestamp, <#SourceContext,#> Source, EventId, MessageSubject, Sender, {$_.Recipients} | FT #| export-csv C:\Externaldomain.com.txt

####
#get-transportserver | Get-MessageTrackingLog -ResultSize Unlimited | where {$_.Sender -like "*3006adi@gmail.com"} | select-object Timestamp, <#SourceContext,#> ClientIp, Source, EventId, MessageSubject, Sender, {$_.Recipients} | FT #| export-csv C:\TroubleEMail.csv

#get-transportserver | Get-MessageTrackingLog -ResultSize Unlimited | where {$_.Sender -like "*3006adi@gmail.com"} | select-object Timestamp, <#SourceContext,#> ClientIp, Source, EventId, MessageSubject, Sender, {$_.Recipients} | export-csv C:\TroubleEMailWithSenderIP.csv


#
get-transportserver | Get-MessageTrackingLog -ResultSize Unlimited -Start (Get-Date).AddHours(-48) | where {$_.Sender -like "*3006adi@gmail.com"} | select-object Timestamp, <#SourceContext,#> ClientIp, Source, EventId, MessageSubject, Sender, {$_.Recipients} | FT -AutoSize  #export-csv C:\TroubleEMailWithSenderIP.csv




#get-transportserver | Get-MessageTrackingLog -ResultSize Unlimited | where {$_.Recipients -like "*3006adi@gmail.com"} | select-object Timestamp, <#SourceContext,#> ClientIp, Source, EventId, MessageSubject, Sender, {$_.Recipients} | FT #| export-csv C:\TroubleEMail.csv


#Recipients

#get-transportserver | Get-MessageTrackingLog -EventID "DELIVER" -ResultSize Unlimited -Start (Get-Date).AddHours(-72) | where {$_.Sender -like "t.sapolyo@hasla.org.uk"} | select-object Timestamp, <#SourceContext,#> Source, EventId, MessageSubject, Sender, {$_.Recipients} | FT #| export-csv C:\Externaldomain.com.txt


#privacy@brightonacademiestrust.org.uk

}

Test2

#Get-MobileDeviceStatistics -Mailbox alias -GetMailboxLog:$true -NotificationEmailAddresses "t.sapolyo@hasla.org.uk"
