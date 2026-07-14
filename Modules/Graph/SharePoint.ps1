#region sites

function Get-SharePointSite {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$SiteUrl
    )

    $ParsedUrl = [Url]$SiteUrl
    $ServerRelativePath = $ParsedUrl.AbsolutePath.TrimEnd('/')

    $RequestUri = "https://graph.microsoft.com/beta/sites/$($ParsedUrl.Host):$ServerRelativePath"

    $Site = Invoke-MgGraphRequest `
        -Method GET `
        -Uri $RequestUri `
        -SkipHttpErrorCheck `
        -StatusCodeVariable StatusCode

    if ($StatusCode -eq 404) {
        return $null
    }

    if ($StatusCode -ge 400) {
        throw "Failed to retrieve SharePoint site '$SiteUrl'. Graph returned HTTP $StatusCode."
    }
    return $Site
}

function Test-SharePointSiteExists {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$SiteUrl
    )

    return ($null -ne (Get-SharePointSite -SiteUrl $SiteUrl))
}

function New-SharePoint {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Title,

        [Parameter(Mandatory)]
        [string]$SiteAlias,

        [Parameter(Mandatory)]
        [string]$OwnerUPN,

        [string]$Description,

        [ValidateSet("sts","sitepagepublishing")]
        [string]$Template = "sts"
    )

    $Body = @{
        name = $Title
        description = $Description
        webUrl = "https://bapcotest.sharepoint.com/sites/$SiteAlias"
        locale = "en-US"
        shareByEmailEnabled = $true
        template = $Template

        ownerIdentityToResolve = @{
            email = $OwnerUPN
        }
    }

    Invoke-MgGraphRequest `
        -Method POST `
        -Uri "https://graph.microsoft.com/beta/sites" `
        -ContentType 'application/json'
        -Body ($Body | ConvertTo-Json -Depth 10)
