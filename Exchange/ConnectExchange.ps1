Function Connect-Exchange{
Set-ExecutionPolicy RemoteSigned
$UserCredential = Import-Clixml C:\temp\creds.xml
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://tp-exch-05.chas.local/PowerShell/ -Authentication Kerberos -Credential $UserCredential
Import-PSSession $Session -DisableNameChecking
}
#Remove-PSsession  $session