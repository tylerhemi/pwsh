Connect-Exchange
Get-DistributionGroup HealthRecordsAll | Get-ADPermission | Where {($_.ExtendedRights -like "*Send-As*")} | Select User
