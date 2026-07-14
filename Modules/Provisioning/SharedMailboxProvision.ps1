function Invoke-SharedMailboxProvision {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Request
    )

    try {
        Write-OperationalLog `
            -Category "Shared Mailbox Provisioning" `
            -Message "Starting Shared Mailbox Provisioning for '$($Request.DisplayName)'."

        if (:IsNullOrWhiteSpace($Request.DisplayName)) {
            throw "Display Name is required."
        }

        if (:IsNullOrWhiteSpace($Request.Alias)) {
            throw "Alias is required."
        }

        if (Test-SharedMailboxExists -Identity $Request.Alias)) {
            throw "A shared mailbox with alias '$($Request.Alias)' already exists."
        }

        $Mailbox = New-SharedMailbox `
            -DisplayName $Request.DisplayName `
            -Alias $Request.Alias `
            -PrimarySmtpAddress $Request.PrimarySmtpAddress

        Write-OperationalLog `
            -Category "Shared Mailbox Provisioning" `
            -Message "Created Shared Mailbox '$($Request.DisplayName)'."



        foreach ($User in $Request.FullAccessUsers) {
            Add-SharedMailboxFullAccess `
                -Identity $Request.Alias `
                -User $User

            Write-OperationalLog `
                -Category "Shared Mailbox Provisioning" `
                -Message "Granted Full Access permission to '$User'."
        }


        foreach ($User in $Request.SendAsUsers) {
            Add-SharedMailboxSendAs `
                -Identity $Request.Alias `
                -User $User

            Write-OperationalLog `
                -Category "Shared Mailbox Provisioning" `
                -Message "Granted Send As permission to '$User'."
        }
    }
    catch {

    }
}
