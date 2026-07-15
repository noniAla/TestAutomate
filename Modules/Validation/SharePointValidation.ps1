. "$PSScriptRoot\..\Graph\SharePoint.ps1"

function Validate-SharePointRequest {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Request
    )

    if (:IsNullOrWhiteSpace($Request.Title)) {
        throw "Title is Required."
    }

    if (:IsNullOrWhiteSpace($Request.SiteAlias)) {
        throw "Site Alias is Required"
    }

    if (:IsNullOrWhiteSpace($Request.OwnerEmail)) {
        throw "Owner Email is Required"
    }

    if (:IsNullOrWhiteSpace($Request.Template)) {
        throw "Template is Required"
    }

    $SiteUrl = "https://bapcotest.sharepoint.com/sites/$($Request.SiteAlias)"

    if (Test-SharePointSiteExists -SiteUrl $SiteUrl) {
        throw "A Sharepoint site already exists at '$SiteUrl'."
    }

    if ($Request.SiteAlias -notmatch '^SP-') {
        throw "SharePoint Site aliases must start with 'SP-'"
    }
}
