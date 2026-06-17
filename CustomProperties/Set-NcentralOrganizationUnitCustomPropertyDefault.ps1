function Set-NcentralOrganizationUnitCustomPropertyDefault {
<#
.SYNOPSIS
Modify an organization unit custom property default

.DESCRIPTION
This function modifies an organization unit custom property default for a given organization unit

.PARAMETER OrganizationUnitID
Required. The organization unit id.

.PARAMETER Body
Required. The request body matching DefaultCustomPropertyModifyRequest in the API Explorer.

.EXAMPLE
Set-NcentralOrganizationUnitCustomPropertyDefault -OrganizationUnitID 50 -Body @{ propertyId = 123; defaultValue = "abc" }

This example modifies the organization unit custom property default for organization unit 50

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int]$OrganizationUnitID,

        [Parameter(Mandatory = $true)]
        [hashtable]$Body
    )

    $uri = "$script:BaseUrl/api/org-units/$OrganizationUnitID/org-custom-property-defaults"
    return Invoke-NcentralApi -Uri $uri -Method "PUT" -Body $Body
}
