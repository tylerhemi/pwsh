### Fill out these values required for detecting the registry key value
$reg_path = "HKLM\SOFTWARE\Policies\Google\Chrome" # Enter the Registry key path.
$reg_key = "CloudManagementEnrollmentToken" # Enter the Registry key dword name.
$reg_value = "" # Enter the desired value to REMEDIATE the vulnerability.
$reg_type = "String" # Do not change unless the Value is not a DWORD

try {
    Remove-Item -Path HKLM:\SOFTWARE\Google\Chrome\Enrollment -Force -ErrorAction SilentlyContinue
    Remove-Item -Path HKLM:\Software\WOW6432Node\Google\Enrollment -Force -ErrorAction SilentlyContinue
    Start-Sleep 2
    New-ItemProperty -Path Registry::$reg_path -Name $reg_key -PropertyType $reg_type -Value $reg_value -Force
    $regentry = Get-ItemProperty -Path Registry::$reg_path -Name $reg_key
        
    if ($regentry.CloudManagementEnrollmentToken -eq $reg_value){
        #Exit 0 for Intune if NO error
        Write-Host "User is enrolled! Exiting."
        exit 0
    }
    ElseIf ($null -eq $regentry.CloudManagementEnrollmentToken){
        #Exit 1 for Intune if error
        Write-Host "Registry Key does not exist! Creating it."
        exit 1}
    else {
        #Exit 1 for Intune if error
        Write-Host "User is not enrolled! Running again."
        exit 1
    }
}
catch {
    $errMsg = $_.Exception.Message
    return $errMsg
    exit 1
}
