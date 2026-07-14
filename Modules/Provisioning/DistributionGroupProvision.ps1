Import-Module "$PSScriptRoot\..\Exchange\DistributionGroups.ps1"

Import-Module "$PSScriptRoot\..\Validation\DistributionGroupValidation.ps1"

Import-Module "$PSScriptRoot\..\Modules\Logging.psm1"
Import-Module "$PSScriptRoot\..\Modules\Notification.psm1"


function Invoke-DistributionGroupProvision {

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
                -Category "Distribution Group Provisioning"   `
                -Message "Starting Distribution Group Provisioning for '$($Request.DisplayName)'."


            # Validate request 
            Validate-DistributionGroupRequest `
                -Request $Request

            if (Test-DistributionGroupExists -DisplayName $Request.DisplayName){
                throw "An Distribution Group named  '$($Request.DisplayName)' already exists."
            
            }
           

            #Create Group
            $Group = New-DistributionGroup `
                -DisplayName $Request.DisplayName `
                -Alias $Request.Alias `
                -PrimarySmtAddress $Request.PrimarySmtpAddress


            Write-OperationalLog  `
                -Category "Distribution Group Provisioning"   `
                -Message "'$($Request.DisplayName)'Group Created"


            Start-Sleep -Seconds 15
    

            # Add Members 
            foreach($Member in $Request.Members)
            {
                Add-DistributionGroupMembership `
                    -Identity $Request.DisplayName `
                    -Member $Member

                Write-OperationalLog  `
                    -Category "Distribution Group Provisioning"   `
                    -Message "Added Member '$Member'."
            }



            Write-AuditLog  `
                -RequestId "REQ-001"  `
                -Event "Provisioning Completed"


            # Send Notification to all Members

            foreach($Member in $Request.Members) {
            Send-Notification `
                -Recipient $Member `
                -Subject "Group Created" `
                -Message "Distribution Group '$($Request.DisplayName)' created"

            }


            return @{

                Success = $true
                ResourceType = "DistributionGroup"
                Alias = $Request.Alias

                DisplayName = $Request.DisplayName
                PrimarySmtAddress= $Request.PrimarySmtpAddress
                Group = $Group

            }


    }
    catch {
        
            Write-OperationalLog  `
                    -Category "Distribution Group Provisioning Failure"   `
                    -Message $_.Exception.Message

            throw
    
    }
}
            


  
