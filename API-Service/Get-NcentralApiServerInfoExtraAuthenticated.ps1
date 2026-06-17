function Get-NcentralApiServerInfoExtraAuthenticated {
<#
.SYNOPSIS
Get authenticated extra N-Central server information

.DESCRIPTION
This function gets extra information about different systems in N-Central using a request body

.PARAMETER Body
Required. The request body matching VersionInfoAuthenticatedRequest in the API Explorer.

.EXAMPLE
Get-NcentralApiServerInfoExtraAuthenticated -Body @{ username = "user"; password = "pass" }

This example fetches authenticated extra server information from N-Central

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [hashtable]$Body
    )

    $uri = "$script:BaseUrl/api/server-info/extra/authenticated"
    return Invoke-NcentralApi -Uri $uri -Method "POST" -Body $Body
}
