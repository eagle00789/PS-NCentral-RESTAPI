function Update-NcentralDeviceAssetsLifecycleInfo {
<#
.SYNOPSIS
Patch device asset lifecycle information

.DESCRIPTION
This function patches the asset lifecycle information for a given device

.PARAMETER DeviceID
Required. The device id.

.PARAMETER Body
Required. The request body matching AssetLifecyclePatchRequest in the API Explorer.

.EXAMPLE
Update-NcentralDeviceAssetsLifecycleInfo -DeviceID 12345 -Body @{ assetTag = "SRV-001" }

This example patches the asset lifecycle information for device 12345

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$DeviceID,

        [Parameter(Mandatory = $true)]
        [hashtable]$Body
    )

    $uri = "$script:BaseUrl/api/devices/$DeviceID/assets/lifecycle-info"
    return Invoke-NcentralApi -Uri $uri -Method "PATCH" -Body $Body
}
