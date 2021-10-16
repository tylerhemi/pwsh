#
#

#
$2016 = get-adcomputer -filter 'operatingsystem -like "*server 2016*"' -properties OperatingSystem
$cred = Import-Clixml C:\temp\creds.xml

foreach($server in $2016){
Invoke-Command $server.Name -Credential $cred -ScriptBlock{

Register-ScheduledJob -Name "MMAInstall" -RunNow -Credential $Using:cred -ScriptBlock{

$MMAInstaller = "\\chas.local\data\Deploy\Applications\Defender\MMASetup-AMD64.exe"
$WorkspaceID = "redacted"
$WorkspaceKey = "redacted"
$MMAexe = "cmd"
$MMAArgs = "/c MMASetup-AMD64.exe /c /t:C:\temp\MMAAgent"


$SetupCmd = "setup.exe" 
$Argument = "/qn ADD_OPINSIGHTS_WORKSPACE=1 OPINSIGHTS_WORKSPACE_ID=$WorkspaceID OPINSIGHTS_WORKSPACE_KEY=$WorkspaceKey AcceptEndUserLicenseAgreement=1"

if ($null -eq (Get-service HealthService -ErrorAction SilentlyContinue)){
        if(!(Test-Path C:\temp\MMAAgent)){
            New-Item -Path C:\temp\MMAAgent -ItemType Directory
    }
    Copy-Item $MMAInstaller C:\temp -Force
    Start-Process $MMAexe -WorkingDirectory C:\temp -ArgumentList $MMAArgs -Wait
    Start-Process $SetupCmd -WorkingDirectory C:\temp\MMAAgent -ArgumentList $Argument -Wait
    Start-Sleep 30
    Unregister-ScheduledJob -Name "MMAInstall"
}
Else{
    Unregister-ScheduledJob -Name "MMAInstall"
}
}

}
}