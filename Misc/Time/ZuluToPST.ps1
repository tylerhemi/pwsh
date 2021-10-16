$timestamp = Read-Host "enter zulu time"
$datetime  = ([DateTime]$timestamp).ToUniversalTime()


[TimeZoneInfo]::ConvertTimeBySystemTimeZoneId($datetime, 'Pacific Standard Time')