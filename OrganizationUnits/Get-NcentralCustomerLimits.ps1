function Get-NcentralCustomerLimits {
<#
.SYNOPSIS
Get customer limits for a specific organization unit

.DESCRIPTION
This function gets the customer limits for a specified organization unit

.PARAMETER OrganizationUnitID
Required. The organization unit id.

.EXAMPLE
Get-NcentralCustomerLimits -OrganizationUnitID 50

This example fetches the customer limits for organization unit 50

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int]$OrganizationUnitID
    )

    $uri = "$script:BaseUrl/api/org-units/$OrganizationUnitID/limits"
    return Invoke-NcentralApi -Uri $uri -Method "GET"
}
