
$ADGroups = Get-ADGroup -Filter * -SearchBase "OU=Folder Access Groups_new,OU=Security Groups,OU=Groups,DC=chas,DC=local" | Where {$_.name -notlike '*Shared*' -and $_.name -notlike '*NPRC*'}


foreach($group in $ADGroups){
$members = Get-ADGroupMember -Identity $group | Where-Object objectClass -eq "User" | Select name

If ($members -ne $null)
{Write-Output $group | Out-File -FilePath C:\tmp\groupCleanup.txt -Append 
 Write-Output $members | Out-File -FilePath C:\tmp\groupCleanup.txt -Append 
 Write-Output "-------------" | Out-File -FilePath C:\tmp\groupCleanup.txt -Append  } 
}