#Get Key values to compare
$DefaultIMApp = Get-ItemPropertyValue -Path 'HKCU:\Software\IM Providers\' -Name 'DefaultIMApp'
$TurnOffPresenceIcon = Get-ItemPropertyValue -Path 'HKCU:\Software\Microsoft\Office\16.0\Common\IM' -Name  'TurnOffPresenceIcon'

#Below key doesn't exist in my registry and I will leave commented out unless needed.
#$TurnOffPresenceIntegration = Get-ItemPropertyValue -Path 'HKCU:\Software\Microsoft\Office\16.0\Common\IM' -Name 'TurnOffPresenceIntegration'

$PersonaMenuEnabled = Get-ItemPropertyValue -Path 'HKCU:\Software\Microsoft\Office\16.0\Common\PersonaMenu' -Name 'Enabled'

if ($DefaultIMApp -ne 'Lync') {
    Set-ItemProperty -Path 'HKCU:\Software\IM Providers\' -Name 'DefaultIMApp' -Value 'Lync'
    Write-Host "Changing default IMApp to Lync"
}
if ($PersonaMenuEnabled -ne '1') {
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Office\16.0\Common\PersonaMenu' -Name 'Enabled' -Value "1"
    Write-Host "Enabling presence icons in the TO:, From: and CC: bars."
}
if ($TurnOffPresenceIcon -ne '0') {
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Office\16.0\Common\IM' -Name 'TurnOffPresenceIcon'
    Write-Host "Enabling presence icon."
}