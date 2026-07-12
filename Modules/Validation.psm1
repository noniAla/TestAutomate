function Test-RequestPayload {
  [CmdletBinding()]
  param(
      [Parameter(Madatory)]
      $Request
  )
  Write-Host "Starting validation.."

  $AllowedFields = @(
    "RequestType",
    "Name",
    "Description",
    "Ownermail",
    "Members",
    "GroupType",
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
      throw "Unexpected filed detected: $(PRoperty.Name)"
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
 
  
  $ValidateResourceTypes = @(
  "Team",
  "Group",
  "SharePoint"
  )

  if($Request.ResourceType -notin $ValidateResourceTypes) {
    throw "Invalid Resource Type: $(Request.ResourceType)"
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
    

  if (:IsNullORWhiteSpace($Request.Name))  {
      throw "Name is Required."
      }
  
  if (:IsNullORWhiteSpace($Request.Description))  {
      throw "Description is Required."
      }    

  $EmailPattern = '^[^@\s]+@[^@\s]+\.[^@\s]+$'
  
  if (:IsNullORWhiteSpace($Request.Owner))  {
      throw "Owner is Required."
      }

      
  if (Request.Owneremail -notmatch $EmailPattern)
  {
    throw "Owner email in invalid."
  }

  if ($null -eq $Request.Members)
  {
    Throw "Memebers field is missing."
  }

  foreach ($MEmeber in Request.MEmbers)
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
  
