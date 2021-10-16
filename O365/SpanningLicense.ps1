Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
Get-ChildItem -Path "C:\program files\powershell\7\Modules\SpanningO365\" -Recurse | Unblock-file
Import-Module SpanningO365 -Force

$Auth = Get-SpanningAuthentication -ApiToken  -Region US -AdminEmail hemiadmin@chashealth.onmicrosoft.com
Enable-SpanningUsersFromCSVAdvanced -PAth C:\temp\EmailArray.csv -UpnColumn 0 