$credential = Get-Credential

Invoke-Command -Credential $credential -ComputerName tpdc02 -ScriptBlock {
Foreach ($user in(Import-CSV '\\chas4853\c$\tmp\AD UpdateFullTitle.csv')){
    $user.Account
    Set-ADUser -Identity $user.Account -Department $user.Dept -Division $user.Division -Office $user.Location -Title $user.Title -Company "CHAS Health"
    }
}  