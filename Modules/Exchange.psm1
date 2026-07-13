# Connect to ms sign in page and create a session
Import-Module .\Modules\Logging.psm1


function Connect-ExchangeService {
  [CmdletBinding()]
  param()

  try {
      Write-Host "Connecting to Exchange Online..."
      Connect-ExchangeOnline
  
      Write-Host "Connected."
  }

  # Authentication Error
  catch {
    Write-OperationalLog  `
        -Category "Exchange - Authentication Error"  `
        -Message $_.Exception.Message

        throw
    }

}
  

# test if that session is reachable (returns true/false)
function Test-ExchangeConnection {
[CmdletBinding()]
param()

try {
  Get-AcceptedDomain -ErrorAction Stop | Out-Null 
  return $true
}
catch {
   Write-OperationalLog  `
        -Category "Exchange - Session Unreachable"  `
        -Message $_.Exception.Message
   return $false     
  }
}



# Show current session info
function Get-ExchangeContextInfo {
[CmdletBinding()]
param()

Get-ConnectionInformation   # Show info  about the current authenticated session

}


# ------------------------------------------------------   Initial group creation code (Incomplete + will be expanded tommorow)


function New-DistributionList {
[CmdletBinding()]
param([string]$Name)

Write-Host "Creating Distribution List: $Name"
}


# -----------------------------------------------------   Initial group creation code (Incomplete + will be expanded tommorow)
function New-MailEnabledSecurityGroup{
[CmdletBinding()]
param([string]$Name)
Write-Host "Creating a Mail-Enabled Group: $Name"
}


Export-ModuleMember -Function *
