function Remove-NcentralDeviceNote {
<#
.SYNOPSIS
Delete a note from a device

.DESCRIPTION
This function deletes a note from a specified device

.PARAMETER DeviceID
Required. The device id.

.PARAMETER NoteID
Required. The note id.

.EXAMPLE
Remove-NcentralDeviceNote -DeviceID 12345 -NoteID 1

This example deletes note 1 from device 12345

#>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$DeviceID,

        [Parameter(Mandatory = $true)]
        [string]$NoteID
    )

    $uri = "$script:BaseUrl/api/devices/$DeviceID/notes/$NoteID"
    if ($PSCmdlet.ShouldProcess($NoteID, "Delete device note")) {
        return Invoke-NcentralApi -Uri $uri -Method "DELETE"
    }
}
