#region Teams

function Get-Team {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$GroupId
    )

    Get-MgTeam -TeamId $GroupId
}

function Test-TeamExists {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$GroupId
    )

    try {
        Get-Team -GroupId $GroupId -ErrorAction Stop | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

function New-Team {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$GroupId
    )

    $Body = @{
    "template@odata.bind" = "https://graph.microsoft.com/v1.0/teamsTemplates('standard')"
    "group@odata.bind"    = "https://graph.microsoft.com/v1.0/groups('$GroupId')"
    }

    New-MgTeam -BodyParameter $Body
}

#endregion

#region Team Membership

function Get-TeamMembers {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$TeamId,

        [Parameter(Mandatory)]
        [string]$UserId
    )

    Get-MgTeamMember `
        -TeamId $TeamId `
        -All
}

function Get-TeamMemberByUserId {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$TeamId,

        [Parameter(Mandatory)]
        [string]$UserId
    )

    Get-MgTeamMember `
        -TeamId $TeamId `
        -Filter "(microsoft.graph.aadUserConversationMember/userId eq '$UserId')" |
        Select-Object -First 1
}

function Add-TeamMember {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$TeamId,

        [Parameter(Mandatory)]
        [string]$UserId
    )

    $ExistingMember = Get-TeamMemberByUserId `
        -TeamId $TeamId `
        -UserId $UserId

    if ($null -ne $ExistingMember) {
        return $ExistingMember
    }

    $Body = @{
        '@odata.type'    = '#microsoft.graph.addUserConversationMember'
        roles            = @()
        'user@odata.bind' = "https://graph.microsoft.com/v1.0/users('$UserId')"
    }

    New-MgTeamMember `
        -TeamId $TeamId `
        -BodyParameter $Body
}

function Add-TeamOwner {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$TeamId,

        [Parameter(Mandatory)]
        [string]$UserId
    )

    $ExistingMember = Get-TeamMemberByUserId `
        -TeamId $TeamId `
        -UserId $UserId

        if ($null -eq $ExistingMember) {
            $Body = @{
            '@odata.type'    = '#microsoft.graph.aadUserConversationMember'
            roles            = @('owner')
            'user@odata.bind' = "https://graph.microsoft.com/v1.0/users('$UserId')"
            }

            return New-MgTeamMember `
            -TeamId $TeamId `
            -BodyParameter $Body
        }

        if ($ExistingMember.Roles -contains 'owner'){
            return $ExistingMember
        }

        $Body = @{
        '@odata.type' = '#microsoft.graph.aadUserConversationMember'
        roles         = @('owner')
    }

    Update-MgTeamMember `
        -TeamId $TeamId `
        -ConversationMemberId $ExistingMember.Id `
        -BodyParameter $Body
}

#endregion
