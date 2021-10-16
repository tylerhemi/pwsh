try {
    if(Test-Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization\NoLockScreen -ErrorAction Stop){
    Write-Output "Key already exits"
    Exit 0
    }
    else {
        Write-Host "Missing they key"
        Exit 1  
    }
}
catch {
    $errMsg = $_.Exception.Message
    Write-Error $errMsg
    exit 1
}