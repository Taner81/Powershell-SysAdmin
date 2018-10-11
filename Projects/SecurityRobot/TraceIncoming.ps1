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


TraceIncomingEMails