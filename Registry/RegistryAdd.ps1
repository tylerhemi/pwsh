$credential = Get-Credential
Invoke-Command -Credential $credential -computername chas4572  -ScriptBlock{
$Policies = Test-Path HKLM:\Software\Policies\Google
if($Policies -eq $False) {New-Item HKLM:\Software\Policies\Google}
$Policies = Test-Path HKLM:\Software\Policies\Google\Chrome
if($Policies -eq $False) {New-Item HKLM:\Software\Policies\Google\Chrome}
$Policies = Test-Path HKLM:\Software\Policies\Google\Chrome\ExtensionInstallForcelist
if($Policies -eq $False) {New-Item HKLM:\Software\Policies\Google\Chrome\ExtensionInstallForcelist}
New-ItemProperty -Path "HKLM:\Software\Policies\Google\Chrome\ExtensionInstallForcelist" -Name "15" -Value "phgddhgfnjjaobkeekohieahfingldac;https://clients2.google.com/service/update2/crx"
}