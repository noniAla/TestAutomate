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
        [string]$Alias,

        [Parameter(Mandatory)]
        [string]$PrimarySmtpAddress
    )

    $Parameters = @{
        Shared = $true
        Name = $DisplayName
        Alias = $Alias
    }

    if ($PrimarySmtpAddress) {
        $Parameters['PrimarySmtpAddres'] = $PrimarySmtpAddress
    }

    New-Mailbox @Parameters
}
#endregion

#region Inclusion in Mailbox"

function Add-SharedMailboxFullAccess {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Identity,

        [Parameter(Mandatory)]
        [string]$User
    )

    Add-MailboxPermission `
        -Identity $Identity `
        -User $User `
        -AccessRights FullAccess `
        -InheritanceType All
}

function Remove-SharedMailboxFullAccess {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Identity,

        [Parameter(Mandatory)]
        [string]$User
    )

    Remove-MailboxPermission `
        -Identity $Identity `
        -User $User `
        -AccessRights FullAccess `
        -Confirm:$false
}

#region send as

function Add-SharedMailboxSendAs {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Identity,

        [Parameter(Mandatory)]
        [string]$User
    )

    Add-MailboxPermission `
        -Identity $Identity `
        -User $User `
        -AccessRights SendAs `
        -Confirm:$false
}

function Remove-SharedMailboxSendAs {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Identity,

        [Parameter(Mandatory)]
        [string]$User
    )

    Remove-MailboxPermission `
        -Identity $Identity `
        -User $User `
        -AccessRights SendAs `
        -Confirm:$false
}
#endregion

#endregion
