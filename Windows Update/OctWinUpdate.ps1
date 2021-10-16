$creds = Import-Clixml C:\temp\creds.xml
$Servers = "tp-fs-01","mo-dc-01"


foreach ($server in $servers) {
    Invoke-Command -ComputerName $server -Credential $creds -ScriptBlock {
        #Check for NuGet
        Try {
            Import-Module NuGet -ErrorAction Stop
        } catch [System.IO.FileNotFoundException] {
            Install-PackageProvider -Name NuGet -Force | Out-Null
            Install-Module Nuget -Force | Out-Null
            $Error.Clear()
        }    
                            
        #Check for PSWindowsUpdate Module
        Try {
            Import-Module PSWindowsUpdate -ErrorAction Stop
        } catch [System.IO.FileNotFoundException] {
            Install-Module PSWindowsUpdate -Force | Out-Null
            $Error.Clear()
        }
        #Check if its installed and pending reboot / else check if already installed/ else start installing.
        if (Get-WindowsUpdate -IsInstalled -KBArticleID 'KB5006672') {
            Write-Output "Update is already installed on $ENV:COMPUTERNAME"
        } else {
            #Information to schedule the shutdown
            [datetime]$RestartTime = '11PM'
            [datetime]$CurrentTime = Get-Date
            [int]$WaitSeconds = ( $RestartTime - $CurrentTime ).TotalSeconds
            $Reason = "Oct 21 updates"
            #Register the job to install updates and schedule a reboot.
            Register-ScheduledJob -Name "Oct '21 Security Updates" -RunNow -ScriptBlock {Install-WindowsUpdate -AcceptAll -Install -Confirm:$false -IgnoreReboot -AutoReboot:$false}
            Write-Output "Starting install on $ENV:COMPUTERNAME"
            shutdown -r -t $WaitSeconds -f /c $Reason
            ##Trigger settings for scheduled job that removes both scheduled jobs.
            $Reboot = (Get-Date).AddDays(1)
            $Trig = @{
                Frequency = 'Once'
                At = $Reboot
            }       
            Register-ScheduledJob -Name 'Remove Oct Sched Job' -Trigger $Trig -ScriptBlock {Unregister-ScheduledJob -Name "Oct '21 Security Updates"; Unregister-ScheduledJob 'Remove Oct Sched Job'}
            Break
        } 
    }   
}

