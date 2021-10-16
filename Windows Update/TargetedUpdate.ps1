$cred = Import-Clixml C:\temp\creds.xml
$DCS = Get-ADComputer -SearchBase "OU=Domain Controllers,DC=chas,DC=local" -Filter * | Select-Object Name -ExpandProperty Name

$KB12 = "KB5003671"
$KB16 = "KB5003638"
$KB19 = "KB5003646"

function Set-TLS {
    param (
        
    )
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
}

foreach ($DC in $DCS){

    Invoke-Command -ComputerName $DC -Credential $cred -ScriptBlock{
        #Check for NuGet
        Try{
            Import-Module NuGet -ErrorAction Stop
        }
        catch [System.IO.FileNotFoundException]{
                Install-PackageProvider -Name NuGet -Force | Out-Null
                Install-Module Nuget -Force | Out-Null
                $Error.Clear()
        }    
                       
        #Check for PSWindowsUpdate Module
        Try{
            Import-Module PSWindowsUpdate -ErrorAction Stop
        }
        catch [System.IO.FileNotFoundException]{
                Install-Module PSWindowsUpdate -Force | Out-Null
                $Error.Clear()
        }
        
        $OSCaption = (Get-CimInstance Win32_OperatingSystem).Caption
       
        switch -Wildcard ($OSCaption){
            "*Server 2012*" {   if(Get-WindowsUpdate -IsInstalled -KBArticleID $using:KB12 ){
                                    Write-Output "Update is already installed on $using:DC"
                                    } else {
                                        Register-ScheduledJob -Name "Install $using:KB12" -ScriptBlock{Install-WindowsUpdate -KBArticleID $using:KB12 -Confirm:$false} -RunNow
                                            if(Get-WindowsUpdate -IsInstalled -KBArticleID $using:KB12 ){
                                                Write-Output "Update is already installed on $using:DC"
                                                Break}
                                            }  
                                        }
            "*Server 2016*" {   if(Get-WindowsUpdate -IsInstalled -KBArticleID $using:KB16){
                                    Write-Output "Update is already installed on $using:DC"
                                    } else {
                                        Register-ScheduledJob -Name "Install $using:KB16" -ScriptBlock{Install-WindowsUpdate -KBArticleID $using:KB16 -Confirm:$false} -RunNow
                                            if(Get-WindowsUpdate -IsInstalled -KBArticleID $using:KB16 ){
                                                Write-Output "Update was installed on $using:DC"
                                                Break}
                                            } 
                                        }
                                 
            "*Server 2019*" {   if(Get-WindowsUpdate -IsInstalled -KBArticleID $using:KB19){
                                        Write-Output "Update is already installed on $using:DC"
                                    } else {
                                        Register-ScheduledJob -Name "Install $using:KB19" -ScriptBlock{Install-WindowsUpdate -KBArticleID $using:KB19 -Confirm:$false} -RunNow
                                            if(Get-WindowsUpdate -IsInstalled -KBArticleID $using:KB19 ){
                                            Write-Output "Update was installed on $using:DC"
                                            Break}
                                        } 
                                    }          
        }
        
    }
}