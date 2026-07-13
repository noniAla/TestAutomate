

# This is the oprational Log

function Write-OprationalLog {
 [CmdletBinding()]
 param(
 [string]$Category,
 [string]$Message
 )

 $Timestamp = Get-Date -Formate "yyyy-MM-dd HH:mm:ss"
 Write-Host ""
 Write-Host "[$Timestamp][OPERATIONAL]"
 Write-Host "[$Category]"
 Write-Host $Message
}






# This is the Audit log

function Write-AuditLog {
    [cmdletBinding()]
    param(
        [string]$RequestId,
        [string]$Event
        )

     $Timestamp = Get-Date -Formate "yyyy-MM-dd HH:mm:ss"
     Write-Host ""
     Write-Host "[$Timestamp][AUDIT]"
     Write-Host "[$Request]"
     Write-Host $Event

}

Export-ModuleMember -Function *
