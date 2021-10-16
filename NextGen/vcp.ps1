#Create TMP folder if doesn't exist
if (!(Test-Path C:\tmp)) {
    New-Item -Path C:\ -Name tmp -ItemType Directory
}
#Log function stolen from internet
$Logfile = "C:\tmp\$ENV:computername.log"

Function LogWrite {
    Param ([string]$logstring)

    Add-content $Logfile -value "$(Get-Date) $logstring"
}

try {
    if ((Test-Path -Path "C:\Nextgen") -And (Get-ItemProperty -Path C:\NextGen\NGAppLauncher.exe).VersionInfo.FileVersion -lt '5.9.3.88')  {
        LogWrite "Found Nextgen installation requring update."
        for ($I = 0; $I -lt 2; $I++ ) {
            LogWrite "Starting VCP."
            Start-Process -FilePath "vcp.exe" -WorkingDirectory "C:\NextGen" -ArgumentList "/r"
            LogWrite "Waiting for VCP to finish."
            while(!(Get-Process -Name NGAppLauncher -ErrorAction SilentlyContinue)){
                Start-Sleep 10
                }
            Start-Sleep 5
            Stop-Process -Name NGAppLauncher
            LogWrite "Ran VCP /r successfully" 
            if(Test-Path -Path "C:\Users\Public\Public\NextGen 5.lnk"){
                Remove-Item -Path "C:\Users\Public\Public\NextGen 5.lnk"
                LogWrite "Deleted the NextGen 5 shortcut from public desktop."
            }
                
            
        }
        LogWrite "Exiting script and rebooting. Exit 0"  
        Restart-Computer -Force      
        Exit 0
    }
    else {
        LogWrite "Nextgen path not found or is already updated. Exit 0"
        Exit 0
    }
}
catch {
    $errMsg = $_.Exception.Message
    LogWrite "$errMsg Exit 1"
    Exit 1
}