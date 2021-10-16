## Have to find a way to iterate through each object in the key protector array to upload
##add some error handling etc.

$BLV = Get-BitLockerVolume C: ; Backup-BitLockerKeyProtector -MountPoint "C:" -KeyProtectorId $BLV.KeyProtector[0].KeyProtectorId