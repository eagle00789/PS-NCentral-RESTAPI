function Get-NcentralPsaSites {
<#
.SYNOPSIS
Get PSA sites for a customer and PSA company

.DESCRIPTION
This function retrieves PSA sites for a given customer id and PSA company id

.PARAMETER CustomerID
Required. The customer id.

.PARAMETER PsaCompanyID
Required. The PSA company id.

.EXAMPLE
Get-NcentralPsaSites -CustomerID 50 -PsaCompanyID 100

This example retrieves PSA sites for customer 50 and PSA company 100

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int]$CustomerID,

        [Parameter(Mandatory = $true)]
        [int]$PsaCompanyID
    )

    $uri = "$script:BaseUrl/api/standard-psa/customers/$CustomerID/companies/$PsaCompanyID/sites"
    return Invoke-NcentralApi -Uri $uri -Method "GET"
}
