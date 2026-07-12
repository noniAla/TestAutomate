Import-Module .\Modules\Graph.psm1
Import-Module .\Modules\Validation.psm1

Write-Host "Main.ps1 started"

$request = @{
    ResourceType = "Microsoft365Group"
    Name= "HR Group"
    Owner = "owner@company.com"
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
