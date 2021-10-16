#Connect ExchangeOnline
Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline -UserPrincipalName hemiadmin@chashealth.onmicrosoft.com

#Instantiate / clear arrays.
$SpanningUsers = @()
$UserMailboxes = @()
$MailNotLicensed = @()
$NotDeparted = @()

#Set ExceutionPolicy, Unblock file, import module, set auth.
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
#Import module and get Auth
Import-Module SpanningO365 -Force
$Auth = Get-SpanningAuthentication -ApiToken  -Region US -AdminEmail hemiadmin@chashealth.onmicrosoft.com
#Get licensed spanning users
$SpanningUsers = Get-SpanningAssignedUsers | Select-Object UserPrincipalName -ExpandProperty UserPrincipalName



###Instantiate the exclusion array for mailboxes we don't want included. Then join the array with a pipe delimter for regex -notmach.
$MailboxExclusions = @(
    'chashealth.onmicrosoft.com'
    'Chas Nook@chas.org'
    'DoNotReply@chas.org'
    'Athena@chas.org'
    'ItNoReply@chas.org'
)

$MailboxExclusionsJoin = $MailboxExclusions -join '|'

#Get Exchangeonline mailboxes minus exclusions.
$UserMailboxes = Get-Mailbox -Filter * -ResultSize Unlimited | Where-Object {$_.UserPrincipalName -notmatch "$MailboxExclusionsJoin"} | Select-Object UserPrincipalName -ExpandProperty UserPrincipalName

#Get spanning licensed users that don't have a mailbox. (remove license)
Write-Host "The following users are licensed in spanning, but don't have a mailbox:" -ForegroundColor Red
Compare-Object $SpanningUsers $UserMailboxes | Where-Object {$_.SideIndicator -eq '<='} | Select-Object InputObject -ExpandProperty InputObject

Write-Host 'The following users have a mailbox, but are not licensed in spanning:' -ForegroundColor Red
$MailNotLicensed = Compare-Object $SpanningUsers $UserMailboxes | Where-Object {$_.SideIndicator -eq '=>'} | Select-Object InputObject -ExpandProperty InputObject
$NotDeparted = foreach ($user in $MailNotLicensed) {Get-ADUser -Filter {UserPrincipalName -eq $user} | Where-Object {$_.DistinguishedName -notlike '*Departed*'}}
$NotDeparted.UserPrincipalName
#Gets departed users that are licensed in spanning. (remove license)
$departed = foreach ($user in $SpanningUsers) {Get-ADUser -Filter {UserPrincipalName -eq $user} | Where-Object {$_.DistinguishedName -like '*Departed*'}}
Write-Host 'The following users are Departed and are licensed in spanning:' -ForegroundColor Red
$departed.UserPrincipalName


#This section below is used to manage licensing for Spanning users.


#Removes Spanning Licensing for users in Departed user OU.
#$Auth = Get-SpanningAuthentication -ApiToken  -Region US -AdminEmail hemiadmin@chashealth.onmicrosoft.com
foreach ($user in $departed) {
    Disable-SpanningUserList -UserPrincipalName $user.UserPrincipalName -AuthInfo $Auth
}

#Assigns spanning license to those missing it, but have a mailbox.
foreach ($user in $NotDeparted) {
    Enable-SpanningUserList -UserPrincipalNames $user.UserPrincipalName -AuthInfo $Auth
}

#This section below is used to add licensing for Spanning users from a text file.
#foreach ($_ in (Get-Content C:\persist\EnableSpanning.txt)){Enable-SpanningUserList -UserPrincipalName $_}

#Path for WINRM basic auth required - \HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WinRM\Client\AllowBasic -Value 1
#Set-ItemProperty -Path HKLM:\HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WinRM\Client\ -Name AllowBasic -Value 1
#maybe integrate if needed