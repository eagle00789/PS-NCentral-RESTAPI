function Get-NcentralDeviceAssets {
<#
.SYNOPSIS
Get the complete asset information for a given device based on DeviceID

.DESCRIPTION
This function gets the complete asset information for a given device based on DeviceID

.PARAMETER DeviceID
Required. The DeviceID.

.EXAMPLE
Get-NcentralDeviceAssets -DeviceID 526898132189

This example fetches the complete asset information for a device with ID 526898132189

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $True)]
        [int]$DeviceID
    )

    $uri = "$script:BaseUrl/api/devices/$DeviceID/assets"

    return (Invoke-NcentralApi -Uri $uri -Method "GET").data
}