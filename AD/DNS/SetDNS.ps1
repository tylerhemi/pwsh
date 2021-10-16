$cred = Import-Clixml C:\temp\creds.xml
$DCs = Get-ADDomainController -Filter *

foreach ($DC in $DCS){
    Invoke-Command $DC -Credential $cred -ScriptBlock{
        $Interface = Get-NetIPInterface -AddressFamily IPV4 | Sort-Object InterfaceMetric | Select-Object -First 1 
        $Ip = $interface | Get-NetIPAddress -AddressFamily IPV4 | Select-Object -ExpandProperty IpAddress
        $Interface | Set-DnsClientServerAddress -ServerAddresses ("$Ip","10.16.0.12","10.16.0.21") -PassThru 
    }
}