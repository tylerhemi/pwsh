try {
    $MModalVersion = (Get-Item 'C:\Program Files (x86)\MModal\MModal Fluency Direct\FluencyDirectLauncher.exe').VersionInfo.FileVersion
        
    if ($null -eq $MModalVersion){
        #Exit 0 for Intune 
        Write-Output "MModal not installed."
        exit 0
    }
    if ($MModalVersion -lt "10.0.6118.2094"){
        #Exit 1 for Intune
        Write-Output "old version of MModal detected"
        exit 1
    }
    else {
        #Exit 1 for Intune 
        Write-Output "MModal is up to date."
        exit 0
    }
}
catch {
    $errMsg = $_.Exception.Message
    return $errMsg
    exit 0
}