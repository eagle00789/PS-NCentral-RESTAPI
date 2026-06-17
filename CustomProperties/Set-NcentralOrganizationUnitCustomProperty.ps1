function Set-NcentralOrganizationUnitCustomProperty {
<#
.SYNOPSIS
Modify an organization unit custom property

.DESCRIPTION
This function modifies a single organization unit custom property for a given organization unit and property id

.PARAMETER OrganizationUnitID
Required. The organization unit id.

.PARAMETER PropertyID
Required. The property id.

.PARAMETER Body
Required. The request body matching OrgUnitCustomPropertyModification in the API Explorer.

.EXAMPLE
Set-NcentralOrganizationUnitCustomProperty -OrganizationUnitID 50 -PropertyID 678 -Body @{ value = "New Value" }

This example modifies the custom property with id 678 for organization unit 50

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int]$OrganizationUnitID,

        [Parameter(Mandatory = $true)]
        [int]$PropertyID,

        [Parameter(Mandatory = $true)]
        [hashtable]$Body
    )

    $uri = "$script:BaseUrl/api/org-units/$OrganizationUnitID/custom-properties/$PropertyID"
    return Invoke-NcentralApi -Uri $uri -Method "PUT" -Body $Body
}
