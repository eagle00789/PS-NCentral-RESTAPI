function Get-NcentralDeviceAssetsLifecycleInfo {
<#
.SYNOPSIS
Retrieve a device asset lifecycle information by Device ID.

.DESCRIPTION
This function retrieves a device asset lifecycle information by Device ID.

.PARAMETER DeviceID
Required. The Device ID.

.EXAMPLE
Get-NcentralDeviceAssetsLifecycleInfo -DeviceID 5984758458

This example fetches the device asset lifecycle information that matches with device ID 5984758458

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [long]$DeviceID
    )

    $uri = "$script:BaseUrl/api/devices/$DeviceID/assets/lifecycle-info"
    return Invoke-NcentralApi -Uri $uri -Method "GET"

}