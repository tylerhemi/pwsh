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
