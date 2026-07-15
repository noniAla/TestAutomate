function Invoke-MailEnabledSecurityGroupProvision {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Request

        try {
            Write-OperationalLog `
                -Category "Mail Enabled Security Group Provisioning" `
                -Message "Starting Mail Enabled Security Group Provisioning for '$($Request.DisplayName)'."


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
