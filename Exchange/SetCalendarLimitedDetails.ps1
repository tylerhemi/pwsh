#Connect 
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn;
. $env:ExchangeInstallPath\bin\RemoteExchange.ps1
Connect-ExchangeServer -auto
#Run the command
$name = Read-Host -Prompt "Please enter username ONLY"
Write-Host "Adding Exchange Snapin, please be patient."
Set-mailboxfolderpermission –identity $name'@chas.org':\Calendar –user Default –accessrights limiteddetails
    $test = Get-MailboxFolderPermission -identity $name'@chas.org':\Calendar -User Default | Select-Object -ExpandProperty AccessRights
        if ($test -eq "LimitedDetails") 
            {Write-Host -ForegroundColor Green "Access Rights have been set"} 
                else {Write-Host -ForegroundColor Red "Access Rights are not correct"}
Read-Host "Press Enter to continue."

