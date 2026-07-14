. "$PSScriptRoot\..\Exchange\DistributionGroups.ps1"

function Validate-DistributionGroupRequest {

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


    # If Alias is empty 
    if (:IsNullOrWhiteSpace($Request.Alias))
    {
        throw "Alias is required."

    }


    # If Primary Smtp Address is empty 
    if (:IsNullOrWhiteSpace($Request.PrimarySmtpAddress))
    {
        throw "Primary Smtp Address is required."

    }


     # If no memeber is assigned
     if ($null -eq $Request.Members -or $Request.Members.Count -eq 0) {

        throw "At least one member is required."
     }


     # Duplicated Group
     if (Test-DistributionGroupExists `
            -DisplayName $Request.DisplayName)
        {
            throw "A Distribution Group named '$($Request.DisplayName)' already exists."
        }

     
     # Naming Convention, DL is a standard organization abbrivation for Distribution List 
     if ($Request.DisplayName -notmatch '^DL-')
     {
        throw "Distribution Group names must start with 'DL-'."
     }


}
