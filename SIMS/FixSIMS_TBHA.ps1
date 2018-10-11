####################################################################################
# HASLA - SCRIPT - POWERSHELL
# NAME: CopySIMS.ps1
# 
# AUTHOR:  	Taner
# DATE:  	05/12/16
# EMAIL: 	Taner@hasla.org.uk
# 
# COMMENT:  This tool is intended for use for HASLA ICT the support team.
#           This script is provided as-is, no liability is accepted for its use.
#           No liability is accepted for use outside of HASLA technical services.
#             
#
# VERSION HISTORY
# 1.0 - Initial version. 
# 1.1 - Added rename.
#
# TO ADD
# - Logging to central file,
# -
####################################################################################



cls
#Setup Script info
$ScriptName = "Manual SIMS Fix"
$Runtime0 = Get-Date
$Client= $env:computername
$Logfile = "C:\SIMSFixLog.txt"


#--Banner
Write-Host "================================================================================================="-BackgroundColor Black -ForegroundColor Yellow
Write-Host "$ScriptName                                                                                  "-BackgroundColor Black -ForegroundColor Yellow
Write-Host "                                              ¯\_(ツ)_/¯                      T.Sapolyo - 21/10/16"-BackgroundColor Black -ForegroundColor Yellow
Write-Host "============================================TanerSoft$([char]0x2122) 2016======================================"-BackgroundColor Black -ForegroundColor Yellow
write-host "[*]-Date/Time..........."-nonewline -BackgroundColor Black -ForegroundColor Yellow
Write-host $Runtime0 -BackgroundColor yellow -ForegroundColor black   
Write-host "[*]-Script running on..."-nonewline  -BackgroundColor Black -ForegroundColor yellow
write-host $Client -BackgroundColor yellow -ForegroundColor black
Write-host "[*]-Current Directory..."-nonewline  -BackgroundColor Black -ForegroundColor yellow
write-host $PWD -BackgroundColor yellow -ForegroundColor black
Write-Host "-------------------------------------------------------------------------------------------------" -BackgroundColor Black -ForegroundColor yellow
Write-host "[i]-Wherever possible this script should not be used."-BackgroundColor Black -ForegroundColor green
Write-host "[i]-The preferred method of sorting re-install of SIMS should be via Solus 3."-BackgroundColor Black -ForegroundColor green
Write-host "[i]-This script assumes you have a working good copy of SIMS locally, in the standard install path."-BackgroundColor Black -ForegroundColor green
Write-host "[i]-This script will also rename the remote SIMS install folder to SIMS-OLD."-BackgroundColor Black -ForegroundColor green
Write-host "================================================================================================="-BackgroundColor Black -ForegroundColor yellow    
$target = Read-Host -Prompt '[?]-Enter the computer name or IP address'



#Prep the copy thing
$SourceDir = "C:\Program Files\SIMS\SIMS .net"
$DestDir = "\\$target\c$\Program Files\SIMS\SIMS .net"


Function CheckPulsarProcess{
$ProcessName = "Pulsar.exe"

$Processes = Get-WmiObject -Class Win32_Process -ComputerName $Target -Filter "name='$ProcessName'"
if($Processes) {
    foreach ($process in $processes) {
    $processid = $process.handle
    $processcreationtime = $Process.Converttodatetime($Process.creationdate)
    Write-Host "[i]-$ProcessName found on $Target" -ForegroundColor Red
    write-host "[i]-The $ProcessName `($processid`) process creation time is $processcreationtime"
    Write-Host "[i]-Attempting to kill $ProcessName on $Target"
    (Get-WmiObject Win32_Process -ComputerName $Target | ?{ $_.ProcessName -match $ProcessName }).Terminate() | Out-Null
    Write-Host "[i]-$ProcessName killed on $Target" -ForegroundColor Green 
    CheckPulsarProcess
    }
} else {
    write-host "[OK]-No Process found with name $ProcessName" -ForegroundColor Green
    CheckRemoteSpace
}
#write-host ""

}


Function CheckRemoteSpace{
$disk = Get-WmiObject Win32_LogicalDisk -ComputerName $target -Filter "DeviceID='C:'" |
Select-Object Size,FreeSpace

#$disk.Size
#$disk.FreeSpace

$FriendlyDiskSize = $disk.Size/1gb
$FriendlyFreeSpace = $disk.FreeSpace/1gb

$DriveSize = [math]::Round($FriendlyDiskSize,2)
$FreeSpace = [math]::Round($FriendlyFreeSpace,2)


Write-Host "[i]-Drive Size on $Target is: $DriveSize GB" 
Write-Host "[i]-Free space on $Target is: $FreeSpace GB"

IF ($FreeSpace -gt 2){Write-Host "[ok]-Enough space to continue" -Foreground Green
CopyFiles
}
Else {Write-Host "[FAIL]-Not enough space to continue...Stopping Script" -Foreground Red }
}




Function CopyFiles{
#Rename Old Sims Folder
Rename-Item -path $destDir -newName "SIMS-OLD"

#Check variables
write-host "[OK]-Copying files"
write-host "[i]- Source Directory: $SourceDir"
write-host "[i]- Destination Directory: $DestDir"

#Do the copy thing
#Copy-Item -Force -Recurse $SourceDir -Destination $DestDir 


$files = Get-ChildItem -Path $SourceDir -Recurse
$filecount = $files.count
$i=0
Foreach ($file in $files) {
    $i++
    Write-Progress -activity "Copying SIMS files to $target..." -status "$file ($i of $filecount)" -percentcomplete (($i/$filecount)*100)
  
    # Determine the absolute path of this object's parent container.  This is stored as a different attribute on file and folder objects so we use an if block to cater for both
    if ($file.psiscontainer) {$sourcefilecontainer = $file.parent} else {$sourcefilecontainer = $file.directory}

    # Calculate the path of the parent folder relative to the source folder
    $relativepath = $sourcefilecontainer.fullname.SubString($SourceDir.length)

    # Copy the object to the appropriate folder within the destination folder
    Copy-Item $file.fullname ($DestDir + $relativepath) #-whatif
}
write-host "[OK]-COPY OF FILES COMPLETED!  =]"
Add-Content $Logfile "SIMS fixed on $Target"
}


CheckPulsarProcess
#CheckRemoteSpace