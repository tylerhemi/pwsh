$fs = '\\tp-fs-01\DEPARTMENTS\NPRC'
$groups = Get-Content "\\chas4853\c`$\tmp\nprc.txt"
ForEach ($group in $groups){
$acl = Get-Acl $fs
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("$group","ReadAndExecute","Allow")
$acl.SetAccessRule($AccessRule)
$acl | Set-Acl $fs
}