$users = "skeblawi","kwinkle","LMccully","KGarrison","TBrower"
foreach ($user in $users){
    Add-ADGroupMember -Members $user -Identity "NPRC_Shared_RW" -Credential (Import-Clixml C:\temp\creds.xml)
}