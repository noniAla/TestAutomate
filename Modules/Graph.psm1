Import-Module .\Modules\Logging.psm1

. "$PSScriptRoot\Graph\Groups.ps1"
. "$PSScriptRoot\Graph\Teams.ps1"
. "$PSScriptRoot\Graph\SharePoint.ps1"
. "$PSScriptRoot\Graph\Users.ps1"


# move this to profile.ps1 later
function Connect-GraphService {
    [CmdletBinding()]
    param()

  
    try {
        Write-Host "Connecting to Microsoft Graph..."

        Connect-MgGraph

        Write-Host "Connected."
    }
      # Authentication Exception
    catch {

    Write-OperationalLog  `
        -Category "Graph - Authentication Error"  `
        -Message $_.Exception.Message

        throw
    }

   
}

function Get-GraphContextInfo {
    [CmdletBinding()]
    param()

    Get-MgContext

}

function Test-GraphConnection {
    [CmdletBinding()]
    param()

    try {
        Get-MgUser -Top 1 -ErrorAction Stop

        return $true
    }

    catch {
        Write-OperationalLog  `
        -Category "Graph - Session Unreachable"  `
        -Message $_.Exception.Message

        return $false
    }
}

Export-ModuleMember -Function *
