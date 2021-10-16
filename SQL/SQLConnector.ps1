
Try{
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    Install-Module SQLServer -Confirm:$False -AllowClobber
    Install-Module dbatools -Confirm:$False -AllowClobber
    Import-Module SqlServer
    Import-Module dbatools
}catch{
    $errMsg = $_.Exception.Message
    Write-Error $errMsg
    exit 1
}



$SqlServer = New-Object Microsoft.SqlServer.Management.Smo.Server($SqlServer)

Add-SQLLogin -LoginName $User -ServerInstance $Server -DefaultDatabase "master" -LoginType $LoginType -LoginPSCredential $NewSQLLogin -Enable -GrantConnectSql


$DBs = Get-SqlDatabase -ServerInstance $Server




foreach($DB in $DBs) {
    $NewUser = New-Object Microsoft.SqlServer.Management.Smo.User($SqlServer.Databases[$DB], $NewSQLLogin.UserName)
    $NewUser.Login = $NewSQLLogin.UserName
    $NewUser.Create()
    $NewUser.AddToRole("db_datareader") 
}
