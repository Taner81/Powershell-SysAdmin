Cls
##Script Variables
$ScriptName = "SIMS AR Systems Check - v1.0 - 12/09/18"
$Line = "*****************************************************************"
$Col1 = "Cyan"
$Col2 = "Black"
$Col3 = "Green"
$Col4 = "Red"

$psVersion = $PSVersionTable.PSVersion
$DesiredLocation = "C:\DataFTP"

###FTP Details for check function
$FTPIP = "10.188.0.45"
$UrlCfg = "ftp://"
$CompoundURL = ($UrlCfg + $FTPIP)


###Hash check files that should not be changed...
$File_SIMSARPS = "C:\DataFTP\SIMS-AR.ps1"
$FileHash_SIMSARPS = "B3-71-7D-2F-58-B4-5A-B6-CC-2F-E0-1E-FE-A0-64-AB"

$File_processbat = "C:\DataFTP\process.bat"
$FileHash_processbat = "0F-2F-D9-01-0F-06-A1-8A-5D-D8-E1-4F-56-BA-FD-42" 

$File_runbat = "C:\DataFTP\run.bat"
$FileHash_runbat = "B3-B7-B5-63-92-DE-6F-1D-29-07-5C-E0-79-B5-CF-67" 

$File_runftpbat = "C:\DataFTP\runftp.bat"
$FileHash_runftpbat = "8D-81-84-EE-FB-51-2C-51-0C-B8-A1-C6-BF-D9-8F-D2" 

###Hash check files that need to be changed...
$File_SIMSARSettings = "C:\DataFTP\SIMS-AR-Settings.nfo"
$FileHash_SIMSARSettings = "42-DE-AF-70-0F-0C-A0-F8-30-2C-17-25-27-EF-AF-9A"

$File_DFENumber = "C:\DataFTP\dfenumber.nfo"
$FileHash_DFENumber = "D6-25-9F-AC-79-E7-82-6E-A3-DF-47-72-AD-A6-E5-EE"



Function CheckExecPolicy{
Write-Host $Line
Write-Host "[i] - Checking PS ExecutionPolicy..."

$Policy = "Unrestricted"
If ((get-ExecutionPolicy) -ne $Policy) {
    Write-Host "[Fail] - Execution Policy is not set as $Policy" -ForegroundColor red
    }
    Else{
    Write-Host "[OK] - Execution Policy is set as $Policy" -ForegroundColor Green
    #Set-ExecutionPolicy $Policy -Force

}

}

Function CheckPSVersion{
Write-Host $Line
Write-Host "[i] - Checking PS Version..."

If ($psVersion)
{
    #PowerShell Version Mapping
    $psVersionMappings = @()
    $psVersionMappings += New-Object PSObject -Property @{Name='5.1.14393.0';FriendlyName='Windows PowerShell 5.1 Preview';ApplicableOS='Windows 10 Anniversary Update'}
    $psVersionMappings += New-Object PSObject -Property @{Name='5.1.14300.1000';FriendlyName='Windows PowerShell 5.1 Preview';ApplicableOS='Windows Server 2016 Technical Preview 5'}
    $psVersionMappings += New-Object PSObject -Property @{Name='5.0.10586.494';FriendlyName='Windows PowerShell 5 RTM';ApplicableOS='Windows 10 1511 + KB3172985 1607'}
    $psVersionMappings += New-Object PSObject -Property @{Name='5.0.10586.122';FriendlyName='Windows PowerShell 5 RTM';ApplicableOS='Windows 10 1511 + KB3140743 1603'}
    $psVersionMappings += New-Object PSObject -Property @{Name='5.0.10586.117';FriendlyName='Windows PowerShell 5 RTM 1602';ApplicableOS='Windows Server 2012 R2, Windows Server 2012, Windows Server 2008 R2 SP1, Windows 8.1, and Windows 7 SP1'}
    $psVersionMappings += New-Object PSObject -Property @{Name='5.0.10586.63';FriendlyName='Windows PowerShell 5 RTM';ApplicableOS='Windows 10 1511 + KB3135173 1602'}
    $psVersionMappings += New-Object PSObject -Property @{Name='5.0.10586.51';FriendlyName='Windows PowerShell 5 RTM 1512';ApplicableOS='Windows Server 2012 R2, Windows Server 2012, Windows Server 2008 R2 SP1, Windows 8.1, and Windows 7 SP1'}
    $psVersionMappings += New-Object PSObject -Property @{Name='5.0.10514.6';FriendlyName='Windows PowerShell 5 Production Preview 1508';ApplicableOS='Windows Server 2012 R2'}
    $psVersionMappings += New-Object PSObject -Property @{Name='5.0.10018.0';FriendlyName='Windows PowerShell 5 Preview 1502';ApplicableOS='Windows Server 2012 R2'}
    $psVersionMappings += New-Object PSObject -Property @{Name='5.0.9883.0';FriendlyName='Windows PowerShell 5 Preview November 2014';ApplicableOS='Windows Server 2012 R2, Windows Server 2012, Windows 8.1'}
    $psVersionMappings += New-Object PSObject -Property @{Name='4.0';FriendlyName='Windows PowerShell 4 RTM';ApplicableOS='Windows Server 2012 R2, Windows Server 2012, Windows Server 2008 R2 SP1, Windows 8.1, and Windows 7 SP1'}
    $psVersionMappings += New-Object PSObject -Property @{Name='3.0';FriendlyName='Windows PowerShell 3 RTM';ApplicableOS='Windows Server 2012, Windows Server 2008 R2 SP1, Windows 8, and Windows 7 SP1'}
    $psVersionMappings += New-Object PSObject -Property @{Name='2.0';FriendlyName='Windows PowerShell 2 RTM';ApplicableOS='Windows Server 2008 R2 SP1 and Windows 7'}
    foreach ($psVersionMapping in $psVersionMappings)
    {
        If ($psVersion -ge $psVersionMapping.Name) {
            @{CurrentVersion=$psVersion;FriendlyName=$psVersionMapping.FriendlyName;ApplicableOS=$psVersionMapping.ApplicableOS}
            Break
        }
    }
}
Else{
    @{CurrentVersion='1.0';FriendlyName='Windows PowerShell 1 RTM';ApplicableOS='Windows Server 2008, Windows Server 2003, Windows Vista, Windows XP'}
}
Write-Host $Line
}

