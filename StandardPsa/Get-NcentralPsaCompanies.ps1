function Get-NcentralPsaCompanies {
<#
.SYNOPSIS
Get PSA companies for a customer

.DESCRIPTION
This function retrieves PSA companies for a given customer id

.PARAMETER CustomerID
Required. The customer id.

.EXAMPLE
Get-NcentralPsaCompanies -CustomerID 50

This example retrieves PSA companies for customer 50

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int]$CustomerID
    )

    $uri = "$script:BaseUrl/api/standard-psa/customers/$CustomerID/companies"
    return Invoke-NcentralApi -Uri $uri -Method "GET"
}
