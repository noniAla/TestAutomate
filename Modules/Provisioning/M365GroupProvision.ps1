Import-Module "$PSScriptRoot\..\Graph\Groups.ps1"
Import-Module "$PSScriptRoot\..\Graph\Users.ps1"

Import-Module "$PSScriptRoot\..\Validation\GroupValidation.ps1"

Import-Module "$PSScriptRoot\..\Modules\Logging.psm1"
Import-Module "$PSScriptRoot\..\Modules\Notification.psm1"


function Invoke-M365GroupProvision {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Request
        )

        try  {
            # Optional, could be used in the main Azure function
            Write-AuditLog  `
                -RequestId "REQ-001"  `
                -Event "Provisioning Started"
            
            
            Write-OperationalLog  `
                -Category "M365 Group Provisioning"   `
                -Message "Starting M365 Group Provisioning for '$($Request.DisplayName)'."


            # Validate request 
            Validate-M365GroupRequest `
                -Request $Request

            if (Test-M365GroupExists -DisplayName $Request.DisplayName){
                throw "An M365 Group named  '$($Request.DisplayName)' already exists."
            
            }
           

           #Resolve Owner (Temp)
            $OwnerIds = foreach($OwnerEmail in $Request.Owners) {
                           Get-UserIdByEmail `
                            -EmailAddress $OwnerEmail
                        }
            
            
           #Resolve members
           $MemberIds = foreach($MemberEmail in $Request.Members) {
                           Get-UserIdByEmail `
                            -EmailAddress $MemberEmail
                        }


            #Create Group
            $Group = New-M365Group `
                -DisplayName $Request.DisplayName `
                -Description $Request.Description

            Write-OperationalLog  `
                -Category "M365 Group Provisioning"   `
                -Message "'$($Request.DisplayName)'Group Created"

            $GroupId = $Group.Id


            Start-Sleep -Seconds 15
            

            #Add Owner(s)
            foreach($OwnerId in $OwnerIds)
            {
                Add-GroupOwnership `
                    -GroupId $GroupId `
                    -UserId $OwnerId

                Write-OperationalLog  `
                    -Category "M365 Group Provisioning"   `
                    -Message "Added Owner '$OwnerId'."

            }
    


            # Add Members 
            foreach($MemberId in $MemberIds)
            {
                Add-GroupMembership `
                    -GroupId $GroupId `
                    -UserId $MemberId

                Write-OperationalLog  `
                    -Category "M365 Group Provisioning"   `
                    -Message "Added Member '$MemberId'."
            }



            Write-AuditLog  `
                -RequestId "REQ-001"  `
                -Event "Provisioning Completed"

            # Send Notification to all owners
            foreach($OwnerEmail in $Request.Owners) {
            Send-Notification `
                -Recipient $Request.OwnerEmail `
                -Subject "Group Created" `
                -Message "microsoft 365 Group created successfully"

            }


            return @{

                Success = $true
                ResourceType = "Microsoft365Group"

                Id= $Group.Id
                GroupId= $GroupId


                Group = $Group

                DisplayName = $Request.DisplayName
                Description = $Request.Description

            }


    }
    catch {
        
            Write-OperationalLog  `
                    -Category "M365 Group Provisioning Failure"   `
                    -Message $_.Exception.Message

            throw
    
    }
}
