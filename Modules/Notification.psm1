function Send-Notification {
    [CmdletBinding()]
    param(
        [string]$Reciepent,
        [string]$Subject,
        [string]$Message
        )

         Write-Host " "            
         Write-Host "============== Notification =============="
         Write-Host "To: $Recipent"
         Write-Host "Subject: $Subject"
         Write-Host "Message: $Message"
         Write-Host "=========================================="
         Write-Host " "

Export-ModuleMember -Function*
}
