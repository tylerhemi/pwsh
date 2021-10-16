#Instantiate arrays
$LicensedUserArray = @()
$UniqueLicensedUserArray = @()
$UserMailboxes = @()
$Mailboxes = @()



#Connect to Azure if not already connected
if($null -eq $azureConnection.Account){
    $azureConnection = Connect-AzureAD -AccountId hemiadmin@chashealth.onmicrosoft.com
}

#Get all groups containing LGRP is Azure
$LGRP = Get-AzureADGroup -SearchString LGRP

#Get all UPNs of members of the LGRP(s)
foreach ($grp in $LGRP){
    $LicensedUserArray += Get-AzureADGroupMember -ObjectId $grp.ObjectId -All $True | Select-Object UserPrincipalName -ExpandProperty UserPrincipalName
}



#Select Unique users
$UniqueLicensedUserArray = $LicensedUserArray | Select-Object -Unique

#Connect ExchangeOnline
Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline -UserPrincipalName hemiadmin@chashealth.onmicrosoft.com

#Get mailboxes from ExchangeOnline
$UserMailboxes =  Get-Mailbox -Filter 'RecipientTypeDetails -eq "UserMailbox"' -ResultSize Unlimited | Select-Object UserPrincipalName -ExpandProperty UserPrincipalName

#Select those that aren't in Departed Users OU and add all onmicrosoft ones by default
foreach ($user in $UserMailboxes){
    if( $user -like "*chashealth.onmicrosoft.com")
    {       
        $Mailboxes += $user
    }
    else{
        $Mailboxes += Get-ADUser -Filter 'UserPrincipalName -eq $user' | Where-Object {$_.DistinguishedName -notlike "*OU=Departed_Users*"} | Select-Object UserPrincipalName -ExpandProperty UserPrincipalName
    }
}

#Compare the two arrays
Compare-Object $Mailboxes $UniqueLicensedUserArray
