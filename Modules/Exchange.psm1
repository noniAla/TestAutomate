
# Connect to ms sign in page and create a session
function Connect-ExchangeService {
  [CmdletBinding()]
  paran()
  
  Write-Host "Connecting to Exchange Online..."
  Connect-ExchangeOnline
  
  Write-Host "Connected."
}

# test if that session is reachable (returns true/false)
function Test-ExchangeConnection {
[cmdleyBinding()]
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
function GetExchangeContextInfo {
[cmdletBonding()]
param
Write-Host "Exchange Online session Active."
}


# Initial group creation code (Incomplete + will be expanded tommorow)
function New-DistributionList {
param([string]$Name)

Write-Host "Creating Distribution List: $Name"
}


# Initial group creation code (Incomplete + will be expanded tommorow)
function new-MailEnabledSecurityGroup{
param([string]$Name)
Write-Host "Creating a Mail-Enabled Group: $Name"
}


Export-ModuleMember -Function *

