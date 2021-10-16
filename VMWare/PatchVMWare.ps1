
$esxiHost = Read-Host "Enter hostname with .chas.local"
Import-Module VMware.PowerCLI
if (!( $Global:DefaultViServer.IsConnected)){
    Write-Host "Connecting to TPVCSA01."
    Connect-ViServer -Server tpvcsa01.chas.local -Credential (Import-CLIXML C:\temp\creds.xml)
}
## Get VMS on the host 
Write-Host "Shutting down Virtual Machines."
$VMList = Get-VMHost -name $esxiHost | Get-VM | Where-Object { $_.PowerState -eq "PoweredOn" }
Foreach ( $VM in $VMList ) { 
          # Retrieve the status of the VMware Tools 
         $ToolsStatus = ($VM | Get-View).Guest.ToolsStatus 
         # Check status of tools and if not installed then issue Stop to VM otherwise Shutdown VM 
         If ( $ToolsStatus -eq "toolsNotInstalled" ) { 
              Stop-VM $VM -confirm:$false
         } Else {
              Shutdown-VMGuest $VM -confirm:$false
         } 
   }
### Wait for all VMS to be shutdown/powered off
do{
    Write-Host "Sleeping 30 seconds."
    Start-Sleep 30 
    }
until ($null -eq (Get-VMHost -name $esxiHost | Get-VM | Where-Object { $_.PowerState -eq "PoweredOn"}))


Write-Host "Putting host into maintenance mode."
Set-VMHost -VMHost $esxiHost -State Maintenance
#Update Manger - Patch Host with latest updates
Write-Output "VUM - Getting Baseline"
$baseline = Get-Baseline -TargetType Host
Write-Output "VUM - Attaching Baseline"
Attach-Baseline -Entity $esxiHost -baseline $baseline
Write-Output "VUM - Scanning Server"
Scan-Inventory -entity $esxiHost -UpdateType HostPatch
Write-Output "VUM - Staging Patches to Server"
Stage-Patch -Entity $esxiHost
Write-Output "VUM - Remediating Server"
Remediate-Inventory -Entity $esxiHost -Baseline $baseline -confirm:$false 
Write-Output "VUM - Update Completed"
#Exit Maintenance Mode
Write-Host "Exiting maintenance mode."
Set-VMHost -VMHost $esxiHost -State Connected
#Power on VMs
Write-Host "Starting VMs."
Get-VMHost $esxiHost | GEt-VM | Start-VM
Write-Output "Finished patching."
