function Get-NcentralDeviceServiceMonitorStatus {
<#
.SYNOPSIS
Get the status of the service monitoring tasks for a given device based on DeviceID

.DESCRIPTION
This function gets the status of the service monitoring tasks for a given device based on DeviceID

.PARAMETER DeviceID
Required. The DeviceID.

.EXAMPLE
Get-NcentralDeviceServiceMonitorStatus -DeviceID 526898132189

This example fetches the service monitoring tasks for a device with ID 526898132189

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $True)]
        [int]$DeviceID
    )

    $uri = "$script:BaseUrl/api/devices/$DeviceID/service-monitor-status"

    return (Invoke-NcentralApi -Uri $uri -Method "GET").data
}