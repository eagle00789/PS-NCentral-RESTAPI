function New-NcentralDeviceNoteBatch {
<#
.SYNOPSIS
Add the same note to multiple devices

.DESCRIPTION
This function adds the same note to multiple devices in a single operation

.PARAMETER Body
Required. The request body matching AddBatchNoteRequest in the API Explorer.

.EXAMPLE
New-NcentralDeviceNoteBatch -Body @{ note = "Maintenance"; deviceIds = @(1,2) }

This example adds the same note to multiple devices

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [hashtable]$Body
    )

    $uri = "$script:BaseUrl/api/devices/notes"
    return Invoke-NcentralApi -Uri $uri -Method "POST" -Body $Body
}
