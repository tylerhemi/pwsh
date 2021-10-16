<#Copys the officeUI file to local appdata.
Tyler Hemingsen
6/30/2021
#>
$OfficePath = "$ENV:LOCALAPPDATA\Microsoft\Office\olkmailitem.officeUI"

if(!(Test-Path -Path $OfficePath)){
    try {
        Copy-Item -Path "\\chas.local\data\deploy\Applications\Outlook Ribbon\olkmailitem.officeUI" -Destination $OfficePath -ErrorAction Stop
        Exit 0
    }
    catch {
        $errMsg = $_.Exception.Message
        Write-error -Message $errMsg
        Exit 1
    }
    else
    Write-Output exists
    Exit 0
}