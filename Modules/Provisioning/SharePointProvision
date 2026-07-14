function Invoke-SharePointProvision{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Request
    )

    try {
        Write-OperationalLog `
            -Category "SharePoint Provisioning"
            -Message "Starting SharePoint provisioning for '$($Request.Title)'."

        #region Validation

        if (:IsNullOrWhiteSpace($Request.Title)) {
            throw "Title is required."
        }

        if(:IsNullOrWhiteSpace($Request.SiteAlias)) {
            throw "SiteAlias is required"
        }

        if(:IsNullOrWhiteSpace($Request.OwnerEmail)) {
            throw "OwnerEmail is Required"
        }

        #endregion

        $SiteUrl = "https://bapcotest.sharepoint.com/sites/$($Request.SiteAlias)"
        

        #region Provision SharePoint 

        if (Test-SharePointSiteExists -SiteUrl $SiteUrl) {
            throw "SharePoint site '$SiteUrl' already exists"
        }

        $Operation = New-SharePoint `
            -Title $Request.Title `
            -SiteAlias $Request.SiteAlias `
            -OwnerUPN $Request.OwnerEmail `
            -Description $Request.Description `
            -Template $Request.Template

        Write-OperationalLog `
            -Category "SharePoint Provisioning" `
            -Message "Submitted Sharepoint site creation request for '$SiteUrl'."

        return @{
            Success = $true
            ResourceType = "SharePoint"

            SiteUrl = $SiteUrl
            Title = $Request.Title
            SiteAlias = $Request.SiteAlias

            Operation = $Operation
        }

        #endregion
    }
    catch {
        Write-OperationalLog `
            -Category "SharePoint Provisioning Failure" `
            -Message $_.Exception.Message

            throw
    }


}
