function Invoke-TeamProvision {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Request
    )

    try {
        Write-OperationalLog `
            -Category "Team Provisioning" `
            -Message "Starting Team provisioning for '$($Request.DisplayName)'."

        if (:IsNullOrWhiteSpace($Request.DisplayName)) {
             throw "Display Name is required"
        }

        if (Test-M365GroupExists -DisplayName $Request.DisplayName) {
             throw "An M365 Group named '$($Request.DisplayName)' already exists."
        }

        #region Create Backing Group

        $Group = New-M365Group `
            -DisplayName $Request.DisplayName `
            -Description $Request.Description

         Write-OperationalLog `
             -Category "Team Provisioning" `
             -Message "Created M365 Group '$($Group.Id)'."

            #region Owners

            foreach ($OwnerId in $Request.Owners) {
                
                Add-GroupOwnership `
                    -GroupId $Group.Id `
                    -UserId $OwnerId

                Write-OperationalLog `
                    -Category "Team Provisioning" `
                    -Message "Added Owner '$OwnerId',"

            }

            #endregion

            #region Add Members

            foreach ($MemberId in $Request.Members) {
                
                Add-GroupMembership `
                    -GroupId $Group.Id `
                    -UserId $MemberId

                Write-OperationalLog `
                    -Category "Team Provisioning" `
                    -Message "Added Member '$Member.Id' to group '$($Group.Id)'."
            
            }


            #endregion

            #region Team Creation

            $Team = New-Team `
                -GroupId $Group.Id

            Write-OperationalLog `
                -Category "Team Provisioning" `
                -Message "Created Team '$($Group.Id)'."

            #endregion

            #region Return Result

            return @{
                Success = $true
                ResourceType = "Team"

                Id = $Group.Id
                GroupId = $Group.Id
                TeamId = $Group.Id

                Team = $Team

                DisplayName= $Request.DisplayName
                Description = $Request.Description
            }

            #endregion

            #endregion
    }
    catch{

        Write-OperationalLog `
            -Category "Team Provisioning Failure" `
            -Message $_.Exception.Message

        throw
    }
}
