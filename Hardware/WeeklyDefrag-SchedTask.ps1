$credential = Get-Credential
Invoke-Command -ComputerName mpdc01,mpfps01 -Credential $credential -ScriptBlock {
Register-ScheduledTask -Xml (get-content '\\chas.local\data\Deploy\Applications\Scripts\TaskScheduler\WeeklyScheduledDefrag.xml' | out-string) -TaskName "WeeklyScheduledDefrag" -User 'NT AUTHORITY\SYSTEM' –Force
}