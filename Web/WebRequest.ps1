[xml]$Web = Invoke-WebRequest -uri "https://tableaudev.chas.org/admin/systeminfo.xml"
$websubpath = $Web.systeminfo.machines.machine
$websubpath.vizqlserver.status