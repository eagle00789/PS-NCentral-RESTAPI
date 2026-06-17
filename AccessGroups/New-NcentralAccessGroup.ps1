function New-NcentralAccessGroup {
<#
.SYNOPSIS
Create a new organization unit access group

.DESCRIPTION
This function creates a new organization unit type access group with the specified details

.PARAMETER OrganizationUnitID
Required. The organization unit for which the access group should be created.

.PARAMETER Body
Required. The request body matching OrgUnitTypeAccessGroupCreateRequest in the API Explorer.

.EXAMPLE
New-NcentralAccessGroup -OrganizationUnitID 50 -Body @{ name = "New Group" }

This example creates a new organization unit access group under organization unit id 50

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OrganizationUnitID,

        [Parameter(Mandatory = $true)]
        [hashtable]$Body
    )

    $uri = "$script:BaseUrl/api/org-units/$OrganizationUnitID/access-groups"
    return Invoke-NcentralApi -Uri $uri -Method "POST" -Body $Body
}