Function CheckFilesLocation{
Write-Host $Line
Write-Host "[i] - Checking location of script files..."

If ($PSScriptRoot -eq $DesiredLocation){
    Write-Host "[ok] - Files are where they should be, in $DesiredLocation" -ForegroundColor Green
    }
    else{
    Write-Host "[Fail] - Files are not where they should be, in $DesiredLocation, instead they are in $PSSCriptRoot" -ForegroundColor Red
    }
Write-Host $Line
}

Function CheckFTPSvr{

Write-Host $Line

try
{
    $ftprequest = [System.Net.FtpWebRequest]::Create($CompoundUrl)
    $ftprequest.Credentials = New-Object System.Net.NetworkCredential("wrong", "wrong") 
    $ftprequest.Method = [System.Net.WebRequestMethods+Ftp]::PrintWorkingDirectory
    $ftprequest.GetResponse()

    Write-Host "Unexpected success, but OK."
}
catch
{
    if (($_.Exception.InnerException -ne $Null) -and
        ($_.Exception.InnerException.Response -ne $Null) -and
        ($_.Exception.InnerException.Response.StatusCode -eq
             [System.Net.FtpStatusCode]::NotLoggedIn))
    {
        Write-Host "[Ok] - FTP Connectivity to $CompoundURL OK." -ForegroundColor Green
    }
    else
    {
        Write-Host "[Fail] - Unexpected error connecting to $CompoundURL : $($_.Exception.Message)" -ForegroundColor Red
    }
}


}

