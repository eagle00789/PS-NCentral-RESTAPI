function New-NcentralDeviceAccessGroup {
<#
.SYNOPSIS
Create a new device access group

.DESCRIPTION
This function creates a new device type access group with the specified details

.PARAMETER OrganizationUnitID
Required. The organization unit for which the device access group should be created.

.PARAMETER Body
Required. The request body matching DeviceAccessGroupCreateRequest in the API Explorer.

.EXAMPLE
New-NcentralDeviceAccessGroup -OrganizationUnitID 50 -Body @{ name = "New Device Group" }

This example creates a new device access group under organization unit id 50

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OrganizationUnitID,

        [Parameter(Mandatory = $true)]
        [hashtable]$Body
    )

    $uri = "$script:BaseUrl/api/org-units/$OrganizationUnitID/device-access-groups"
    return Invoke-NcentralApi -Uri $uri -Method "POST" -Body $Body
}
