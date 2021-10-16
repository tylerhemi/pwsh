##Powershell script to setup APC UPS
#Tyler Hemingsen 2/2/2021
###Must be run in Windows Powershell
# Requires module posh-ssh https://github.com/darkoperator/Posh-SSH/blob/master/docs/New-SSHSession.md


#UPS Name
$UPS = Read-Host "Enter UPS Name"

$cred = Get-Credential

#Create the SSH stream
$ssh = New-SSHSession -ComputerName $UPS -Credential $cred -AcceptKey 
$Stream = New-SSHShellStream -SSHSession $ssh 
#Sets date format
$Stream.WriteLine("date -f mm/dd/yyyy")
#Sets timezone
$Stream.WriteLine("date -z -08:00")
#Sets low battery at 14 minutes
$Stream.WriteLine("cfgshutdn -lo 14")
#Disable telnet
$Stream.WriteLine("console -t disable")
#Disable FTP
$stream.WriteLine("ftp -S disable")
#Set DNS to synchronize system and hostname, sets domain name to chas.local
$Stream.WriteLine("dns -y enable -d chas.local")
#configure snmp
$stream.WriteLine("snmp -S enable -c1 hatenextgen -a1 read -n1 10.16.0.10 ")
$stream.WriteLine("snmp -a2 disable")
$stream.WriteLine("snmp -a3 disable")
$stream.WriteLine("snmp -a4 disable")
#Disable snmpv3
$stream.WriteLine("snmpv3 -S disable")
#Overrite manual settings and specify NTP servers
$stream.WriteLine("ntp -e -OM enable -p 10.16.0.12 -s 0.us.pool.ntp.org -u update now")
#Disable HTTP and enable HTTPS
$stream.WriteLine("web -h disable -s enable")
#blank send to make it happy? weird cli apc has
####This changes the password from our old APC password to new 16 char one.
$Stream.WriteLine('user -n -cp  -pw ')
#create backup admin
$Stream.WriteLine('user -n  -pw  -e enable -pe Super User')
$stream.WriteLine(" ")

Start-Sleep 5



#Review for any errors - Anything other than [E000] [E001] and [E002] indicates an error.
#Reference https://iportal2.schneider-electric.com/Contents/docs/UPS-PMAR-9LLM9N_R1_EN.PDF
$Stream.Read()


#If no errors prompt to continue script
$reboot = Read-Host "Do you want to restart the UPS Network Management Card? (y/n)"
if ($reboot -eq 'y')
    {
        $Stream.WriteLine("reboot")
        $Stream.WriteLine("YES")
    }
else {
    Write-Host "You will need to login to the UPS at $UPS and restart the Network Management Card."
}

#Remove the SSH session
Get-SSHSession | Remove-SSHSession

