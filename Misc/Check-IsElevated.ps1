Function Check-IsElevated
{

#Get information about current user
$id = [System.Security.Principal.WindowsIdentity]::GetCurrent()
#Create a new powershell object
$pobj = New-Object System.Security.Principal.WindowsPrincipal($id)

if ($pobj.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator))
{    Write-Output $true }
else 
{    Write-Output $false }

}