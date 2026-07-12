function Test-RequestPayload {
  [CmdletBinding()]
  param(
      [Parameter(Madatory)]
      $Request
  )
  Write-Host "Starting validation.."
  
  $ValidateResourceTypes = @(
  "Team",
  "Microsoft365Group",
  "SecurityGroup",
  "DistributionList",
  "MailEnabledSecurityGroup",
  "SharePoint"
  )

  if($Request.ResourceType -notin $ValidateResourceTypes) {
    throw "Invalid Resource Type: $(Request.ResourceType)"
    }

  if (:IsNullORWhiteSpace($Request.Name))  {
      throw "Name is Required."
      }

  if (:IsNullORWhiteSpace($Request.Owner))  {
      throw "Owner is Required."
      }

  Write-Host "Validation successful."

  return $true

}

Export-ModuleMember -Function *
  
