function Get-NcentralMaintenanceWindows {
<#
.SYNOPSIS
Get a list of all maintenance windows for a specified DeviceID

.DESCRIPTION
This function gets a list of all maintenance windows for a specified DeviceID

.PARAMETER DeviceID
Required. The DeviceID.

.EXAMPLE
Get-NcentralMaintenanceWindows -DeviceID 12345679

This example fetches all maintenance windows for the device with ID 13245679

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int]$DeviceID
    )

    Show-Warning

    $uri = "$script:BaseUrl/api/devices/$DeviceID/maintenance-windows"

    return (Invoke-NcentralApi -Uri $uri -Method "GET").data
}