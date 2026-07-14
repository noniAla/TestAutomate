function Get-UserIdByEmail {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$EmailAddress
    )

    $User = Get-MgUser `
        -Filter "userPrincipalName eq '$EmailAddress' or mail eq '$EmailAddress'"

    if ($null -eq $User) {
        throw "Unable to find user with email address '$EmailAddress'"
    }

    return $User.Id
}
