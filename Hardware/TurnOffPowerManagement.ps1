####Didn't work when tried on multiple computers 1010/19
$credential = Get-Credential
Invoke-Command -ComputerName Computer -Credential $credential -ScriptBlock {
$adapter = Get-NetAdapter | Get-NetAdapterPowerManagement
$adapter.AllowComputerToTurnOffDevice = 'Disabled'
$adapter | Set-NetAdapterPowerManagement -NoRestart}