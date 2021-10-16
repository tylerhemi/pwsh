try {
    cmd.exe /c "w32tm /config /syncfromflags:domhier /update"
    cmd.exe /c "net stop w32time"
    cmd.exe /c "net start w32time"
    Exit 0
}
catch {
    $errMsg = $_.Exception.Message
    Write-Error $errMsg
    exit 1
}



