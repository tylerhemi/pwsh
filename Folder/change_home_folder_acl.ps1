import-module activedirectory

$rootfolder = Get-ChildItem -Path \\filesvr-02\user$
 foreach ($userfolder in $rootfolder) {
         $userfolder.FullName
         If (get-aduser "$userfolder") {
             Get-Acl $userfolder.FullName | Format-List
             $acl = Get-Acl $userfolder.FullName
             $acl.SetAccessRuleProtection($True, $False)
             $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Everyone","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
             $acl.RemoveAccessRuleAll($rule)
             $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
             $acl.AddAccessRule($rule)
      $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("System","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
             $acl.AddAccessRule($rule)
             $rule = New-Object System.Security.AccessControl.FileSystemAccessRule($userfolder.Name,"FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
             $acl.AddAccessRule($rule)
             $acct=New-Object System.Security.Principal.NTAccount($userfolder.name)
             $acl.SetOwner($acct)
             foreach($subFolder in (Get-ChildItem $userfolder.FullName | Where {$_.psIsContainer -eq $true})){
  		Set-Acl $subfolder.FullName $acl
      	     }
             Set-Acl $userfolder.FullName $acl
             Get-Acl $userfolder.FullName  | Format-List
         }
 }