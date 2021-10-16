#Define variables for mail server
$emailFrom = "Systems@chas.org"
$emailTo = 'systems@chas.org'
$subject = "Tableau Backup Copy Error"
$smtpServer = "chas-org.mail.protection.outlook.com"
$body = Write-Output "Tableau backup file failed to copy to TP-FS-02."


$File = Get-ChildItem -Path "C:\ProgramData\Tableau\Tableau Server\data\tabsvc\files\backups\" -Filter ts_backup* | Select-Object -First 1
#copy the file
$CopyStatus = Copy-Item -Path "C:\ProgramData\Tableau\Tableau Server\data\tabsvc\files\backups\$File" -Destination "\\tp-fs-02\BACKUPS\Tableau\backups\$File" -Force -PassThru
#If last executed command completed succesfully (TRUE) then delete the file | Else email team error.
if ($CopyStatus.Name.ToString() -like "*tsbak") {
Remove-Item -Path "C:\ProgramData\Tableau\Tableau Server\data\tabsvc\files\backups\$File"
    }
Else {
    Send-MailMessage -To $emailTo -From $emailFrom -Subject $subject -BodyAsHtml -Body $body -SmtpServer $smtpServer
}
Copy-Item -Path 'C:\ProgramData\Tableau\Tableau Server\data\tabsvc\files\backups\configsettings.json' -Destination '\\tp-fs-02\BACKUPS\Tableau\backups\configsettings.json' -Force