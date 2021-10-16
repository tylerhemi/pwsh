$FontPath = "\\chas.local\data\CommonData\Fonts\"
if (Test-Path -Path $FontPath) {
    $FontItem = Get-Item -Path $FontPath
    if ($FontItem -is [IO.DirectoryInfo]) {
        if ($Recurse) {
            $Fonts = Get-ChildItem -Path $FontItem -Include ('*.fon','*.otf','*.ttc','*.ttf') -Recurse
        } else {
            $Fonts = Get-ChildItem -Path "$FontItem\*" -Include ('*.fon','*.otf','*.ttc','*.ttf')
        }

        if (!$Fonts) {
            throw ('Unable to locate any fonts in provided directory: {0}' -f $FontItem.FullName)
        }
    } elseif ($FontItem -is [IO.FileInfo]) {
        if ($FontItem.Extension -notin ('.fon','.otf','.ttc','.ttf')) {
            throw ('Provided file does not appear to be a valid font: {0}' -f $FontItem.FullName)
        }

        $Fonts = $FontItem
    } else {
        throw ('Expected directory or file but received: {0}' -f $FontItem.GetType().Name)
    }
} else {
    throw ('Provided font path does not appear to be valid: {0}' -f $FontPath)
}

foreach ($Font in $Fonts) {
    Write-Host ('Installing font: {0}' -f $Font.BaseName)
    #$Font
    Copy-Item $Font "C:\Windows\Fonts"
    New-ItemProperty -Name $Font.BaseName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -PropertyType string -Value $Font.name         
}
