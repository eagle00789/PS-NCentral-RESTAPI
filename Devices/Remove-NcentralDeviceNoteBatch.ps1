function Remove-NcentralDeviceNoteBatch {
<#
.SYNOPSIS
Delete multiple notes from a device

.DESCRIPTION
This function deletes multiple notes from a specified device

.PARAMETER DeviceID
Required. The device id.

.PARAMETER Body
Required. The request body matching DeleteBatchNoteRequest in the API Explorer.

.EXAMPLE
Remove-NcentralDeviceNoteBatch -DeviceID 12345 -Body @{ noteIds = @(1,2,3) }

This example deletes multiple notes from device 12345

#>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$DeviceID,

        [Parameter(Mandatory = $true)]
        [hashtable]$Body
    )

    $uri = "$script:BaseUrl/api/devices/$DeviceID/notes"
    if ($PSCmdlet.ShouldProcess($DeviceID, "Delete multiple device notes")) {
        return Invoke-NcentralApi -Uri $uri -Method "DELETE" -Body $Body
    }
}
