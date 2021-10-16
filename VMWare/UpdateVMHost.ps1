#setup Vars
param([string]$server = "server")
#sets server variable to lower case
$server = $server.ToLower()
#create FullServer var with appeneded domain name
$FullServer = $server+".mydomain.local"
#Place Host in Maintenance Mode
set-vmhost -VMHost $FullServer -State Maintenance
#Update Manger - Patch Host with latest updates
Write-Output "VUM - Getting Baseline"
$baseline = Get-Baseline -TargetType Host
Write-Output "VUM - Attaching Baseline"
Attach-Baseline -Entity $FullServer -baseline $baseline
Write-Output "VUM - Scanning Server"
Scan-Inventory -entity $FullServer -UpdateType HostPatch
Write-Output "VUM - Staging Patches to Server"
Stage-Patch -Entity $FullServer
Write-Output "VUM - Remediating Server"
Remediate-Inventory -Entity $FullServer -Baseline $baseline -confirm:$false
Write-Output "VUM - Update Completed"
Exit Maintenance Mode
set-vmhost -VMHost $FullServer -State Connected