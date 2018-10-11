$objUsers = get-mailbox -ResultSize Unlimited | select UserPrincipalName 
     
     
    #Iterate through all users     
    Foreach ($objUser in $objUsers) 
    {     
        #Connect to the users mailbox 
        $objUserMailbox = get-mailboxstatistics -Identity $($objUser.UserPrincipalName) | Select LastLogonTime 
         
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
        write-host "$strUserPrincipalName : $strLastLogonTime" }