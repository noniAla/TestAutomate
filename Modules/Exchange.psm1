Import-Module "$PSScriptRoot\Logging.psm1"

. "$PSScriptRoot\Exchange\DistributionGroups.ps1"
. "$PSScriptRoot\Exchange\MailEnabledSecurityGroups.ps1"
. "$PSScriptRoot\Exchange\SharedMailboxes.ps1"

function Connect-ExchangeService {
    [CmdletBinding()]
    param()
    
    try {
        Write-OperationalLog `
            -Category "Exchange Connection" `
            -Message "Connecting to Exchange Online..."


        Connect-ExchangeOnline `
            -ShowBanner:$false

        Write-OperationalLog `
            -Category "Exchange Connection" `
            -Message "Connected to Exchange Online."
        }
    catch {
        Write-OperationalLog `
            -Category "Exchange Authentication Error" `
            -Message $_.Exception.Message

            throw
    }
}

function Get-ExchangeContextInfo {
    [CmdletBinding()]
    param()

    Get-ConnectionInformation
}

function Test-ExchangeConnection {
    [CmdletBinding()]
    param()

    try {
        Get-AcceptedDomain `
            -ErrorActio Stop | Out-Null

        return $true
    }
    catch {
        Write-OperationalLog `
            -Category "Exchange Session Unreachable" `
            -Message $_.Exception.Message

        return $false
    }
}

Export-ModuleMember -Function *
