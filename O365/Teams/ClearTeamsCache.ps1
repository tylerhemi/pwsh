##Clear teams cache.
try{
    Get-Process -Name *teams* | Stop-Process -Force
    Get-Process -name *outlook* | Stop-Process -Force
    Start-Sleep 5
    Get-ChildItem -Path "$Env:APPDATA\Microsoft\Teams" | Remove-Item -Recurse -Force
    Start-Job {Start-Process -path "$ENV:LocalAppdata\Microsoft\Teams\Current\Teams.exe"}
    Start-Job {Start-Process outlook.exe}
}
    catch {
        $errMsg = $_.Exception.Message
        Write-error -Message $errMsg
    }
