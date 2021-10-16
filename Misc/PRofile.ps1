##Customizations
Import-Module posh-git
Import-Module oh-my-posh
Set-PoshPrompt -Theme ys


#
Set-PSReadLineKeyHandler -Key Tab -Function Complete
#
$creds = Import-Clixml C:\temp\creds.xml
#
Function Connect-Exchange{
Set-ExecutionPolicy RemoteSigned
$UserCredential = Import-Clixml C:\temp\creds.xml
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://tp-exch-05.chas.local/PowerShell/ -Authentication Kerberos -Credential $UserCredential
Import-PSSession $Session -DisableNameChecking
}
#

#
Function Sync-ADC{
Invoke-Command -ComputerName tp-adc-01 -Credential $creds -ScriptBlock{Start-ADSyncSyncCycle -PolicyType Delta}
}
#
Function Connect-ExchangeOnline {
Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline -UserPrincipalName hemiadmin@chashealth.onmicrosoft.com
} 
#

Function ADUC {
Start-process powershell.exe -Credential $creds -ArgumentList "invoke-item C:\windows\system32\dsa.msc"
}