. "$PSScriptRoot\..\Graph\Groups.ps1"

function Validate-M365GroupRequest {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Request
        )


    # If display name is empty 
    if (:IsNullOrWhiteSpace($Request.DisplayName))
    {
        throw "Display Name is required."

    }

    # If description is empty 
    if (:IsNullOrWhiteSpace($Request.Description))
    {
        throw "Display Name is required."

    }


    # If no owner is assigned
    if ($null -eq $Request.Owners -or $Request.Owners.Count -eq 0) {

        throw "At least one owner is required."
     }


     # If no memeber is assigned
     if ($null -eq $Request.Members -or $Request.Members.Count -eq 0) {

        throw "At least one member is required."
     }


     # Duplicated Group
     if (Test-M365GroupExists `
            -DisplayName $Request.DisplayName)
        {
            throw "A Microsoft 365 Group named '$($Request.DisplayName)' already exists."
        }

     
     # Naming Convention
     if($Request.DisplayName -notmatch '^M365-')
     {
        throw "Microsoft 365 Group names must start with 'M365-'."
     }



}





function Validate-SecurityGroupRequest {

        [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Request
        )


    # If display name is empty 
    if (:IsNullOrWhiteSpace($Request.DisplayName))
    {
        throw "Display Name is required."

    }

    # If description is empty 
    if (:IsNullOrWhiteSpace($Request.Description))
    {
        throw "Description is required."

    }


    # If no owner is assigned
    if ($null -eq $Request.Owners -or $Request.Owners.Count -eq 0) {

        throw "At least one owner is required."
     }


     # If no memeber is assigned
     if ($null -eq $Request.Members -or $Request.Members.Count -eq 0) {

        throw "At least one member is required."
     }


     # Duplicated Group
     if (Test-SecurityGroupExists `
            -DisplayName $Request.DisplayName)
        {
            throw "A Security Group named '$($Request.DisplayName)' already exists."
        }

     
     # Naming Convention
     if($Request.DisplayName -notmatch '^SEC-')
     {
        throw "Security Group names must start with 'SEC-'."
     }




}
