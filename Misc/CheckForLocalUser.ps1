

$Credential = Import-Clixml C:\temp\creds.xml
#Get list of servers
$servers = Get-ADComputer -Filter 'operatingsystem -like "*server*" -and enabled -eq "true"' | Select Name -ExpandProperty Name
#array for storing servers that are missing user
$MissingUserAccount = $null
ForEach($server in $servers)    {
$Output = Invoke-Command -ComputerName $server -Credential $Credential -Scriptblock {
   Get-LocalUser "redacted" -ErrorAction SilentlyContinue
} 
If($Output = "Get-LocalUser: User  was not found.") {
    $MissingUserAccount = $MissingUserAccount + "`n" + $server
  }
}

Write-Host $MissingUserAccount