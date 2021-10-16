$MemApps = 'HKLM:\SOFTWARE\Microsoft\IntuneManagementExtension\Win32Apps\'
$Users = Get-ChildItem -Path $MemApps -Exclude 'reporting'

$appID = 'c3dccdb6-1ea7-4546-a0b2-962988ac37db' #APPID static
#$appID = Read-Host "Enter Application GUID"

foreach ($User in $Users) {
    $Path = -join ($User.Name.replace( 'HKEY_LOCAL_MACHINE', 'HKLM:'), '\', "$appID", '_1')
    if (Test-Path $Path) {
        Remove-Item $Path -Force -Recurse
        Write-Host "Removed Registry key for $User"
    }
}

Restart-Service IntuneManagementExtension