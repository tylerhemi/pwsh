$TeamsVersion = Get-ChildItem $Env:LOCALAPPDATA\Microsoft\TeamsMeetingAddin\ | Where-Object {$_.Name -like "1.0.*"} | Select-Object Name -ExpandProperty Name

$Teams64 = "%SystemRoot%\System32\regsvr32.exe /n /i:user %LocalAppData%\Microsoft\TeamsMeetingAddin\$TeamsVersion\x64\Microsoft.Teams.AddinLoader.dll"
$Teams32 = "%SystemRoot%\SysWOW64\regsvr32.exe /n /i:user %LocalAppData%\Microsoft\TeamsMeetingAddin\$TeamsVersion\x86\Microsoft.Teams.AddinLoader.dll"

cmd /c $Teams64
cmd /c $Teams32
Write-Output "Please Reboot!"
