function Get-NcentralOrganizationUnit {
<#
.SYNOPSIS
Get a single organization unit based on OrganizationUnitID

.DESCRIPTION
This function gets a single organization unit based on OrganizationUnitID

.PARAMETER OrganizationUnitID
Required.

.EXAMPLE
Get-NcentralOrganizationUnit -OrganizationUnitID 50

This example fetches a single organization unit by id 50

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int]$OrganizationUnitID
    )

    $uri = "$script:BaseUrl/api/org-units/$OrganizationUnitID"
    return Invoke-NcentralApi -Uri $uri -Method "GET"
}
