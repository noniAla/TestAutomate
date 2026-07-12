Import-Module .\Modules\Graph.psm1

Write-Host "Main.ps1 started"

Connect-GraphService

Get-GraphContextInfo

if (Test-GraphConnection) {
    Write-Host "Graph test passed"
}
else {
    Write-Host "Graph test failed"
}
