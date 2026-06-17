function Get-NcentralDeviceCustomPropertyDefault {
<#
.SYNOPSIS
Get a device default custom property by organization unit and property id

.DESCRIPTION
This function gets a device default custom property for a given organization unit and property id

.PARAMETER OrganizationUnitID
Required. The organization unit id.

.PARAMETER PropertyID
Required. The property id.

.EXAMPLE
Get-NcentralDeviceCustomPropertyDefault -OrganizationUnitID 50 -PropertyID 678

This example fetches the default device custom property with id 678 for organization unit 50

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OrganizationUnitID,

        [Parameter(Mandatory = $true)]
        [string]$PropertyID
    )

    $uri = "$script:BaseUrl/api/org-units/$OrganizationUnitID/custom-properties/device-custom-property-defaults/$PropertyID"
    return Invoke-NcentralApi -Uri $uri -Method "GET"
}
