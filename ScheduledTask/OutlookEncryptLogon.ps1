<#Creates a schedule task that runs on logon, copying a officeUI file and placing it in local users app data.
This moves the encrypt button to the Home ribbon in Outlook
Tyler Hemingsen 6/30/2021
#>
if( -Not (Get-ScheduledTask -TaskName "Outlook EncryptUI Automation" -ErrorAction SilentlyContinue -OutVariable task) )
    {
        $Params = @{
            Action = (New-ScheduledTaskAction -Execute 'powershell' -Argument '-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File "\\chas.local\data\Deploy\Applications\Outlook Ribbon\CopyOutlookUI.ps1"')
            Trigger = (New-ScheduledTaskTrigger -AtLogOn)
            Principal = (New-ScheduledTaskPrincipal -GroupId "Users")
            TaskName = 'Outlook EncryptUI Automation'
            Description = 'Moves the Encrypt button in Outlook to the Home ribbon.'
            }
            Register-ScheduledTask @Params
            Write-Output "Task successfully registered"
            Exit 0
        }
        else {
            Write-Output "Task already exists"
            Exit 0
        }