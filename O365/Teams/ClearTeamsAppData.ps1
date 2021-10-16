Write-Output "Stopping Teams and Outlook Process"
if($null -ne(Get-Process -name Teams)){
    Stop-Process -Name teams -Force
} 
if($null -ne(Get-Process -name Outlook)){
    Stop-Process -Name Outlook -Force
} 
Start-Sleep 5
Write-Output "Deleting Appdata/Roaming Teams folder"
Remove-Item -Path $Env:APPDATA\Microsoft\Teams -Recurse -Force
Write-Output "Finished! Please reopen teams"
