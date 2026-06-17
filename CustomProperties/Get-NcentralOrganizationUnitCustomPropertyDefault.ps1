function Get-NcentralOrganizationUnitCustomPropertyDefault {
<#
.SYNOPSIS
Get an organization unit custom property default

.DESCRIPTION
This function gets an organization unit custom property default for a given organization unit and property id

.PARAMETER OrganizationUnitID
Required. The organization unit id.

.PARAMETER PropertyID
Required. The property id.

.EXAMPLE
Get-NcentralOrganizationUnitCustomPropertyDefault -OrganizationUnitID 50 -PropertyID 678

This example fetches the organization unit custom property default with id 678 for organization unit 50

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int]$OrganizationUnitID,

        [Parameter(Mandatory = $true)]
        [int]$PropertyID
    )

    $uri = "$script:BaseUrl/api/org-units/$OrganizationUnitID/org-custom-property-defaults/$PropertyID"
    return Invoke-NcentralApi -Uri $uri -Method "GET"
}
