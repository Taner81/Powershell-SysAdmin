        Add-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010
        . $env:ExchangeInstallPath\bin\RemoteExchange.ps1
        Connect-ExchangeServer –auto