function Get-NcentralDeviceCustomProperty {
<#
.SYNOPSIS
Get a device custom property

.DESCRIPTION
This function gets a single device custom property for a given device and property id

.PARAMETER DeviceID
Required. The device id.

.PARAMETER PropertyID
Required. The property id.

.EXAMPLE
Get-NcentralDeviceCustomProperty -DeviceID 12345 -PropertyID 678

This example fetches the custom property with id 678 for device 12345

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int]$DeviceID,

        [Parameter(Mandatory = $true)]
        [int]$PropertyID
    )

    $uri = "$script:BaseUrl/api/devices/$DeviceID/custom-properties/$PropertyID"
    return Invoke-NcentralApi -Uri $uri -Method "GET"
}
