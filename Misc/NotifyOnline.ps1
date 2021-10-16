Function Play-MP3{
    Add-Type -AssemblyName presentationCore
    $mediaPlayer = New-Object system.windows.media.mediaplayer
    $mediaPlayer.open('C:\temp\hey_listen.mp3')
    $mediaPlayer.Play()
    }
    
DO {
    $ping = Test-NetConnection -computername 192.168.1.20 | Select-Object PingSucceeded -ExpandProperty PingSucceeded
} until ($ping -eq $True)
#[console]::beep(2000,1000)
Play-MP3
