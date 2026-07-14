#region Microsoft 365 Groups

function Get-M365Group {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$DisplayName
    )

    Get-MgGroup -Filter "displayName eq '$DisplayName'"
}

function Test-M365GroupExists {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$DisplayName
    )

    $Group = Get-M365Group -DisplayName $DisplayName

    return ($null -ne $Group)
}

function New-M365Group {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$DisplayName,
        [string]$Description
    )

    $MailNickname = $DisplayName.Replace(' ','')

    New-MgGroup `
        -DisplayName $DisplayName `
        -Description $Description `
        -MailEnabled:$true `
        -MailNickname $MailNickname `
        -SecurityEnabled:$false `
        -GroupTypes @("Unified")
}

#endregion

#region Security Groups

function Get-SecurityGroup {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$DisplayName
    )

    Get-MgGroup `
        -Filter "displayName eq '$DisplayName' and securityEnabled eq true"
}

function Test-SecurityGroupExists {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$DisplayName
    )

    return ($null -ne (Get-SecurityGroup -DisplayName $DisplayName))
}

function New-SecurityGroup {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$DisplayName,

        [string]$Description
    )

    $MailNickname = $DisplayName.Replace(' ','')

    New-MgGroup `
        -DisplayName $DisplayName `
        -Description $Description `
        -MailEnabled:$false `
        -MailNickname $MailNickname `
        -SecurityEnabled:$true
}


#endregion


#region Membership

function Get-GroupMembers {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$GroupId
    )

    Get-MgGroupMember -GroupId $GroupId
}

function Add-GroupMembership {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$GroupId,

        [Parameter(Mandatory)]
        [string]$UserId
    )

    New-MgGroupMemberByRef `
        -GroupId $GroupId `
        -OdataId "https://graph.microsoft.com/v1.0/directoryObjects/$UserId"
}

function Remove-GroupMembership {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$GroupId,

        [Parameter(Mandatory)]
        [string]$UserId
    )

    Remove-MgGroupMemberByRef `
        -GroupId $GroupId `
        -DirectoryObjectId $UserId

}
#endregion

#region Ownership

function Get-GroupOwners {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$GroupId
    )

    Get-MgGroupOwner -GroupId $GroupId
}

function Add-GroupOwnership {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$GroupId,

        [Parameter(Mandatory)]
        [string]$UserId
    )

    New-MgGroupOwnerByRef `
        -GroupId $GroupId `
        -OdataId "https://graph.microsoft.com/v1.0/directoryObjects/$UserId"
}

function Remove-GroupOwnership {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$GroupId,

        [Parameter(Mandatory)]
        [string]$UserId
    )

    Remove-MgGroupOwnerByRef `
        -GroupId $GroupId `
        -DirectoryObjectId $UserId
}

#endregion
