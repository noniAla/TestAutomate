function Connect-GraphService {
    [CmdletBinding()]
    param()

    Write-Host "Connecting to Microsoft Graph..."

    Connect-MgGraph

    Write-Host "Connected."
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
        $user = Get-MgUser -Top 1 -ErrorAction Stop

        return $true
    }
    catch {
        return $false
    }
}

Export-ModuleMember -Function *
