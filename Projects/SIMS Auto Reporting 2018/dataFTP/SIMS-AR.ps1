
cls

# Determine script location for PowerShell
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
#Write-Host "Current script directory is $ScriptDir"

###Call in script settings from file

###$PSScriptRoot variable not available in  
#$ScriptSettings = "$PSScriptRoot\SIMS-AR-Settings.nfo"

$ScriptSettings = "C:\dataFTP\SIMS-AR-Settings.nfo"

Get-Content $ScriptSettings | foreach-object -begin {$h=@{}} -process { $k = [regex]::split($_,'='); if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $h.Add($k[0], $k[1]) } }

##Script Variables
$ScriptName = "SIMS CLI HASLA - v1.0 - 09/08/17"
$Line = "*****************************************************************"
$Col1 = "Cyan"
$Col2 = "Black"
$Col3 = "Green"
$Col4 = "Red"

Write-Output $Line
Write-Output $ScriptName
Write-Output $Line

###Output run config to console
Write-Host "[i] - USERNAME:"$h.Username
Write-Host "[i] - PASSWORD: *HIDDEN*"#$h.Password
Write-Host "[i] - REPORT 1 NAME:"$h.ReportName
Write-Host "[i] - REPORT 2 NAME:"$h.ReportName2
Write-Host "[i] - REPORT 3 NAME:"$h.ReportName3
Write-Host "[i] - REPORT 4 NAME:"$h.ReportName4
Write-Host "[i] - REPORT 4 NAME:"$h.ReportName5

Write-Host "[i] - OUTPUT PATH:"$h.OutputFile
Write-Host "[i] - OUTPUT PATH 2:"$h.OutputFile2
Write-Host "[i] - OUTPUT PATH 3:"$h.OutputFile3
Write-Host "[i] - OUTPUT PATH 4:"$h.OutputFile4
Write-Host "[i] - OUTPUT PATH 5:"$h.OutputFile5

$SIMSUsername = $h.Username
$Global:strFileName="C:\Program Files (x86)\SIMS\SIMS .net\CommandReporter.exe"


Function DecodePW{
$DecodedText = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($B64PW))
Write-host "[i] - Decoded PW is : $DecodedText"}

#DecodePW


Function CheckSCLR{
If (Test-Path $strFileName){
  # // File exists
  Write-Verbose "SCLR is installed on system, moving on...."
  Write-Host "[OK] - SCLR is installed on system, moving on...." -ForegroundColor Black -BackgroundColor Green

  Write-Verbose "[OK] - Attempting to run report...."
  Write-Host "[OK] - Attempting to run report...." -ForegroundColor Black -BackgroundColor Green


}Else{
  # // File does not exist
  Write-Verbose "[ERROR] - SCLR is NOT installed on system, stopping script...."
  Write-Host "[ERROR] - SCLR is NOT installed on system, stopping script...." -ForegroundColor Black -BackgroundColor Red
  Exit
  }
  }

 Function CleanUp{
 

$Now = Get-Date
$Days = "2" 
$Targetfolder = "C:\dataFTP" 
$Extension = "*.csv" 
$Lastwrite = $Now.AddDays(-$Days)

$Files = Get-ChildItem $Targetfolder -include $Extension -Recurse | where {$_.LastwriteTime -le "$Lastwrite"}

foreach ($File in $Files)
{
    if ($File -ne $Null)
    {
        write-host "Deleting File $File" -backgroundcolor "DarkRed"
        Remove-item $File.Fullname | out-null
    }
    else {write-host "No more files to delete" -forgroundcolor "Green"}
    }
} 

Function RunReport1{

$SIMSPW = $h.Password
$SIMSReport = $h.ReportName
$SIMSOutputFile = $h.OutputFile

$Arg1 = " /user:$SIMSUsername"
$Arg2 = " /password:$SIMSPW"
$Arg3 = " /report:`"$SIMSReport`""
$Arg4 = " /output:`"$SIMSOutputFile`""

###Build the commandline string/s for SIMS Commandline reporter exe
$DoTheThing = "$Arg1 $Arg2 $Arg3 $Arg4"
###Actually run the command
Start-Process $strFileName $DoTheThing -Wait
  
}

Function RunReport2{

$SIMSPW = $h.Password
$SIMSReport = $h.ReportName2
$SIMSOutputFile = $h.OutputFile2

$Arg1 = " /user:$SIMSUsername"
$Arg2 = " /password:$SIMSPW"
$Arg3 = " /report:`"$SIMSReport`""
$Arg4 = " /output:`"$SIMSOutputFile`""

###Build the commandline string/s for SIMS Commandline reporter exe
$DoTheThing = "$Arg1 $Arg2 $Arg3 $Arg4"
###Actually run the command
Start-Process $strFileName $DoTheThing -Wait
  
}

Function RunReport3{

$SIMSPW = $h.Password
$SIMSReport = $h.ReportName3
$SIMSOutputFile = $h.OutputFile3

$Arg1 = " /user:$SIMSUsername"
$Arg2 = " /password:$SIMSPW"
$Arg3 = " /report:`"$SIMSReport`""
$Arg4 = " /output:`"$SIMSOutputFile`""

###Build the commandline string/s for SIMS Commandline reporter exe
$DoTheThing = "$Arg1 $Arg2 $Arg3 $Arg4"
###Actually run the command
Start-Process $strFileName $DoTheThing -Wait
  
}

Function RunReport4{

$SIMSPW = $h.Password
$SIMSReport = $h.ReportName4
$SIMSOutputFile = $h.OutputFile4

$Arg1 = " /user:$SIMSUsername"
$Arg2 = " /password:$SIMSPW"
$Arg3 = " /report:`"$SIMSReport`""
$Arg4 = " /output:`"$SIMSOutputFile`""

###Build the commandline string/s for SIMS Commandline reporter exe
$DoTheThing = "$Arg1 $Arg2 $Arg3 $Arg4"
###Actually run the command
Start-Process $strFileName $DoTheThing -Wait
  
}

Function RunReport5{

$SIMSPW = $h.Password
$SIMSReport = $h.ReportName5
$SIMSOutputFile = $h.OutputFile5

$Arg1 = " /user:$SIMSUsername"
$Arg2 = " /password:$SIMSPW"
$Arg3 = " /report:`"$SIMSReport`""
$Arg4 = " /output:`"$SIMSOutputFile`""

###Build the commandline string/s for SIMS Commandline reporter exe
$DoTheThing = "$Arg1 $Arg2 $Arg3 $Arg4"
###Actually run the command
Start-Process $strFileName $DoTheThing -Wait
  
}


###Make sure SIMS CLR is installed, display and exit if not
CheckSCLR


###Run the actual reports
#Reports 1 and 2 only need to be run and transferred via FTP once only. Comment out the next two lines after these reports have been exported and sent.
#RunReport1
#RunReport2

#These three reports need to be run daily via the scheduled task. 
RunReport3
RunReport4
RunReport5


Write-Host "-=[REPORTS RUN COMPLETED]=-"

###Rename all .csv files to .txt file for AR's FTP process
Get-ChildItem -Path C:\dataFTP -Filter "*.csv" |
Where-Object { $_.CreationTime -gt (Get-Date).AddDays(-1) } |  Rename-Item -NewName {[System.IO.Path]::ChangeExtension($_.Name, ".txt")}

###Cleanup files over 2 days old. 
CleanUp

Write-Host "-=[Script COMPLETED]=-"

