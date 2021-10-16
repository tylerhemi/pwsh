$FSArgs = {$_.OperatingSystem -like "*Server*" -and ($_.Name -like "*fps*" -or $_.Name -like "*fs*")}
$SearchBase = "OU=Branch Office Servers,OU=Virtual Servers,OU=Member Servers,DC=chas,DC=local"
$FileServers = Get-ADComputer -Filter * -Properties * -SearchBase $SearchBase | Where-Object $FSArgs | Select-Object Name -ExpandProperty Name
$FileServers = $FileServers | Where-Object {($_ -ne "LB-FS-02" -and $_ -ne "IB-FPS-01")}

foreach ($server in $FileServers){
    Invoke-Command -ComputerName $server -credential (import-clixml C:\temp\creds.xml) -ScriptBlock{
        if (!(Test-Path "C:\DFSRoots\IT"))
            {
                New-Item C:\DFSRoots\IT -ItemType Directory
                New-SmbShare -Name "IT" -Path "C:\DFSRoots\IT" -FullAccess "Administrators" -ReadAccess "Everyone"
            }
            if (!(Test-Path "D:\repo"))
            {
                New-Item D:\repo -ItemType Directory
               ## Don't know if this is needed.
               ## New-SmbShare -Name "repo" -Path "D:\repo" -FullAccess "Administrators" -ReadAccess "Everyone"
            }
           }

}