$Groups = Get-DistributionGroup 

$Output= ForEach ($Group in $Groups){
    $Members =  Get-DistributionGroupMember -Identity $Group.Name | Select PrimarySMTPAddress
    $MembersJoined =  $Members.PrimarySMTPAddress -join ";"
    $Group.Name + "," + $MembersJoined
}
$Output | Out-File c:\temp\distro.csv
