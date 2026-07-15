function Invoke-MailEnabledSecurityGroupProvision {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Request

        try {
            Write-OperationalLog `
                -Category "Mail Enabled Security Group Provisioning" `
                -Message "Starting Mail Enabled Security Group Provisioning for '$($Request.DisplayName)'."

            #region Validation

            if (:IsNullOrWhiteSpace($Request.DisplayName)) {
                throw "DisplayName is required"
            }

            if (:IsNullOrWhiteSpace($Request.Alias)) {
                throw "Alias is Required."
            }

            if (:IsNullOrWhiteSpace($Request.PrimarySmtpAddress)){
                throw "PrimarySmtpAddress is required."
            }

            if(Test-MailEnabledSecurityGroupExists -DisplayName $Request.DisplayName) {
                throw "A Mail Enabled Security Group named '$($Request.DisplayName)' already exists."
            }


            #endregion

            #region Create Group

            $Group = New-MailEnabledSecurityGroup `
                -DisplayName $Request.DisplayName `
                -Alias $Request.Alias `
                -PrimarySmtpAddress $Request.PrimarySmtpAddress

            Write-OperationalLog `
                -Category "Mail Enabled Security Group Provisioning" `
                -Message "Created Mail Enabled Security Group '$($Request.DisplayName)'"

            #endregion

            #region Members

            foreach($Member in $Request.Members) {
                
                Add-MailEnabledSecurityGroupMembership `
                    -Identity $Request.Alias `
                    -Member $Member

                Write-OperationalLog `
                    -Category "Mail Enabled Security Group Provisioning" `
                    -Message "Added Member '$Member'"
            }


            #endregion

            return @{
                Success = $true
                ResourceType = "MailEnabledSecurityGroup"

                DisplayName = $Request.DisplayName
                Alias = $Request.Alias
                PrimarySmtpAddress = $Request.PrimarySmtpAddress
                
                MemberCont = @($Request.Members).Count

                Group = $Group
            }
        }
        catch{
            Write-OperationalLog `
                -Category "Mail Enabled Security Group Provisioning Failure" `
                -Message $_.Exception.Message

            throw
        }
}
