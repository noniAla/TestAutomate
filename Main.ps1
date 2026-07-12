Import-Module .\Modules\Graph.psm1
Import-Module .\Modules\Validation.psm1
Import-Module .\Modules\Exchange.psm1

Write-Host "Main.ps1 started"

$request = @{
    RequestType = "Microsoft365Group"
    Name= "HR Group"
    Description= "This group's purpose is to....."
    Ownermail = "owner@company.com"
    Members = @(
    "user1@company.com",
    "user2@company.com",
    "user3@company.com"
    )
    GroupType= "Microsoft365Group"
}

if (Test-RequestPayload -Request $request)
{
    Write-Host "Validation Passed."
}


Connect-ExchangeService

if(Test-ExchangeConnection)
{
    Write-Host "Exchange Test Passed!"
 }

else
{
    Write-Host "Exchange Test Failure..."
}


Connect-GraphService

Get-GraphContextInfo

if (Test-GraphConnection) {
    Write-Host "Graph test passed"
}
else {
    Write-Host "Graph test failed"
}
