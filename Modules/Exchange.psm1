
# Connect to ms sign in page and create a session
function Connect-ExchangeService {
  [CmdletBinding()]
  param()
  
  Write-Host "Connecting to Exchange Online..."
  Connect-ExchangeOnline
  
  Write-Host "Connected."
}

# test if that session is reachable (returns true/false)
function Test-ExchangeConnection {
[cmdletBinding()]
param()

try {
  Get-AcceptedDomain -ErrorAction Stop | Out-Null 
  return $true
}
catch {
  return $false
  }
}

# Just to output if the session is active
function Get-ExchangeContextInfo {
[cmdletBinding()]
param([string]$Name)
Write-Host "Exchange Online session Active."
}


# Initial group creation code (Incomplete + will be expanded tommorow)
function New-DistributionList {
param([string]$Name)

Write-Host "Creating Distribution List: $Name"
}


# Initial group creation code (Incomplete + will be expanded tommorow)
function New-MailEnabledSecurityGroup{
param([string]$Name)
Write-Host "Creating a Mail-Enabled Group: $Name"
}


Export-ModuleMember -Function *

