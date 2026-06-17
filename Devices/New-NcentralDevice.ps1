function New-NcentralDevice {
<#
.SYNOPSIS
Add a new device

.DESCRIPTION
This function adds a new device to N-Central

.PARAMETER Body
Required. The request body matching DeviceAddRequest in the API Explorer.

.EXAMPLE
New-NcentralDevice -Body @{ longName = "Server01" }

This example adds a new device to N-Central

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [hashtable]$Body
    )

    $uri = "$script:BaseUrl/api/device"
    return Invoke-NcentralApi -Uri $uri -Method "POST" -Body $Body
}
