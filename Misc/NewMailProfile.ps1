$pass = '8675309'
$passInput = Read-Host -Prompt 'Please input the password from the email'
$regPath = 'HKCU:\Software\CHAS Migration\Mail'
$date = Get-Date
#Verify password
if ($passInput -eq $pass){
    #check for registry key
    if((Get-Itemproperty $regPath -Name MailMigrated -ErrorAction SilentlyContinue | Select-Object -ExpandProperty NewProfile -ErrorAction SilentlyContinue ) -ne $True){
        #Close Outlook if running 
        Get-Process | Where-Object name -like outlook | Stop-Process -Force | Out-Null
        Start-Sleep 3
        #Create the new profile
        reg add HKCU\Software\Microsoft\Office\16.0\Outlook\Profiles\Office365 /F
        reg add HKCU\Software\Microsoft\Office\16.0\Outlook /v DefaultProfile /t REG_SZ /d Office365 /F
        #Set registry key so it doesn't keep recreating
        New-Item -Path $regPath -Force | Out-Null
        #Set property for mail profile being cleared to true
        New-ItemProperty -Path $regPath -Name NewProfile -Value 'True' | Out-Null
        #Set date/time mail profile was cleared
        New-ItemProperty -Path $regPath -Name WhenCreated -Value "$date" | Out-Null
       
        #If there are errors write them to documents folder.
        if($Error -ne $null){
                $Error | Out-File ($Env:USERPROFILE + "\Documents\NewMailProfileError.txt")
            }
            Start-Sleep 1
            Start-Process Outlook.exe
        }
        else {Exit-PSHostProcess} 
        if($Error -ne $null){$Error | Out-File ($Env:USERPROFILE + "\Documents\NewMailProfileError.txt")}
        }
        
    
#Wrong password output.
else {Write-Host -ForegroundColor "RED" "Incorrect Password, don't run this unless you were instructed to!"
Write-Host 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');}

if($Error -ne $null){$Error | Out-File ($Env:USERPROFILE + "\Documents\NewMailProfileError.txt")}
