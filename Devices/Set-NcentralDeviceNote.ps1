function Set-NcentralDeviceNote {
<#
.SYNOPSIS
Modify a note on a device

.DESCRIPTION
This function modifies an existing note on a specified device

.PARAMETER DeviceID
Required. The device id.

.PARAMETER NoteID
Required. The note id.

.PARAMETER Body
Required. The request body matching ModifyNoteRequest in the API Explorer.

.EXAMPLE
Set-NcentralDeviceNote -DeviceID 12345 -NoteID 1 -Body @{ note = "Updated note" }

This example modifies note 1 on device 12345

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$DeviceID,

        [Parameter(Mandatory = $true)]
        [string]$NoteID,

        [Parameter(Mandatory = $true)]
        [hashtable]$Body
    )

    $uri = "$script:BaseUrl/api/devices/$DeviceID/notes/$NoteID"
    return Invoke-NcentralApi -Uri $uri -Method "PUT" -Body $Body
}
