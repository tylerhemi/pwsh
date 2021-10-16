

$VMHosts = Get-VMHost ibesxi01.chas.local

foreach($VMhost in $VMHosts)
    {
        Get-VMHost $VMhost | Set-VMHostSysLogServer 'udp://10.16.0.25:1606'
        Get-VMHostFireWallException -VMHost $VMhost -Name Syslog | Set-VMHostFirewallException -Enabled:$True
        Get-VMHostService -VMHost $VMhost | Where-Object {$_.Key -eq 'vmsyslogd'} | Restart-VMHostService -confirm:$false
    }