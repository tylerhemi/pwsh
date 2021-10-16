#Get all AD servers excluding XENAPP servers.
$Servers = Get-ADComputer -Filter {OperatingSystem -like '*windows*server*' -and Name -notlike '*XEN*'}
#Filter out TPFS02 and TP-FS-02
$NonFileServers = $Servers | Where-Object {$_.Name -ne "tp-fs-02" -and $_.Name -ne "tpfs02"}


foreach ($server in $NonFileServers) {
    Invoke-Command $server.DNSHostName -Credential (Import-Clixml C:\temp\creds.xml) -ScriptBlock {
        Stop-Service Spooler -Force
        Set-Service Spooler -StartupType Disabled
        hostname; Get-Service Spooler | Select-Object Name, Status, StartType}
}