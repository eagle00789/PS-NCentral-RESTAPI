function Set-NcentralDeviceCustomProperty {
<#
.SYNOPSIS
Modify a device custom property

.DESCRIPTION
This function modifies a single device custom property for a given device and property id

.PARAMETER DeviceID
Required. The device id.

.PARAMETER PropertyID
Required. The property id.

.PARAMETER Body
Required. The request body matching DeviceCustomPropertyModification in the API Explorer.

.EXAMPLE
Set-NcentralDeviceCustomProperty -DeviceID 12345 -PropertyID 678 -Body @{ value = "New Value" }

This example modifies the custom property with id 678 for device 12345

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$DeviceID,

        [Parameter(Mandatory = $true)]
        [string]$PropertyID,

        [Parameter(Mandatory = $true)]
        [hashtable]$Body
    )

    $uri = "$script:BaseUrl/api/devices/$DeviceID/custom-properties/$PropertyID"
    return Invoke-NcentralApi -Uri $uri -Method "PUT" -Body $Body
}
