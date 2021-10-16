#Arrays
$BHProvider = @()
$PatientExperienceSpecialist = @()
$PatientExperienceSupervisor = @()
#Not needed, already set correctly in AD. $DirPatientResources = @()
#Not needed, already set correctly in AD. $PatientResourcesAdministrator = @()
$PatientResourceCoordinator = @()
$PatientEngagementSpecialist = @()

$searchBase = "OU=User Accounts,DC=chas,DC=local"


#Get members based on old title and change to new.

$BHProvider = Get-ADuser -Filter 'Title -like "Behavioral Health Provider*"' -SearchBase $searchBase
    foreach ($user in $BHProvider){
        Set-Aduser $user -Title "BH Provider"
    }

$PatientExperienceSpecialist = Get-ADuser -Filter 'Title -like "Call Center Representative" -or Title -like "Centralized Services Specialist"' -SearchBase $searchBase
    foreach ($user in $PatientExperienceSpecialist){
        Set-Aduser $user -Title "Patient Experience Specialist"
    }

$PatientExperienceSupervisor = Get-ADuser -Filter 'Title -like "Health Records Supervisor" -or Title -like "Referral Specialist Superv*" -or Title -like "Call Center Supervisor"' -SearchBase $searchBase
    foreach ($user in $PatientExperienceSupervisor){
        Set-Aduser $user -Title "Patient Experience Supervisor"
    }

$PatientResourceCoordinator = Get-ADuser -Filter 'Title -like "Patient Services Coordinator"' -SearchBase $searchBase
    foreach ($user in $PatientResourceCoordinator){
        Set-Aduser $user -Title "Patient Resources Coordinator"
    }

$PatientEngagementSpecialist  = Get-ADuser -Filter 'Title -like "Patient Services Specialist"' -SearchBase $searchBase
    foreach ($user in $PatientEngagementSpecialist){
        Set-Aduser $user -Title "Patient Engagement Specialist"
    }

