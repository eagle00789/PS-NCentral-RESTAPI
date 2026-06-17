function Get-NcentralServiceOrganization {
<#
.SYNOPSIS
Get a single service organization based on ServiceOrganizationID

.DESCRIPTION
This function gets a single service organization based on ServiceOrganizationID

.PARAMETER ServiceOrganizationID
Required.

.EXAMPLE
Get-NcentralServiceOrganization -ServiceOrganizationID 50

This example fetches a single service organization by id 50

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int]$ServiceOrganizationID
    )

    $uri = "$script:BaseUrl/api/service-orgs/$ServiceOrganizationID"
    return Invoke-NcentralApi -Uri $uri -Method "GET"
}
