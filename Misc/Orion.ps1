Invoke-Webrequest -URI https://chasmon/Orion/SummaryView.aspx?ViewID=1 -UseDefaultCredentials
$command = Get-History -Count 1
$time = $command.EndExecutionTime - $command.StartExecutionTime
Send-MailMessage -From "solarwindssvc@chas.org" -To "themingsen@chas.org" -Subject "Solarwinds Startup Time" -Body "It took Solarwinds $Time to startup." -SmtpServer 'tpexch03.chas.local'