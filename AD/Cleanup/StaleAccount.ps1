##############################################
##StaleAccount.ps1
##Searches OU=User Accounts,DC=chas,DC=local for Stale accounts and moves them to Stale Users OU and disables them
##Exclused OU's > External Users, LEGAL NO DELETIONS, Departed_Users, Service Accounts, Resource Accounts, Voicemail Users, Templates
##Emails IT the results
##Tyler Hemingsen 07/24/2020
###############################################

Import-Module ActiveDirectory

$SearchBase = "OU=User Accounts,DC=chas,DC=local"
$ExclusionList = @(
    'OU=External Users'
    'OU=LEGAL NO DELETIONS'
    'OU=Service Accounts'
    'OU=Resource Accounts'
    'OU=Voicemail Users'
    'OU=Templates'
)
$Exclusions = $ExclusionList -join '|'

$staleDate = [DateTime]::Today.AddDays(-30)

$StaleUsers =  Search-ADAccount -UsersOnly -AccountInactive -TimeSpan (New-TimeSpan -Days 120) -SearchBase $SearchBase | Where-Object {$_.DistinguishedName -notmatch $Exclusions}
$UserArray = foreach ($user in $StaleUsers){Get-ADuser -Identity $user -Properties Name, LastLogonTimestamp, Description, Modified, DistinguishedName, Modified | Where-Object {$_.Modified -lt $staleDate}}

<#Comment out for testing
foreach ($user in $UserArray) {
    Set-ADUser $user -Enabled $false
    Move-ADObject $user -TargetPath "OU=Stale_Users,OU=User Accounts,DC=chas,DC=local"
}
#>

$report = "c:\temp\staleUser.htm" 
##Clears the report in case there is data in it
Clear-Content $report
##Builds the headers and formatting for the report
Add-Content $report "<html>" 
Add-Content $report "<head>" 
Add-Content $report "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>" 
Add-Content $report '<title>CHAS Stale User Cleanup Script</title>' 
add-content $report '<STYLE TYPE="text/css">' 
add-content $report  "<!--" 
add-content $report  "td {" 
add-content $report  "font-family: Tahoma;" 
add-content $report  "font-size: 11px;" 
add-content $report  "border-top: 1px solid #999999;" 
add-content $report  "border-right: 1px solid #999999;" 
add-content $report  "border-bottom: 1px solid #999999;" 
add-content $report  "border-left: 1px solid #999999;" 
add-content $report  "padding-top: 0px;" 
add-content $report  "padding-right: 0px;" 
add-content $report  "padding-bottom: 0px;" 
add-content $report  "padding-left: 0px;" 
add-content $report  "}" 
add-content $report  "body {" 
add-content $report  "margin-left: 5px;" 
add-content $report  "margin-top: 5px;" 
add-content $report  "margin-right: 0px;" 
add-content $report  "margin-bottom: 10px;" 
add-content $report  "" 
add-content $report  "table {" 
add-content $report  "border: thin solid #000000;" 
add-content $report  "}" 
add-content $report  "-->" 
add-content $report  "</style>" 
Add-Content $report "</head>" 
add-Content $report "<body>" 

##This section adds tables to the report with individual content
add-content $report  "<table width='100%'>" 
add-content $report  "<tr bgcolor='#CCCCCC'>" 
add-content $report  "<td colspan='7' height='25' align='center'>" 
add-content $report  "<font face='tahoma' color='#003399' size='4'><strong>The following users have been disabled and moved to Stale_Users (Report Only)</strong></font>" 
add-content $report  "</td>" 
add-content $report  "</tr>" 
add-content $report  "</table>" 
add-content $report  "<table width='100%'>" 
Add-Content $report  "<tr bgcolor=#CCCCCC>" 
Add-Content $report  "<td width='15%' align='center'>Account Name</td>" 
Add-Content $report  "<td width='10%' align='center'>Modified Date</td>"  
Add-Content $report  "<td width='30%' align='center'>Description</td>"  
Add-Content $report  "<td width='15%' align='center'>Last Login</td>"  
Add-Content $report  "<td width='15%' align='center'>Original OU</td>"  
Add-Content $report  "</tr>" 
if ($StaleUsers -ne $null){
	foreach ($user in $UserArray) {
		$AccountName = $user.name
		$LastChgd = $user.modified
        $UserDesc = $user.Description
        $LastLogin = [datetime]::FromFileTime($user.lastLogonTimestamp)
        $OrigOU = $user.DistinguishedName
		Add-Content $report "<tr>" 
		Add-Content $report "<td>$AccountName</td>" 
		Add-Content $report "<td>$LastChgd</td>" 
        Add-Content $report "<td>$UserDesc</td>"
        Add-Content $report "<td>$LastLogin</td>"
        Add-Content $report "<td>$OrigOU</td>"
	}
}
else {
	Add-Content $report "<tr>" 
	Add-Content $report "<td>No Accounts match</td>" 
}
Add-content $report  "</table>" 


##This section closes the report formatting
Add-Content $report "</body>" 
Add-Content $report "</html>" 

##Assembles and sends completion email with DL information##
$emailFrom = "Systems@chas.org"
$emailTo = 'themingsen@chas.org'
$subject = "CHAS Stale User Cleanup Script Complete"
$smtpServer = "tpexch03.chas.local"
$body = Get-Content $report | Out-String

Send-MailMessage -To $emailTo -From $emailFrom -Subject $subject -BodyAsHtml -Body $body -SmtpServer $smtpServer