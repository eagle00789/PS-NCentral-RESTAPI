function New-NcentralUserRole {
<#
.SYNOPSIS
Create a new user role for an organization unit

.DESCRIPTION
This function creates a new user role for a given organization unit

.PARAMETER OrganizationUnitID
Required. The organization unit id.

.PARAMETER Body
Required. The request body matching CreateUserRoleRequest in the API Explorer.

.EXAMPLE
New-NcentralUserRole -OrganizationUnitID 50 -Body @{ name = "Helpdesk" }

This example creates a new user role under organization unit 50

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OrganizationUnitID,

        [Parameter(Mandatory = $true)]
        [hashtable]$Body
    )

    Show-Warning

    $uri = "$script:BaseUrl/api/org-units/$OrganizationUnitID/user-roles"
    return Invoke-NcentralApi -Uri $uri -Method "POST" -Body $Body
}
