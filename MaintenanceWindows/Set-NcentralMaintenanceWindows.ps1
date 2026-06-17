function Set-NcentralMaintenanceWindows {
<#
.SYNOPSIS
Modify device maintenance windows by schedule id

.DESCRIPTION
This function modifies existing device maintenance windows by schedule id

.PARAMETER Body
Required. The request body matching MaintenanceWindowsPutRequest in the API Explorer.

.EXAMPLE
Set-NcentralMaintenanceWindows -Body @{ scheduleIds = @(1); maintenanceWindows = @() }

This example modifies existing maintenance windows

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [hashtable]$Body
    )

    $uri = "$script:BaseUrl/api/devices/maintenance-windows"
    return Invoke-NcentralApi -Uri $uri -Method "PUT" -Body $Body
}
