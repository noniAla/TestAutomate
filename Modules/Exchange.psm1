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



# Show current session info
function Get-ExchangeContextInfo {
[cmdletBinding()]
param()

Get-ConnectionInforomation   # Show info  about the current authenticated session

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
