    
    
    
    foreach($cert in Get-ChildItem cert:\LocalMachine\My\) {
       # Write BEGIN line
       $certStrings  = @('-----BEGIN CERTIFICATE-----')

       # Export cert data
       $certData     = $cert.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert)

       # Convert to Base64 + append
       $certStrings += [Convert]::ToBase64String($certData, [System.Base64FormattingOptions]::InsertLineBreaks)

       # Write END line
       $certStrings += '-----END CERTIFICATE-----'

       #Write Cert strings
        $certStrings
    }
