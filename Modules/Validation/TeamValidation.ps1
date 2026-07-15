function Validate-TeamRequest {

     [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Request
        )

          
     # Naming Convention
     if($Request.DisplayName -notmatch '^TEAM-')
     {
        throw "Team names must start with 'TEAM-'."
     }

     # Possible more specific validations for teams in the future

}
