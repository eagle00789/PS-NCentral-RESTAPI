function New-NcentralSite {
<#
.SYNOPSIS
Create a new site under a customer

.DESCRIPTION
This function creates a new site with the specified details for a given customer

.PARAMETER CustomerID
Required. The customer id under which the site should be created.

.PARAMETER Body
Required. The request body matching SiteCreation in the API Explorer.

.EXAMPLE
New-NcentralSite -CustomerID 50 -Body @{ siteName = "Main Office" }

This example creates a new site for customer id 50

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$CustomerID,

        [Parameter(Mandatory = $true)]
        [hashtable]$Body
    )

    Show-Warning

    $uri = "$script:BaseUrl/api/customers/$CustomerID/sites"
    return Invoke-NcentralApi -Uri $uri -Method "POST" -Body $Body
}
