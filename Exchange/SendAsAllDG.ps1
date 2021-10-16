#Run via remote Exchange Powershell on with Exchange Imported MMC
$List = @()
$DistroList = Get-DistributionGroup * -ResultSize Unlimited | Select DisplayName -ExpandProperty DisplayName

Foreach ($Group in $DistroList){
   $SendAs =  Get-DistributionGroup $Group | Get-ADPermission | Where-Object {($_.ExtendedRights -like "*Send-As*" -and $_.User -ne "NT AUTHORITY\SELF")} 
   if($Null -ne $SendAs){
       $List += $Group + ":" + $SendAs.User + "`n"
   }
}