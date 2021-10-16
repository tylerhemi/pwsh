#Store CimInstance in variable

$pcs = 'chas4404','chas4402','chas4588','chas4752','chas4753','chas4975','chas4291'

ForEach($pc in $pcs){
    Invoke-Command -computername $pc{
$var = Get-CIMInstance -ClassName win32_product | Where-Object Name -EQ "uberAgent"
Write-Host $Using:pc
Remove-CimInstance -InputObject $var
    }

}