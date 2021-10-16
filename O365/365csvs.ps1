$FilePath = 'C:\temp\Nov17.txt' #Filepath here
$MigrationUsers = Get-Content $FilePath
$EmailArray = @('EmailAddress')
$LicensingArray = @('version:v1.0','Member object ID or user principal name [memberObjectIdOrUpn] Required')

foreach ($user in $MigrationUsers)
    {
        if ($Null -ne(Get-ADUser -Filter 'Name -like $user')) 
                {$email = Get-ADUser -Filter 'Name -like $user' |  Where-Object {$_.DistinguishedName -notlike "*OU=Departed_Users*" } | Select-Object UserPrincipalName -ExpandProperty UserPrincipalName 
                $EmailArray += $email
                $LicensingArray += $email}
        else{Write-Host "$User Email not found!!!"}
    }

    $EmailArray | Out-File C:\temp\EmailArray.csv
    $LicensingArray | Out-File C:\temp\LicensingArray.csv