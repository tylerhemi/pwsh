$cred = Import-Clixml C:\temp\creds.xml
$DMZServers = 

foreach($server in $DMZServers){
    Invoke-Command -ComputerName $server -Credential $cred -ScriptBlock{
        if ((Get-ItemProperty -Path 'HKLM:SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL3.0' -Name Server -ErrorAction SilentlyContinue).Enabled -ne "0") {
            Write-Host "Disabling SSL3.0" -ForegroundColor Yellow
        }
    }
}