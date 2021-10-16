$credential = Get-Credential
$pcs = Get-Content C:\tmp\pc.txt
foreach ($pc in $pcs) {
    Invoke-Command -ComputerName $pc -Credential $credential -ScriptBlock {
        foreach ($NIC in (Get-NetAdapter -Physical)){
            $PowerSaving = Get-CimInstance -ClassName MSPower_DeviceEnable -Namespace root\wmi | ? {$_.InstanceName -match [Regex]::Escape($NIC.PnPDeviceID)}
                if ($PowerSaving.Enable){
            $PowerSaving.Enable = $false
            $PowerSaving | Set-CimInstance
            }
        }
    }
}