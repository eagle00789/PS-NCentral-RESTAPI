function Set-NcentralDeviceAssetsLifecycleInfo {
<#
.SYNOPSIS
Replace device asset lifecycle information

.DESCRIPTION
This function replaces the asset lifecycle information for a given device

.PARAMETER DeviceID
Required. The device id.

.PARAMETER Body
Required. The request body matching AssetLifecyclePutRequest in the API Explorer.

.EXAMPLE
Set-NcentralDeviceAssetsLifecycleInfo -DeviceID 12345 -Body @{ warrantyExpirationDate = "2026-12-31" }

This example replaces the asset lifecycle information for device 12345

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$DeviceID,

        [Parameter(Mandatory = $true)]
        [hashtable]$Body
    )

    $uri = "$script:BaseUrl/api/devices/$DeviceID/assets/lifecycle-info"
    return Invoke-NcentralApi -Uri $uri -Method "PUT" -Body $Body
}
