#Set execution policy for this process to allow scripts/ had issues installing and importing modules without this
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope process
#Test for NuGet which is needed to install AudioDeviceCmdlets
Try{
    Import-Module NuGet -ErrorAction Stop
}
catch [System.IO.FileNotFoundException]{
        Install-PackageProvider -Name NuGet -Force -Scope CurrentUser | Out-Null
        Install-Module Nuget -Force -Scope CurrentUser| Out-Null
        $Error.Clear()
    }
#Write-EventLog -LogName "Windows PowerShell" -Source "Powershell" -EventID 10000 -EntryType "Information" -Message "Installing NuGet"}
#Check for AudioDeviceCmdlets package, install and import if not found.
try {
    Import-Module AudioDeviceCmdlets -ErrorAction Stop
}
catch  [System.IO.FileNotFoundException]{
    Install-Module AudioDeviceCmdlets -Force -Scope CurrentUser
    Import-Module AudioDeviceCmdlets
    $Error.Clear()
} 
#Gets AudioDevice list, selects playback devices and Echo cancelling speakerphone, then sets it as default
Get-AudioDevice -List | Where-Object {$_.Type -eq "Playback" -and $_.Name -like "Echo Cancelling Speakerphone*"} | Set-AudioDevice | Out-Null
#Set AudioDevice to not be mute and sets volume
Set-AudioDevice -PlaybackMute $false
Set-AudioDevice -PlaybackVolume 90

#Gets AudioDevice list, selects recording devices and Echo cancelling speakerphone, then sets it as default
Get-AudioDevice -List | Where-Object {$_.Type -eq "Recording" -and $_.Name -like "Echo Cancelling Speakerphone*"} | Set-AudioDevice | Out-Null
Set-AudioDevice -RecordingMute $false
Set-AudioDevice -RecordingVolume 90

if($Error -ne $null){
    $Error | Out-File C:\temp\PWSHError.txt
}