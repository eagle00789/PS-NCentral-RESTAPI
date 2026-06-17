function New-NcentralDeviceNote {
<#
.SYNOPSIS
Add a note to a device

.DESCRIPTION
This function adds a note to a specified device

.PARAMETER DeviceID
Required. The device id.

.PARAMETER Body
Required. The request body matching AddNoteRequest in the API Explorer.

.EXAMPLE
New-NcentralDeviceNote -DeviceID 12345 -Body @{ note = "Investigated issue" }

This example adds a note to device 12345

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$DeviceID,

        [Parameter(Mandatory = $true)]
        [hashtable]$Body
    )

    $uri = "$script:BaseUrl/api/devices/$DeviceID/notes"
    return Invoke-NcentralApi -Uri $uri -Method "POST" -Body $Body
}
