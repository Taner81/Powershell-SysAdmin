cls

###Message Stuff 
$TeamsID = 'https://outlook.office.com/webhook/7dcf6e58-7f0b-4d7d-be0c-b8db549c6233@c543609f-76f9-4b7a-a14e-6a88b4ca8e9e/IncomingWebhook/5fefeaa150aa4c979804f60bb1b61211/cbdc964c-38b7-45b8-8ef0-1917c07b107c'

$Button1 = New-TeamsButton -Name 'Login to UOBAT Helpdesk' -Link "https://Reddit.com"
#$Fact1 = New-TeamsFact -Name 'PS Version' -Value "**$($PSVersionTable.PSVersion)**"
#$Fact2 = New-TeamsFact -Name 'PS Edition' -Value "**$($PSVersionTable.PSEdition)**"
#$Fact3 = New-TeamsFact -Name 'OS' -Value "**$($PSVersionTable.OS)**"
#$Alert1 = New-TeamsFact -Name 'ALERT' -Value 
$CurrentDate = Get-Date

Function SendTmsg{

$Section = New-TeamsSection `
    -ActivityTitle "**SECURITY ALERT**" `
    -ActivitySubtitle "@Security Team - $CurrentDate" `
    -ActivityImage Add `
    -ActivityText "This is an automatic message, please double-check the alert detail." `
    -Buttons $Button1 `
    -ActivityDetails $Alert1 #$Fact1, $Fact2, $Fact3

Send-TeamsMessage `
    -URI $TeamsID `
    -MessageTitle 'Security Robot' `
    -MessageText "This text won't show up" `
    -Color DodgerBlue `
    -Sections $Section
}



$ServerName = Get-Content "c:\ADServers.txt"  
  
foreach ($Server in $ServerName) {  
  
        if (test-Connection -ComputerName $Server -Count 2 -Quiet ) {   
          
            Write-Host "$Server is Pinging " -Fore Green  
          
                    } else  
                      
                    {Write-Host "$Server not pinging"  -Fore Red
                    $Alert1 = New-TeamsFact -Name 'ALERT' -Value "$Server not pinging"
                    SendTmsg

                    }      
          
} 

