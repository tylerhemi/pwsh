$FSArgs = {$_.OperatingSystem -like "*Server*" -and ($_.Name -like "*fps*" -or $_.Name -like "*fs*")}
$SearchBase = "OU=Branch Office Servers,OU=Virtual Servers,OU=Member Servers,DC=chas,DC=local"
$FileServers = Get-ADComputer -Filter * -Properties * -SearchBase $SearchBase | Where-Object $FSArgs | Select-Object Name -ExpandProperty Name
$FileServers = $FileServers | Where-Object {($_ -ne "LB-FS-02" -and $_ -ne "IB-FPS-01")}

foreach ($server in $FileServers){
#Add member to IT replication group
Add-DfsrMember -GroupName "IT" -Computername $server 
#Sets the replication folder target,quota,don't confirm
Set-DfsrMembership -ComputerName $server -GroupName "IT" -FolderName "repo" -ContentPath "D:\repo" -StagingPathQuotaInMB 16384 -Confirm:$false
#Sets up the actual replication between servers
Add-DfsrConnection -GroupName "IT" -SourceComputerName "TP-Deploy" -DestinationComputerName $server 

###Namespace part
##Creates the folder target
New-DfsnFolderTarget -Path "\\chas.local\IT\repo" -TargetPath "\\$server.chas.local\repo"
##Add namespace server
New-DfsnRootTarget -Path "\\chas.local\IT" -TargetPath "\\$server.chas.local\IT"
}

#Add-DfsrConnection -GroupName "IT" -SourceComputerName $server -DestinationComputerName "Tp-Deploy"