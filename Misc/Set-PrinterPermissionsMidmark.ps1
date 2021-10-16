Add-Printer -Name "Midmark PDF Converter" -DriverName "Microsoft Print To PDF" -PortName "nul:"
Set-Printer -Name "Midmark PDF Converter" -DriverName "Microsoft Print To PDF" -PortName "nul:"
Set-Printer -Name "Midmark PDF Converter" -DriverName "Amyuni Document Converter 450" -PortName "nul:"
Set-Printer -Name 'Midmark PDF Converter' -DriverName "Amyuni Document Converter 450" -PermissionSDDL 'G:SYD:(A;OIIO;RPWPSDRCWDWO;;;WD)(A;;LCSWSDRCWDWO;;;WD)(A;CIIO;RC;;;AC)(A;OIIO;RPWPSDRCWDWO;;;AC)(A;;SWRC;;;AC)(A;CIIO;RC;;;CO)(A;OIIO;RPWPSDRCWDWO;;;CO)(A;;LCSWSDRCWDWO;;;BA)(A;OIIO;RPWPSDRCWDWO;;;BA)'
Get-CimInstance -ClassName Win32_Printer -Filter "Name = 'Midmark PDF Converter'" | Set-CimInstance -Property @{Direct="True"}
