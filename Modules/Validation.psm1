function Test-RequestPayload {
  [CmdletBinding()]
  param(
      [Parameter(Mandatory)]
      $Request
  )
  Write-Host "Starting validation.."

  $AllowedFields = @(
    "RequestType",
    "Name",
    "Description",
    "Ownermail",
    "Members",
    "GroupType"
  )

# I didnt add the "GroupType" because it is not required(optional), But it is allowed when the user chooses to input it so it is in the "AllowedField"
  $RequiredFields = @(
  "RequestType",
  "Name",
  "Description",
  "Ownermail",
  "Members"
  )

# Check for unexpected fields
  foreach ($Property in $Request.PSObject.Properties){
    if ( $Property.Name -notin $AllowedFields){
      throw "Unexpected field detected: $($Property.Name)"
      }
  }

# Check for missing fields
  foreach ($Field in $RequiredFields)
  {
    If (-not $Request.PSObject.Properties.Name.Contains($Field))
    {
      throw "Missing Field ($Field) Required"
      }
    }
 
  
  $ValidateRequestTypes = @(
  "Team",
  "Group",
  "SharePoint"
  )

  if($Request.RequestType -notin $ValidateResourceTypes) {
    throw "Invalid Resource Type: $($Request.ResourceType)"
    }
    

  $ValidGroupTypes = @(
    "Microsoft365Group",
    "SecurityGroup",
    "DistributionList",
    "MailEnabledSecurityGroup",
    "DynamicDistributionList"
    )
    
  # Validate Group type this time
  if ($null -ne $Request.GroupType)
  {
    If ($Request.GroupType -notin $ValidGroupTypes)
    {
      throw "Invalid Group Type: $($Request.GroupType)"
    }
  }
    

  if (:IsNullOrWhiteSpace($Request.Name))  {
      throw "Name is Required."
      }
  
  if (:IsNullOrWhiteSpace($Request.Description))  {
      throw "Description is Required."
      }    

  if (:IsNullOrWhiteSpace($Request.Ownermail))  {
      throw "Owner is Required."
      }



  $EmailPattern = '^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$'
  
  if ($Request.Ownermail -notmatch $EmailPattern)
  {
    throw "Owner email in invalid."
  }

  if ($null -eq $Request.Members)
  {
    Throw "Members field is missing."
  }

  foreach ($Member in $Request.Members)
  {
    if ($Member -notmatch $EmailPattern)
    {
      throw "Invalid Member email: $Member"
    }
  }
 
  
  Write-Host "Validation successful."

  return $true

}

Export-ModuleMember -Function *
  
