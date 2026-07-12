Import-Module .\Modules\Graph.psm1
Import-Module .\Modules\Validation.psm1

Write-Host "Main.ps1 started"

$request = @{
    ResourceType = "Microsoft365Group",
    Name= "HR Group",
    Description= "This group's purpose is to.....",
    Ownermail = "owner@company.com",
    Memebers = [
    "user1@company.com",
    "user2@company.com",
    "user3@company.com"
    ],
    GroupType= "Microsoft365Group"
}

Test-RequestPayload -Request $request

Connect-GraphService

Get-GraphContextInfo

if (Test-GraphConnection) {
    Write-Host "Graph test passed"
}
else {
    Write-Host "Graph test failed"
}
