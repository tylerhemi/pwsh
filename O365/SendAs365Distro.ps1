$sendas = "username"
foreach($user in $sendas){Add-RecipientPermission -Identity HealthRecordsAll -Trustee $user -AccessRights SendAs -Confirm:$False}