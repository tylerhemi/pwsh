$computers = Get-Content C:\tmp\Wsus.txt |
ForEach-Object {
$disk = Get-WmiObject Win32_LogicalDisk -ComputerName $_ -Filter "DeviceID='D:'" |
Select-Object Size,FreeSpace

$Size = $disk.Size / 1GB
$SizeRounded = [math]::Round($Size)

$Freespace = $disk.FreeSpace / 1GB
$FreeSpaceRouned = [math]::Round($FreeSpace)

$UsedSpace = $disk.Size / 1GB - $disk.FreeSpace / 1GB
$UsedSpaceRounded = [math]::Round($UsedSpace)


Write-Host $_, Total Size = $SizeRounded"GB", FreeSpace = $FreeSpaceRouned"GB", UsedSpace = $UsedSpaceRounded"GB"
}