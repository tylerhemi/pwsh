#Tyler Hemingsen  9/7/2021
#Gets the OU of the computer and assigns it to a Chrome Group based on that.
#If a new OU is added it needs to be setup in Chrome admin. 
#

$registryPath = "HKLM:\SOFTWARE\Policies\Google\Chrome"
$Name = "CloudManagementEnrollmentToken"
try{
    #Get the Distinguished Name for the computer object.
    $DN = (([adsisearcher]"(&(objectCategory=Computer)(name=$ENV:ComputerName))").findall()).properties
    #Get the appropriate registry key to set based on computer DN.
    $RegKey = switch -wildcard ($DN.distinguishedname) {
        "*OU=Cheney,OU=Locations,OU=Workstations,DC=chas,DC=local" {'b7bbac93-be0b-4de8-a493-f27299f4acc5'}
        "*OU=Clarkston,OU=Locations,OU=Workstations,DC=chas,DC=local" {'ffbe9216-d27c-41a2-9cec-66589b209526'}
        "*OU=Dalke,OU=Locations,OU=Workstations,DC=chas,DC=local" {'3f7f3f35-3565-480d-807e-c8aebd1df920'}
        "*OU=DennyMurphy,OU=Locations,OU=Workstations,DC=chas,DC=local" {'4d91d76d-6485-4fb1-a30b-2276472b047e'}
        "*OU=East Central,OU=Locations,OU=Workstations,DC=chas,DC=local" {'ac54932a-8039-4bda-9d14-de21a210434a'}
        "*OU=Iron Bridge,OU=Locations,OU=Workstations,DC=chas,DC=local" {'5b191586-4325-49d8-9c4a-f091726c6f23'}
        "*OU=Lewiston,OU=Locations,OU=Workstations,DC=chas,DC=local" {'2756bf93-d3ab-432b-88bd-6922a5d3b647'}
        "*OU=Maintenance,OU=Locations,OU=Workstations,DC=chas,DC=local" {'27afe1d7-a8f1-4375-8ef0-2b4ff39ee046'}
        "*OU=Maple,OU=Locations,OU=Workstations,DC=chas,DC=local" {'950b024f-f37c-4b96-92b4-1e8e1b246ff3'}
        "*OU=Market,OU=Locations,OU=Workstations,DC=chas,DC=local" {'72e5f937-f1d6-4df2-bbb3-ea47332980cf'}
        "*OU=Moscow,OU=Locations,OU=Workstations,DC=chas,DC=local" {'195e1c5f-c47c-4d35-a914-e74b26d3382b'}
        "*OU=North Central,OU=Locations,OU=Workstations,DC=chas,DC=local" {'25cb64df-1a08-4819-8c97-d92d33774da4'}
        "*OU=North County,OU=Locations,OU=Workstations,DC=chas,DC=local" {'370e1bbf-824d-41f6-8c2e-266e2039cae5'}
        "*OU=Perry,OU=Locations,OU=Workstations,DC=chas,DC=local" {'5b10925e-2c55-48d1-882d-3d27263651d1'}
        "*OU=Rock Pointe,OU=Locations,OU=Workstations,DC=chas,DC=local" {'f1633cdf-40ad-44b6-9e8e-75ce23b46e8c'}
        "*OU=Rogers,OU=Locations,OU=Workstations,DC=chas,DC=local" {'e0c4b64e-67e4-4141-85b9-cfb285babe29'}
        "*OU=Southgate,OU=Locations,OU=Workstations,DC=chas,DC=local" {'51d4d48f-235a-4a04-8e21-7f3cffd0eacd'}
        "*OU=Street Medicine,OU=Locations,OU=Workstations,DC=chas,DC=local" {'211cdd96-05cf-4bc6-879e-b1894a7dfa0c'}
        "*OU=Telework,OU=Locations,OU=Workstations,DC=chas,DC=local" {'a56327bf-5c6f-4c7d-bfa1-2cbe22665702'}
        "*OU=UC_North,OU=Locations,OU=Workstations,DC=chas,DC=local" {'0a5c0629-ee8a-4e99-b4f8-256d9877064d'}
        "*OU=UC_Valley,OU=Locations,OU=Workstations,DC=chas,DC=local" {'96ce8732-33f9-443b-b9c0-3477d31fa3d6'}
        "*OU=Unknown,OU=Locations,OU=Workstations,DC=chas,DC=local" {'8f924fe0-6db2-4971-b986-c47903c0651c'}
        "*OU=Valley,OU=Locations,OU=Workstations,DC=chas,DC=local" {'ccfabd75-bdc0-494f-aadd-a882d830728f'}
        "*OU=Workstations-IT,DC=chas,DC=local" {'bd6ce34f-1a9f-43b6-9956-fca1f53ba5f4'}
        default {'No Match'}
    }
}catch{
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
        Write-Output $ErrorMessage
        Write-Output $FailedItem
        Exit 1
    }
#Check that $RegKey value is set correctly.
switch ($RegKey) {
    $null {"Value is blank"; Exit 1}
    'No Match'{'Unable to find OU'; Exit 1}
    Default {Continue}
}


#Write the key to registry and check if set correctly. Some basic error handling.
try{        
    if ((Get-ItemPropertyValue -Path $registryPath -Name $Name)-ne "$RegKey") {
        Remove-Item -Path HKLM:\SOFTWARE\Google\Chrome\Enrollment -Force -ErrorAction SilentlyContinue
        Remove-Item -Path HKLM:\Software\WOW6432Node\Google\Enrollment -Force -ErrorAction SilentlyContinue
        Start-Sleep 2
        New-ItemProperty -Path $registryPath -Name $name -Value $RegKey -Force | Out-Null
        if ((Get-ItemPropertyValue -Path $registryPath -Name $Name)-eq "$RegKey") {
            Write-Output "Registry value was set properly."
            Exit 0 
            }
            else{
                Write-Output "Unable to set proper value."
                Exit 1

            }
    }
    else{
        Write-Output "Key already set."
        Exit 0
    }
}catch{
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    Write-Output $ErrorMessage
    Write-Output $FailedItem
    Exit 1
}