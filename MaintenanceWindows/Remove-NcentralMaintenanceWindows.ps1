function Remove-NcentralMaintenanceWindows {
<#
.SYNOPSIS
Delete device maintenance windows by schedule id

.DESCRIPTION
This function deletes existing device maintenance windows by schedule id

.PARAMETER Body
Required. The request body matching MaintenanceWindowsDeleteRequest in the API Explorer.

.EXAMPLE
Remove-NcentralMaintenanceWindows -Body @{ scheduleIds = @(1,2,3) }

This example deletes existing maintenance windows

#>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [hashtable]$Body
    )

    $uri = "$script:BaseUrl/api/devices/maintenance-windows"
    if ($PSCmdlet.ShouldProcess("MaintenanceWindows", "Delete maintenance windows")) {
        return Invoke-NcentralApi -Uri $uri -Method "DELETE" -Body $Body
    }
}
