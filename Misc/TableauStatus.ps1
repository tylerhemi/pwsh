$Tableaudev = New-Object System.Xml.XmlDocument
$Tableaudev.load("https://tableaudev.chas.org/admin/systeminfo.xml")

$Tableaudev | fl