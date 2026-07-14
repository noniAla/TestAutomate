function Invoke-M365GroupProvision {

    [CmdletBinding()]
    param(
        [hashtable]$Request
        )

    # Optional, could be used in the main Azure function
    Write-AuditLog  `
        -RequestId "REQ-001"  `
        -Event "PRovisioning Started"

    # Validate request 
    Validate-M365GroupRequest `
        -Request $Request

    #Create Group
    $GroupId = New-M365Group `
        -DisplayName $Request.Name `
        -Description $Request.Description
    
    #Resolve Owner (Tempt)
    $OwnerId = Get-UserIdsByMail `
        -Mails $Request.OwnerMail

    #Add Owner
    foreach($OwnerId in $OwnerIds)
    {
        Add-GroupOwnership `
            -GroupId $GroupId
            -OwnerId $OwnerId
    }
    

    #Resolve members
    $MemeberIds = Get-UserIdsByMail `
        -Mails $Request.Members


    # Add Members 
    foreach($MemberId in $MemberIds)
    {
        Add-GroupMembers `
            -RequestId "REQ-001"`
            -Event "Provisioning Completed"
    }

    Write-AuditLog  `
        -RequestId "REQ-001"  `
        -Event "Provisioning Completed"

    # Send Notification to all owners
    foreach($OwnerId in $OwnerIds) {
    Send-Notification `
        -Recipient $Request.OwnerMail `
        -Subject "Group Created" `
        -Message "microsoft 365 Group created successfully"

    }

    return $GroupId
}
            


  
