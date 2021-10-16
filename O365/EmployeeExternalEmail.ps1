#Get newest version of the file
$Dir = "\\tp-fs-02\sftp\Ultipro\"
#Create arrays
$UpTemp = @()
$UpEmails = @()
$AddContact = @()
$RemoveContact = @()

##Assembles and sends completion email with DL information##
$emailFrom = "Systems@chas.org"
$emailTo = 'systems@chas.org'
$subject = "External Email Script"
$smtpServer = "chas-org.mail.protection.outlook.com"

try {$UPExport = Get-ChildItem $Dir -ErrorAction Stop| Sort-Object -Property LastWriteTime -Descending  | Select-Object -First 1}
Catch{
    Exit
}

##Import the exchange snapins
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn;
.$env:ExchangeInstallPath\bin\RemoteExchange.ps1 -AllowClobber
Connect-ExchangeServer -auto

#Get distribution group members
$DistributionArray = Get-DistributionGroupMember -Identity 'ExternalEmployeeEmail' -ResultSize Unlimited

#If Distribution array is empty send email and exit script
if (!$DistributionArray){
    Send-MailMessage -To $emailTo -From $emailFrom -Subject $subject -BodyAsHtml -Body "Distribution array is emtpy, exiting script" -SmtpServer $smtpServer
    throw "Distribution array is emtpy, exiting script"
}

#import the CSV
$UPCsv = Import-CSV $UPExport.PSPath -Header "EmployeeID","ChasEmail","AltEmail","EmploymentStatus","FirstName","LastName","Alias","Name"

#check if CSV is empty
if (!$UPCsv){
    Send-MailMessage -To $emailTo -From $emailFrom -Subject $subject -BodyAsHtml -Body "CSV from Ultipro is emtpy, exiting script" -SmtpServer $smtpServer
    throw "CSV from Ultipro is emtpy, exiting script" 
}

#Join Firstname and lastname in a sloppy fashion to create Alias and Name fields. 
foreach ($user in $UPCsv){
    $user.Alias = "$($user.FirstName)$($user.LastName)"
    $user.Name = "$($user.FirstName)$($user.LastName)"
    $UpTemp += $User
}

#Filter through emails for blank email and chas.org emails.
foreach ($user in $UPTemp){
    if ('' -ne $User.AltEmail -and $null -ne $user.AltEmail -and $User.AltEmail -notlike "*chas.org" -and $User.AltEmail -ne "Alternate E-mail Address"){
        $UpEmails += $User
    }
}


#Compare new list vs current distribution group. Add users to be created in $AddContact and add users to be removed in $RemoveContact
$Comparison = Compare-Object $UpEmails $DistributionArray -Property Name -PassThru
foreach($externalcontact in $Comparison){
    if($externalcontact.SideIndicator -eq '=>'){
        $RemoveContact += $externalcontact
        }
    if($externalcontact.SideIndicator -eq '<='){
        $AddContact += $externalcontact
        }
    }


#loop through and create mail contacts, set them as hidden, and add to distribution group. Only runs if not blank.
if($AddContact){
    foreach ($contact in $AddContact){
        New-MailContact -Name $contact.Alias -ExternalEmailAddress $contact.AltEmail -OrganizationalUnit "OU=Employee External Email,OU=Contacts,DC=chas,DC=local"
        #Set hidden
        Set-MailContact -Identity $Contact.Alias -HiddenFromAddressListsEnabled $True 
        ###Might be a disconnect here in that I need to add a wait as the contact isn't found in AD when trying to add? Need to verify
        Add-DistributionGroupMember -Identity 'ExternalEmployeeEmail' -Member "$($Contact.AltEmail)"
    }
}

#Remove contacts, only runs if not blank.
if($RemoveContact){
foreach ($contact in $RemoveContact){
    Remove-DistributionGroupMember -Identity 'ExternalEmployeeEmail' -Member $contact.Alias -Confirm:$false
    Remove-MailContact -Identity $Contact.Alias -Confirm:$False 
   }
}
