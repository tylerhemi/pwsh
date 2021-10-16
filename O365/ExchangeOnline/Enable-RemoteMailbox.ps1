##
#Tyler Hemingsen 9/13/2021
#This script enables the remote mailbox attribute which is necessary for Autodiscover when on Chas network among other things.
#https://docs.microsoft.com/en-us/powershell/module/exchange/enable-remotemailbox?view=exchange-ps
#

#Get credentials. Needs to be in chas\username form.
$creds = Get-Credential



#Connects to exchange tp-exch-05.
Function Connect-Exchange{
    Set-ExecutionPolicy RemoteSigned
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://tp-exch-05.chas.local/PowerShell/ -Authentication Kerberos -Credential ($creds)
    Import-PSSession $Session -DisableNameChecking
    }



#Create array
$ADuser = @()
$users = 
#clear attribute that causes error
foreach ($user in $users){set-aduser $user -Clear msExchHomeServerName -Credential $creds}
foreach($user in $users){$ADuser += Get-ADUSER $User }

###connect to exchange here first
Connect-Exchange
foreach($user in $ADuser){Enable-RemoteMailbox $($User.Name) -RemoteRoutingAddress "$($User.SamAccountName)@chashealth.mail.onmicrosoft.com" }

#Check that remote mailbox was enabled properly. Once this comes back with all users you are good.
foreach($user in $ADuser){Get-RemoteMailbox $user.SamAccountNAme | Select-Object Name,WhenCreated}