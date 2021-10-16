$cred = Import-Clixml C:\temp\creds.xml
$DCS = Get-ADComputer -SearchBase "OU=Domain Controllers,DC=chas,DC=local" -Filter * | select Name -ExpandProperty Name

foreach ($DC in $DCS){

Invoke-Command $DC -Credential $cred -ScriptBlock{
[datetime]$RestartTime = '11PM'
[datetime]$CurrentTime = Get-Date
[int]$WaitSeconds = ( $RestartTime - $CurrentTime ).TotalSeconds
shutdown -r -t $WaitSeconds -f
}
}