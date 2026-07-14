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
