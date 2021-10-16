$cred = Get-Credential
$users = Import-CSV 'C:\tmp\Location.csv'

foreach ($user in $users){
    Get-ADUser -Filter "EmailAddress -like '$($user.EmailAddress)'" | Set-ADUser -Office $user.Clinic -Credential $cred
    #$Error | Add-Content C:\temp\error.txt
    
}