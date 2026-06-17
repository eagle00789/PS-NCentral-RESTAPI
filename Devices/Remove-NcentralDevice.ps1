function Remove-NcentralDevice {
<#
.SYNOPSIS
Delete a device by ID

.DESCRIPTION
This function deletes a device with a specific id from N-Central

.PARAMETER DeviceID
Required. The device id.

.PARAMETER RemoveAgents
Optional. Removes the agents along with the device when set to true.

.EXAMPLE
Remove-NcentralDevice -DeviceID 12345

This example deletes the device with id 12345

#>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$DeviceID,

        [Parameter(Mandatory = $false)]
        [bool]$RemoveAgents
    )

    $uri = "$script:BaseUrl/api/devices/$DeviceID"
    if ($PSCmdlet.ShouldProcess($DeviceID, "Delete device")) {
        $query = @{}
        if ($PSBoundParameters.ContainsKey('RemoveAgents')) {
            $query.removeAgents = $RemoveAgents
        }
        return Invoke-NcentralApi -Uri $uri -Method "DELETE" -Query $query
    }
}
