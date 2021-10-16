Stop-service Spooler
Set-Location "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print\Providers\Client Side Rendering Print Provider\Servers"
Remove-Item tpfs02 -recurse
Start-service Spooler