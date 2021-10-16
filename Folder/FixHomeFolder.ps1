#Have you ever propagated permissions when you shouldn’t have, here’s a script to help save you some time correcting that change.  
#test

#Dennis and I used this when ACLs got messed up on staff and student folders at WF. 

$HomeFolders=GET-CHILDITEM C:\Documents\Users
Foreach ( $Folder in $HomeFolders )
{
$Username=’Chas\’+$Folder.Name
$colRights = [System.Security.AccessControl.FileSystemRights]"FullControl" 
$InheritanceFlag = [System.Security.AccessControl.InheritanceFlags]"ContainerInherit, ObjectInherit" 
$PropagationFlag = [System.Security.AccessControl.PropagationFlags]::None 
$objType =[System.Security.AccessControl.AccessControlType]::Allow 

$objUser = "$Username"

$objACE = New-Object System.Security.AccessControl.FileSystemAccessRule `
                         ($objUser, $colRights, $InheritanceFlag, $PropagationFlag, $objType) 
$objACL = Get-ACL $Folder.fullname 
$objACL.AddAccessRule($objACE) 

Set-ACL $Folder.fullname $objACL
}

#Here are two links that I used to create the script. It took info from both links to get it right. 
#1.	http://blogs.technet.com/b/heyscriptingguy/archive/2011/09/18/restore-ntfs-security-permissions-by-using-powershell.aspx
#2.	http://technet.microsoft.com/en-us/library/ff730951
