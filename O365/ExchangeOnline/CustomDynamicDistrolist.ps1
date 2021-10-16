Get-DynamicDistributionGroup -identity chasall | Set-DynamicDistributionGroup -recipientfilter {((RecipientType -eq 'UserMailbox') -and 
                 (-not (Department -eq $null)) -and 
                 (-not(Name -like 'SystemMailbox{*')) -and (-not(Name -like 'CAS_{*')) -and
                 (-not(RecipientTypeDetailsValue -eq 'MailboxPlan')) -and (-not(RecipientTypeDetailsValue -eq 'DiscoveryMailbox')) -and
                 (-not(RecipientTypeDetailsValue -eq 'PublicFolderMailbox')) -and (-not(RecipientTypeDetailsValue -eq 'ArbitrationMailbox')) -and
                 (-not(RecipientTypeDetailsValue -eq 'AuditLogMailbox')) -and (-not(RecipientTypeDetailsValue -eq 'AuxAuditLogMailbox')) -and
                 (-not(RecipientTypeDetailsValue -eq 'SupervisoryReviewPolicyMailbox')) -and (-not(RecipientTypeDetailsValue -eq 'GuestMailUser')))}