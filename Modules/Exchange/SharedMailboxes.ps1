#region Shared Mailboxes

function Get-SharedMailbox {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Identity
    )

    Get-Mailbox `
        -Identity $Identity `
        -RecipientTypeDetails SharedMailbox
}


function Test-SharedMailboxExists {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Identity
    )
    
    try {
        Get-SharedMailbox `
            -Identity $Identity `
            -ErrorAction Stop | Out-Null

            return $true
    }
    catch {
        return $false
    }
}

function New-SharedMailbox {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [string]$Alias
    )

    New-Mailbox `
        -Shared `
        -Name $Name `
        -Alias $Alias
}
#endregion
