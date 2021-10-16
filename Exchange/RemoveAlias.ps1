$provider = Get-content C:\users\themingsen\Desktop\Credentialing2.txt
foreach ($provider in $providers) {Set-Mailbox "credentials@chas.org" -EmailAddresses @{remove="$provider"}}