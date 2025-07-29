function Get-NcentralDeviceActivationKey {
<#
.SYNOPSIS
Get a single N-Central Activation Key for the device specified

.DESCRIPTION
This function gets a N-Central Activation Key for the device specified by DeviceID.

.PARAMETER DeviceID
Required. The Device ID.

.EXAMPLE
Get-NcentralDevice -DeviceID 5984758458

This example fetches the device that match with device ID 5984758458

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int]$DeviceID
    )

    $uri = "$script:BaseUrl/api/devices/$DeviceID/activation-key"
    return (Invoke-NcentralApi -Uri $uri -Method "GET").data

}