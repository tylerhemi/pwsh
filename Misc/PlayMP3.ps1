
Function Play-MP3{
Add-Type -AssemblyName presentationCore
$mediaPlayer = New-Object system.windows.media.mediaplayer
$mediaPlayer.open('C:\temp\wardaddy.mp3')
$mediaPlayer.Play()
}

Play-MP3
