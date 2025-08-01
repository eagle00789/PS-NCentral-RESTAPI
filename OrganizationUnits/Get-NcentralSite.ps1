function Get-NcentralSite {
<#
.SYNOPSIS
Get a single site based on SiteID

.DESCRIPTION
This function gets a single site based on SiteID

.PARAMETER SiteID
Required.

.EXAMPLE
Get-NcentralSites -All

This example fetches all N-Central sites

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int]$SiteID = 1
    )

    Show-Warning

    $uri = "$script:BaseUrl/api/sites/$SiteID"
    return Invoke-NcentralApi -Uri $uri -Method "GET"
}
