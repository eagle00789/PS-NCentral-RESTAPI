function Get-NcentralDeviceCustomProperties {
<#
.SYNOPSIS
Get the list of device custom properties for a device

.DESCRIPTION
This function gets the list of device custom properties for a given device

.PARAMETER DeviceID
Required. The device id.

.EXAMPLE
Get-NcentralDeviceCustomProperties -DeviceID 12345

This example fetches all custom properties for the device with id 12345

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$DeviceID
    )

    $uri = "$script:BaseUrl/api/devices/$DeviceID/custom-properties"
    return (Invoke-NcentralApi -Uri $uri -Method "GET").data
}
