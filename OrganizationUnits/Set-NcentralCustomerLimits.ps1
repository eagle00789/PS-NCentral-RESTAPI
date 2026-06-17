function Set-NcentralCustomerLimits {
<#
.SYNOPSIS
Update customer limits for a specific organization unit

.DESCRIPTION
This function updates the customer limits for a specified organization unit

.PARAMETER OrganizationUnitID
Required. The organization unit id.

.PARAMETER Body
Required. The request body matching the ModifyCustomerLimitRequest array in the API Explorer.

.EXAMPLE
Set-NcentralCustomerLimits -OrganizationUnitID 50 -Body @(@{ type = "DEVICE"; limit = 100 })

This example updates the customer limits for organization unit 50

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int]$OrganizationUnitID,

        [Parameter(Mandatory = $true)]
        [object[]]$Body
    )

    $uri = "$script:BaseUrl/api/org-units/$OrganizationUnitID/limits"
    return Invoke-NcentralApi -Uri $uri -Method "PATCH" -Body $Body
}
