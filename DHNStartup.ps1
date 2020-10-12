#Params
param([string]$usernm = "(redacted)", [string]$passw="(redacted)") 
$global:usernm = $usernm
$global:passw = $passw
$ProcessName = "DocHaloNotifier"
$date = (Get-Date).ToString("yyyy-MM-dd hh:mm:ss")
$Run = echo "Running Halo"
$Not = echo "Not running Halo" 
$Already = echo "Running Halo, exiting"


#Check if 32 or 64 bit and set path.
if ((Get-WmiObject -Class Win32_OperatingSystem -ea 0).OSArchitecture -eq "64-bit")
{
    $Halo = "C:\Program Files (x86)\DocHaloNotifier\DocHaloNotifier.exe" 
}
else
{
    $Halo = "C:\Program Files\DocHaloNotifier\DocHaloNotifier.exe"
}

#Check if process running and log.
$Running = if((get-process $ProcessName -ErrorAction SilentlyContinue) -eq $Null)
{ $Not }else{ $Run }

$Syntax = $Running+" "+$global:usernm+" "+$global:passw+" "+$date
$Syntax | Out-File C:\Temp\dhnlog.txt -Append

$Arguments = "user:"+$global:usernm+"@halocommunications.com:"+$global:passw

if ($Not) 
{
    Start-Process -FilePath $Halo $Arguments
}
else
{
    Exit-PSSession
}
#Check second run and log.

$NextRun = if((get-process $ProcessName -ErrorAction SilentlyContinue) -eq $Null)
{ $Not } else { $Already}
$Syntax = $NextRun+" "+$global:usernm+" "+$global:passw+" "+$date
$Syntax | Out-File C:\Temp\dhnlog.txt -Append