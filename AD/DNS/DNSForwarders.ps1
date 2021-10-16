$cred = Import-Clixml C:\temp\creds.xml
$DCs = Get-ADDomainController -Filter *

foreach ($DC in $DCs){
    Invoke-Command $DC -Credential $cred -ScriptBlock{
        Set-DnsServerForwarder -IPAddress "8.8.8.8","8.8.4.4" -PassThru
    }
}