Connect-VIServer -Server tpvcsa01.chas.local -Credential $creds

$Servers = Get-VMHost 

foreach($server in $servers){
    $NTP =  Get-VMHostNtpServer -VMHost $server 
    foreach ($entry in $NTP) {
        Remove-VMHostNtpServer -NtpServer $entry -VMHost $server -Confirm:$False
    }
    Add-VMHostNtpServer -VMHost $server -NtpServer 10.16.0.16
}