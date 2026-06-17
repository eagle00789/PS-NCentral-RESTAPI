function Get-NcentralDeviceNotes {
<#
.SYNOPSIS
Get notes for a device

.DESCRIPTION
This function gets a paginated list of notes for a device

.PARAMETER DeviceID
Required. The device id.

.PARAMETER PageNumber
Optional. Specifies which page of results to retrieve. Defaults to 1.

.PARAMETER PageSize
Optional. Specifies the number of notes to retrieve per page. Defaults to 50.

.EXAMPLE
Get-NcentralDeviceNotes -DeviceID 12345

This example fetches notes for device 12345

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$DeviceID,

        [Parameter(Mandatory = $false)]
        [int]$PageNumber = 1,

        [Parameter(Mandatory = $false)]
        [int]$PageSize = 50
    )

    $uri = "$script:BaseUrl/api/devices/$DeviceID/notes?pageNumber=$PageNumber&pageSize=$PageSize"
    return (Invoke-NcentralApi -Uri $uri -Method "GET").data
}
