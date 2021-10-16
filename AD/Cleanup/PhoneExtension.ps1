#Script to query Chas AD for User info and phone ext info
#Tyler Hemingsen 8/19/2021
#If AD OU changes this will likely stop working correctly.
#
#Add assemblies
Try{
    Import-Module ActiveDirectory
}
Catch{
    $Err
    Write-Output $Err
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName PresentationCore,PresentationFramework


#Create forms object and filter on CSV
$FileBrowser = New-Object System.Windows.Forms.SaveFileDialog -Property @{
 InitialDirectory = [Environment]::GetFolderPath('Desktop')
 Filter = 'CSV (Comma delimited) (*.csv)|*.csv'
}

#Check if a path was specified.
if($FileBrowser.ShowDialog() -eq 'OK'){
    #Search base in AD as well as exclusion list
    $SearchBase = "OU=User Accounts,DC=chas,DC=local"
    $ExclusionList = @(
        'OU=External Users'
        'OU=LEGAL NO DELETIONS'
        'OU=Service Accounts'
        'OU=Resource Accounts'
        'OU=Voicemail Users'
        'OU=Templates'
        'OU=TestUsers'
    )
    #Join the esclusions to a usable format
    $Exclusions = $ExclusionList -join '|'
    #Get the user and filter through
    Get-Aduser -Filter * -Searchbase $SearchBase -Properties givenName,middleName,displayName,surName,samAccountName,ipPhone,telephoneNumber,distinguishedName `
    | Where-Object {$_.DistinguishedName -notmatch $Exclusions} `
    | ForEach-Object{
        #Create custom object to match Cisco Call Manager output
        New-Object psobject -Property @{
            "First Name" = $_.givenName
            "Middle Name" = $_.givenName
            "Display Name" = $_.displayName
            "Last Name" = $_.surName
            "User ID" = $_.samAccountName
            "Telephone Number" = $_.telephoneNumber
        }
    } `
    | Select-Object "First Name","Middle Name","Display Name","Last Name","User ID","Telephone Number",ipPhone `
    | Export-Csv -Path $FileBrowser.FileName 
}
else {
    [System.Windows.MessageBox]::Show('You did not specify a save path.')
}