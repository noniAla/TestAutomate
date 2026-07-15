. "$PSScriptRoot\..\Exchange\MailEnabledSecurityGroups.ps1"

function Validate-MailEnabledSecurityGroupRequest {
   
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



     #Validate SMTP Format:
     if ($Request.PrimarySmtp -notmatch  '^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$')
     {
        throw "Primary SMTP address is invalid."
     }


     # Duplicated Group
     if (Test-MailEnabledSecurityGroupExists `
            -DisplayName $Request.DisplayName)
        {
            throw "A Mail-Enabled Security Group named '$($Request.DisplayName)' already exists."
        }

     
     # Naming Convention
     if ($Request.DisplayName -notmatch '^MES-')
     {
        throw "Mail Enabled Security Group names must start with 'MES-'."
     } 


}
