function Get-NcentralOrganizationUnitCustomProperty {
<#
.SYNOPSIS
Get an organization unit custom property

.DESCRIPTION
This function gets a single organization unit custom property for a given organization unit and property id

.PARAMETER OrganizationUnitID
Required. The organization unit id.

.PARAMETER PropertyID
Required. The property id.

.EXAMPLE
Get-NcentralOrganizationUnitCustomProperty -OrganizationUnitID 50 -PropertyID 678

This example fetches the custom property with id 678 for organization unit 50

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int]$OrganizationUnitID,

        [Parameter(Mandatory = $true)]
        [int]$PropertyID
    )

    $uri = "$script:BaseUrl/api/org-units/$OrganizationUnitID/custom-properties/$PropertyID"
    return Invoke-NcentralApi -Uri $uri -Method "GET"
}
