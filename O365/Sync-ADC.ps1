Function Sync-ADC{
$cred = Import-Clixml C:\temp\creds.xml
Invoke-Command -ComputerName tp-adc-01 -Credential $cred -ScriptBlock{Start-ADSyncSyncCycle -PolicyType Delta}
}