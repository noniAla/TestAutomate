#region Mail Enabled Security Groups

function Get-MailEnabledSecurityGroup {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$DisplayName
    )

    Get-DistributionGroup `
        -Identity $DisplayName `
        -ErrorAction SilentlyContinue
}

function Test-MailEnabledSecurityGroupExists {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$DisplayName
    )

    return ($null -ne (
        Get-MailEnabledSecurityGroup `
            -DisplayName $DisplayName
    ))
}

function New-MailEnabledSecurityGroup {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$DisplayName,

        [Parameter(Mandatory)]
        [string]$Alias,

        [Parameter(Mandatory)]
        [string]$PrimarySmtpAddress
    )

    New-DistributionGroup `
        -Name $DisplayName `
        -DisplayName $DisplayName `
        -Alias $Alias `
        -PrimarySmtpAddress $PrimarySmtpAddress `
        -Type Security
}

#endregion

#region Membershp

function Get-MailEnabledSecurityGroupMembers {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Identity
    )

    Get-DistributionGroupMember `
        -Identity $Identity
}

function Add-MailEnabledSecurityGroupMembership {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Identity,

        [Parameter(Mandatory)]
        [string]$Member
    )

    Add-DistributionGroupMember `
        -Identity $Identity `
        -Member $Member 
}

function Remove-MailEnabledSecurityGroupMembership {
    [CmdletBinding()]
    params(
        [Parameter(Mandatory)]
        [string]$Identity,

        [Parameter(Mandatory)]
        [string]$Member
    )

    Remove-DistributionGroupMember `
        -Identity $Identity `
        -Member $Member `
        -Confirm:$false
}

#endregion
