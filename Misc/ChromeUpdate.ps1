$computers = Get-Content C:\users\themingsen\Downloads\99687d68-3214-4679-852b-00b6a95a053f.json | ConvertFrom-Json
foreach($pc in $computers.browser_devices.machine_name){
    Invoke-Command $pc -scriptblock{
    if(!(Test-Path HKLM:\SOFTWARE\Policies\Google\Update)){
        New-Item -Path HKLM:\SOFTWARE\Policies\Google -Name Update
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Google\Update' -Name UpdateDefault -Value 1
    }
    if(!(Test-Path HKLM:\SOFTWARE\Policies\Google\Update\UpdateDefault)){
        New-Item -Path HKLM:\SOFTWARE\Policies\Google\Update -Name UpdateDefault
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Google\Update' -Name UpdateDefault -Value 1
    }
    if((Get-ItemPropertyValue -Path HKLM:\SOFTWARE\Policies\Google\Update -Name UpdateDefault) -ne "1"){
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Google\Update' -Name UpdateDefault -Value 1
    }
}
}