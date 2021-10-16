### Fill out these values required for detecting the registry key value
$reg_path = "HKLM\SOFTWARE\Policies\Google\Chrome" # Enter the Registry key path.
$reg_key = "CloudManagementEnrollmentToken" # Enter the Registry key dword name.
$reg_value = "" # Enter the desired value to REMEDIATE the vulnerability.

try {
    $regentry = Get-ItemProperty -Path Registry::$reg_path -Name $reg_key
        
    if ($regentry.CloudManagementEnrollmentToken -eq $reg_value){
        #Exit 0 for Intune if NO error
        Write-Output "User is already enrolled! Exiting."
        exit 0
    }
    ElseIf ($null -eq $regentry.CloudManagementEnrollmentToken){        
        #Exit 1 for Intune if error
        Write-Output "Registry Key does not exist! Creating it."
        exit 1}
    else {
        #Exit 1 for Intune if error
        Write-Output "User is not enrolled! Running remediation script."
        exit 1
    }
}
catch {
    $errMsg = $_.Exception.Message
    return $errMsg
    exit 1
}