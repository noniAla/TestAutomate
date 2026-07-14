#region Distribution Groups

function Get-DistributionGroupByName {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$DisplayName
    )

    Get-DistributionGroup `
        -Identity $DisplayName
        -ErrorAction SilentlyContinue
}

function Test-DistributionGroupExists {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$DisplayName
    )

    return (null -ne (
        Get-DistributionGroupByName `
            -DisplayName $DisplayName
    ))
}


function New-DistributionGroup {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$DisplayName,

        [Parameter(Mandatory)]
        [string]$Alias,

        [string]$PrimarySmtpAddress
    )

    New-DistributionGroup `
        -Name $DisplayName `
        -DisplayName $DisplayName `
        -Alias $Alias `
        -PrimarySmtpAddress $PrimarySmtpAddress
}
#endregion

#region Membership

function Get-DistributionGroupMembers {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Identity
    )

    Get-DistributionGroupMembers `
        -Identity $Identity
}

function Add-DistributionGroupMembership {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Identity,

        [Parameter(Mandatory)]
        [string]$Member
    )

    Add-DistributionGroupMembership `
        -Identity $Identity `
        -Member $Member
}

function Remove-DistributionGroupMembership {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Identity,

        [Parameter(Mandatory)]
        [string]$Member
    )

    Remove-DistributionGroupMembership `
        -Identity $Identity `
        -Member $Member `
        -Confirm:$false
}

#endregion