Function CheckMD5s{
Write-Host "[i] - Checking integrity of settings files..."
$md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider

#SIMS-AR-Settings.nfo
$hash1 = [System.BitConverter]::ToString($md5.ComputeHash([System.IO.File]::ReadAllBytes($File_SIMSARSettings)))
#dfenumber.nfo
$hash2 = [System.BitConverter]::ToString($md5.ComputeHash([System.IO.File]::ReadAllBytes($File_DFENumber)))

#SIMS-AR.ps1
$hash3 = [System.BitConverter]::ToString($md5.ComputeHash([System.IO.File]::ReadAllBytes($File_SIMSARPS)))
$hash4 = [System.BitConverter]::ToString($md5.ComputeHash([System.IO.File]::ReadAllBytes($File_runbat)))
$hash5 = [System.BitConverter]::ToString($md5.ComputeHash([System.IO.File]::ReadAllBytes($File_processbat)))
$hash6 = [System.BitConverter]::ToString($md5.ComputeHash([System.IO.File]::ReadAllBytes($File_runftpbat)))


###Check the settings file to make sure it has been modified with the school detail as required...
If ($hash1 -eq $FileHash_SIMSARSettings){
    Write-Host "[i] - Hashes match for the $File_SIMSARSettings file.." -ForegroundColor Green
    Write-Host "Expected Value: $FileHash_SIMSARSettings" -ForegroundColor Cyan
    Write-Host "Computed value: $hash1" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "[Instruction]" -ForegroundColor Yellow
    Write-Host "You will need to update this settings file with the reporting SIMS username and password you've created for your site" -ForegroundColor Yellow
    Write-Host ""
}
    Else{
    Write-Host "[i] - Hashes do not match for the $File_SIMSARSettings file.." -ForegroundColor Red
    Write-Host "Expected Value: $FileHash_SIMSARSettings" -ForegroundColor Cyan
    Write-Host "Computed value: $hash1" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "[Instruction]" -ForegroundColor Yellow
    Write-Host "Ok, Great! looks like you've added the SIMS reporting user details to the $File_SIMSARSettings settings file.  " -ForegroundColor Yellow
    Write-Host "Nice job!" -ForegroundColor Yellow
    Write-Host ""
}


If ($hash2 -eq $FileHash_DFENumber){
    Write-Host "[i] - Hashes match for the $File_DFENumber file.." -ForegroundColor Green
    Write-Host "Expected Value: $FileHash_DFENumber" -ForegroundColor Cyan
    Write-Host "Computed value: $hash2" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "[Instruction]" -ForegroundColor Yellow
    Write-Host "You will need to change the settings file to contain the schools DFES number." -ForegroundColor Yellow
    Write-Host "You can obtain this from SIMS if you are unsure." -ForegroundColor Yellow
    Write-Host ""

}
    Else{
    Write-Host "[i] - Hashes do not match for the $File_DFENumber file.." -ForegroundColor Red
    Write-Host "Expected Value: $FileHash_DFENumber" -ForegroundColor Cyan
    Write-Host "Computed value: $hash2" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "[Instruction]" -ForegroundColor Yellow
    Write-Host "Ok, Great! looks like you've changed the $File_DFENumber file to reflect the schools DFES number." -ForegroundColor Yellow
    Write-Host "Nice job!" -ForegroundColor Yellow
    Write-Host ""

}

Write-Host "[i] - Checking integrity of script files..."

Write-Host "$File_SIMSARPS..."
If($Hash3 -eq $FileHash_SIMSARPS){
Write-Host "$Hash3 - Computed"
Write-Host "$FileHash_SIMSARPS - Expected"
Write-Host "[ok] - Hashes match! ... Moving on..."-ForegroundColor Green
}
Else{
Write-Host "$Hash3 - Computed"
Write-Host "$FileHash_SIMSARPS - Expected"
Write-Host "[Fail] - Hashes do not match! Obtain a fresh copy of the script files."-ForegroundColor red
}
Write-Host "$File_runbat..."
If($Hash4 -eq $FileHash_runbat){
Write-Host "$Hash4 - Computed"
Write-Host "$FileHash_runbat - Expected"
Write-Host "[ok] - Hashes match! ... Moving on..."-ForegroundColor Green
}
Else{
Write-Host "$Hash4 - Computed"
Write-Host "$FileHash_SIMSARPS - Expected"
Write-Host "[Fail] - Hashes do not match! Obtain a fresh copy of the script files."-ForegroundColor red
}
Write-Host "$File_processbat..."
If($Hash5 -eq $FileHash_processbat){
Write-Host "$Hash5 - Computed"
Write-Host "$FileHash_processbat - Expected"
Write-Host "[ok] - Hashes match! ... Moving on..."-ForegroundColor Green
}
Else{
Write-Host "$Hash5 - Computed"
Write-Host "$FileHash_processbat - Expected"
Write-Host "[Fail] - Hashes do not match! Obtain a fresh copy of the script files."-ForegroundColor red
}
Write-Host "$File_runftpbat..."
If($Hash6 -eq $FileHash_runftpbat){
Write-Host "$Hash6 - Computed"
Write-Host "$FileHash_runftpbat - Expected"
Write-Host "[ok] - Hashes match! ... Moving on..."-ForegroundColor Green
}
Else{
Write-Host "$Hash6 - Computed"
Write-Host "$FileHash_runftpbat - Expected"
Write-Host "[Fail] - Hashes do not match! Obtain a fresh copy of the script files."-ForegroundColor red
}



<#
Write-Host "[i] - $hash1 = $File_SIMSARSettings" 
Write-Host "[i] - $hash2 = $File_DFENumber" 
Write-Host "[i] - $hash3 = $File_SIMSARPS" 
Write-Host "[i] - $hash4 = $File_runbat" 
Write-Host "[i] - $hash5 = $File_processbat" 
Write-Host "[i] - $hash6 = $File_runftpbat" 
#>

}


###Call the functions
CheckExecPolicy
CheckFilesLocation
CheckMD5s
CheckFTPSvr
CheckPSVersion

##End
Write-Host $Line
Write-Host "-=[CHECKS COMPLETE]=-"
Write-Host $Line
