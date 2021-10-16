try {
    New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization -ErrorAction Stop
    New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization -Name NoLockScreen -Value 1 -PropertyType DWord -Force -ErrorAction Stop
    Exit 0
}
catch{
    $errMsg = $_.Exception.Message
    Write-Error $errMsg
    exit 1
}