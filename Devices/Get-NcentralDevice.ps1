function Get-NcentralDevice {
<#
.SYNOPSIS
Get a single N-Central Device

.DESCRIPTION
This function gets a single N-Central device.

.PARAMETER DeviceID
Required. The Organisation Unit ID.

.EXAMPLE
Get-NcentralDevice -DeviceID 5984758458

This example fetches the device that match with device ID 5984758458

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $false)]
        [int]$DeviceID
    )

    $uri = "$script:BaseUrl/api/devices/$DeviceID"
    return (Invoke-NcentralApi -Uri $uri -Method "GET").data

}