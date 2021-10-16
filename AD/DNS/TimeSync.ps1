$AllDomainControllers = Get-ADComputer -LDAPFilter "(&(objectCategory=computer)(userAccountControl:1.2.840.113556.1.4.803:=8192))"                                                                                                                                                                                                                                                                                                                                                                                                            
$cred = Import-Clixml C:\temp\creds.xml

ForEach ($DC in $AllDomainControllers){
    $DCServer = $DC.name
    Invoke-Command -ComputerName $DCServer -Credential $cred -ScriptBlock {HOSTNAME.EXE;w32tm /resync}
}