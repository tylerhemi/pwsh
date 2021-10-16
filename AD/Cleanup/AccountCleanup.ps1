###################################################################################################################
##AccountCleanup.ps1
##This script is designed to poll AD for any disabled user accounts that are over 30 days old and deletes them.
##The results are put into a file and then emailed to IT staff.
##Tyler Hemingsen 03/10/2021
###################################################################################################################

#load AD module
import-module activedirectory

$oldDate = [DateTime]::Today.AddDays(-30)
$warnDate = [DateTime]::Today.AddDays(-23)
$SearchBase = "OU=Departed_Users,DC=chas,DC=local"
$delUsers = @()
$warnUsers = @()
$30daysUsers = @()


##Retrieves disabled user accounts and stores in an array
$disabledUsers = Get-ADUser -filter {(Enabled -eq $False)} -Searchbase $SearchBase -Searchscope 1 -Properties Name,SID,Enabled,LastLogonDate,Modified,info,description,ipPhone,telephoneNumber

foreach ($name in $disabledUsers) {
	if ($name.modified -le $oldDate) {
		Remove-ADObject -Identity $name.DistinguishedName -confirm:$false -Recursive

		Remove-Item "\\tp-fs-01\home\$($name.samaccountname)" -Force -Recurse
		$delUsers = $delUsers + $name
		}
	elseif ($name.modified -le $warnDate) {
		#Write-Host $name.name " is will be deleted in the next run"
		$warnUsers = $warnUsers + $name
		}
	else {
		#Write-Host $name.name " was modified less than 30 days ago"
		$30daysUsers = $30daysUsers + $name
		}
}

$report = "c:\temp\report.htm" 
##Clears the report in case there is data in it
Clear-Content $report
##Builds the headers and formatting for the report
Add-Content $report "<html>" 
Add-Content $report "<head>" 
Add-Content $report "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>" 
Add-Content $report '<title>CHAS Disabled User Cleanup Script</title>' 
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
##Table 1 for deleted users
add-content $report  "<table width='100%'>" 
add-content $report  "<tr bgcolor='#CCCCCC'>" 
add-content $report  "<td colspan='7' height='25' align='center'>" 
add-content $report  "<font face='tahoma' color='#003399' size='4'><strong>The following users have been deleted (Report Only)</strong></font>" 
add-content $report  "</td>" 
add-content $report  "</tr>" 
add-content $report  "</table>" 
add-content $report  "<table width='100%'>" 
Add-Content $report "<tr bgcolor=#CCCCCC>" 
Add-Content $report  "<td width='20%' align='center'>Account Name</td>" 
Add-Content $report "<td width='10%' align='center'>Modified Date</td>"  
Add-Content $report "<td width='30%' align='center'>Description</td>"  
Add-Content $report "<td width='10%' align='center'>IP Phone</td>"
Add-Content $report "<td width='10%' align='center'>Telephone Number</td>"
Add-Content $report "</tr>" 
if ($null -ne $delUsers){
	foreach ($name in $delUsers) {
		$AccountName = $name.name
		$LastChgd = $name.modified
		$UserDesc = $name.Description
		$ipPhone = $name.ipPhone
		$telephoneNumber = $name.telephoneNumber
		Add-Content $report "<tr>" 
		Add-Content $report "<td>$AccountName</td>" 
		Add-Content $report "<td>$LastChgd</td>" 
		add-Content $report "<td>$UserDesc</td>"
		Add-Content $report "<td>$ipPhone</td>"
		Add-Content $report "<td>$telephoneNumber</td>"
	}
}
else {
	Add-Content $report "<tr>" 
	Add-Content $report "<td>No Accounts match</td>" 
}
Add-content $report  "</table>" 

##Table 2 for warning users
add-content $report  "<table width='100%'>" 
add-content $report  "<tr bgcolor='#CCCCCC'>" 
add-content $report  "<td colspan='7' height='25' align='center'>" 
add-content $report  "<font face='tahoma' color='#003399' size='4'><strong>The following users will be deleted next week</strong></font>" 
add-content $report  "</td>" 
add-content $report  "</tr>" 
add-content $report  "</table>" 
add-content $report  "<table width='100%'>" 
Add-Content $report "<tr bgcolor=#CCCCCC>" 
Add-Content $report  "<td width='20%' align='left'>Account Name</td>" 
Add-Content $report "<td width='10%' align='center'>Modified Date</td>"  
Add-Content $report "<td width='30%' align='center'>Description</td>"  
Add-Content $report "<td width='10%' align='center'>IP Phone</td>"
Add-Content $report "<td width='10%' align='center'>Telephone Number</td>"
Add-Content $report "</tr>"
if ($null -ne $warnUsers){
	foreach ($name in $warnUsers) {
		$AccountName = $name.name
		$LastChgd = $name.modified
		$UserDesc = $name.Description
		$ipPhone = $name.ipPhone
		$telephoneNumber = $name.telephoneNumber
		Add-Content $report "<tr>" 
		Add-Content $report "<td>$AccountName</td>" 
		Add-Content $report "<td>$LastChgd</td>" 
		add-Content $report "<td>$UserDesc</td>"
		Add-Content $report "<td>$ipPhone</td>"
		Add-Content $report "<td>$telephoneNumber</td>"
	}
}
else {
	Add-Content $report "<tr>" 
	Add-Content $report "<td>No Accounts match</td>" 
}
Add-content $report  "</table>" 


##Table 3 for recently modified users
add-content $report  "<table width='100%'>" 
add-content $report  "<tr bgcolor='#CCCCCC'>" 
add-content $report  "<td colspan='7' height='25' align='center'>" 
add-content $report  "<font face='tahoma' color='#003399' size='4'><strong>The following users were modified in the last 30 days</strong></font>" 
add-content $report  "</td>" 
add-content $report  "</tr>" 
add-content $report  "</table>" 
add-content $report  "<table width='100%'>" 
Add-Content $report "<tr bgcolor=#CCCCCC>" 
Add-Content $report "<td width='20%' align='left'>Account Name</td>" 
Add-Content $report "<td width='10%' align='center'>Modified Date</td>"  
Add-Content $report "<td width='30%' align='center'>Description</td>"  
Add-Content $report "<td width='10%' align='center'>IP Phone</td>"
Add-Content $report "<td width='10%' align='center'>Telephone Number</td>"
Add-Content $report "</tr>" 
if ($null -ne $30daysUsers){
	foreach ($name in $30daysUsers) {
		$AccountName = $name.name
		$LastChgd = $name.modified
		$UserDesc = $name.Description
		$ipPhone = $name.ipPhone
		$telephoneNumber = $name.telephoneNumber
		Add-Content $report "<tr>" 
		Add-Content $report "<td>$AccountName</td>" 
		Add-Content $report "<td>$LastChgd</td>" 
		add-Content $report "<td>$UserDesc</td>"
		Add-Content $report "<td>$ipPhone</td>"
		Add-Content $report "<td>$telephoneNumber</td>"
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
$emailTo = 'sd@chas.org'
$subject = "CHAS User Cleanup Script Complete"
$smtpServer = "chas-org.mail.protection.outlook.com"
$body = Get-Content $report | Out-String

Send-MailMessage -To $emailTo -From $emailFrom -Subject $subject -BodyAsHtml -Body $body -SmtpServer $smtpServer
