    $Destination = "C:\temp\"
    $ServerInstance = ".\SQLExpress"
    $dbname = "Web"
    $TableName = "RegistryMCOPCPAndPlanChanges"

invoke-sqlcmd -query "SELECT * FROM $TableName" -database $dbname -serverinstance $ServerInstance |export-csv -path $destination$TableName.csv