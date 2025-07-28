function Get-NcentralDeviceTasks {
<#
.SYNOPSIS
Get the list of device associated tasks

.DESCRIPTION
This function gets the list of device associated tasks based on a deviceID

.PARAMETER DeviceID
Required. The DeviceID.

.EXAMPLE
Get-NcentralDeviceTasks -DeviceID 1954813854

This example fetches all tasks associated with a device with ID 1954813854

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $True)]
        [int]$DeviceID
    )

    $uri = "$script:BaseUrl/api/devices/$DeviceID/scheduled-tasks"

    return (Invoke-NcentralApi -Uri $uri -Method "GET").data
}