Import-Module .\Modules\Graph.psm1
Import-Module .\Modules\Validation.psm1
Import-Module .\Modules\Exchange.psm1
Import-Module .\Modules\Notification.psm1
Import-Module .\Modules\Logging.psm1

Write-Host "Main.ps1 started"


# Dummy Request
$request = @{
    RequestType = "Group"
    Name= "HR Group"
    Description= "This group's purpose is to....."
    Ownermail = "owner@company.com"
    Members = @(
    "user1@company.com"
    "user2@company.com"
    "user3@company.com"
    )
    GroupType= "Microsoft365Group"
}

try {

    # Audit Log
    Write-AuditLog  `
        -RequestId "REQ-001"  `
        -Event "Request Submitted"


    # Validation Test Section
    if (Test-RequestPayload -Request $request)
      {
            Write-OperationalLog  `
                -Category "Validation"   `
                -Message "Request Validation Passed"

            Write-AuditLog `
                -RequestId "REQ-001" `
                -Event "Request Approved"
      }

      else{
        
        Write-AuditLog `
                -RequestId "REQ-001" `
                -Event "Request Rejected"

      }


    # Exchange Test Section
    Connect-ExchangeService

    Get-ExchangeContextInfo

    if(Test-ExchangeConnection)
    {
            Write-OperationalLog  `
                -Category "Exchange"  `
                -Message "Exchange connection successful"
     }


    # Graph Test Section 
    Connect-GraphService

    Get-GraphContextInfo

    if (Test-GraphConnection) {

         Write-OperationalLog  `
                -Category "Graph"   `
                -Message "Graph connection successful"
    }



    # Assume start provisioning here
    Write-AuditLog  `
        -RequestId "REQ-001"  `
        -Event "Provisioning Started"


    Send-Notification  `
        -Recipent $request.Ownermail  `
        -Subject   "Test Connection success"  `
        -Message   "Current Connections to Graph, Exchange are working."


}


# Testing Purposes
catch {

    Write-OperationalLog  `
        -Category "Exception"  `
        -Message $_.Exception.Message

    Write-AuditLog  `
        -RequestId "REQ-001"  `
        -Event     "Provisioning Failed" #For later

    Send-Notification  `
        -Recipent $request.Ownermail  `
        -Subject   "Provisioning Failed"  #For later  `
        -Message   $_.Exception.Message

}
