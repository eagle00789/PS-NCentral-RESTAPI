function New-NcentralServiceOrganization {
<#
.SYNOPSIS
Create a new service organization

.DESCRIPTION
This function creates a new service organization with the specified details

.PARAMETER Body
Required. The request body matching ServiceOrganizationCreation in the API Explorer.

.EXAMPLE
New-NcentralServiceOrganization -Body @{ soName = "Managed Services" }

This example creates a new service organization

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [hashtable]$Body
    )

    $uri = "$script:BaseUrl/api/service-orgs"
    return Invoke-NcentralApi -Uri $uri -Method "POST" -Body $Body
}
