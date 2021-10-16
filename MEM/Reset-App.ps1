###
# https://powers-hell.com/2018/04/16/how-to-force-intune-configuration-scripts-to-re-run/
###

##Function definition

function Select-MemApp {
    do {
        $appString = Read-host "Input name of app you are looking for"
        $Global:desiredApp = $memApps | Where-Object {$_.DisplayName -like "*$appString*"}
    } until ($null -ne $desiredApp)  
}


if (!(Get-Module -Name NSAL.PS -ListAvailable -ErrorAction SilentlyContinue)){
    Install-Module -Name MSAL.PS -Scope CurrentUser -Force -AcceptLicense
}


if($null = $clientId){
    $clientId = "d1ddf0e4-d672-4dae-b554-9d5bdfd93547" # Itune Application ID
}

if($null = $auth){
    $auth = Get-MsalToken -ClientId $clientId -DeviceCode #for MFA
}
if($null = $Token){    
    $Token = @{Authorization = $auth.CreateAuthorizationHeader()} #Authorization token for header
}

#Get device properties of the current pc
#$deviceProps = (Invoke-RestMethod -Method Get -Uri "https://graph.microsoft.com/v1.0/devices?`$filter=DisplayName eq '$env:ComputerName'" -Headers $token).Value 

#Get the registered owner of the device
#$owner = (Invoke-RestMethod -Method Get -Uri "https://graph.microsoft.com/v1.0/devices/$($deviceProps.id)/registeredOwners" -Headers $token).value

#Get MEM apps
$memApps = (Invoke-RestMethod -Method Get -Uri "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps" -Headers $token).value


Select-MemApp
$Host.UI.PromptForChoice(
  "You selected $desiredApp.DisplayName.",
  'Is this correct?',
  @('&Yes', '&No'),
  1)

