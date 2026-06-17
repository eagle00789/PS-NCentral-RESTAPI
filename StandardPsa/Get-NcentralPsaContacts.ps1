function Get-NcentralPsaContacts {
<#
.SYNOPSIS
Get PSA contacts for a customer and PSA company

.DESCRIPTION
This function retrieves PSA contacts for a given customer id and PSA company id

.PARAMETER CustomerID
Required. The customer id.

.PARAMETER PsaCompanyID
Required. The PSA company id.

.EXAMPLE
Get-NcentralPsaContacts -CustomerID 50 -PsaCompanyID 100

This example retrieves PSA contacts for customer 50 and PSA company 100

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int]$CustomerID,

        [Parameter(Mandatory = $true)]
        [int]$PsaCompanyID
    )

    $uri = "$script:BaseUrl/api/standard-psa/customers/$CustomerID/companies/$PsaCompanyID/contacts"
    return Invoke-NcentralApi -Uri $uri -Method "GET"
}
