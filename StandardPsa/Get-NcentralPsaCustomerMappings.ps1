function Get-NcentralPsaCustomerMappings {
<#
.SYNOPSIS
Get PSA customer mappings for a customer

.DESCRIPTION
This function retrieves customer mappings for a given customer id

.PARAMETER CustomerID
Required. The customer id.

.EXAMPLE
Get-NcentralPsaCustomerMappings -CustomerID 50

This example retrieves customer mappings for customer 50

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int]$CustomerID
    )

    $uri = "$script:BaseUrl/api/standard-psa/customer/$CustomerID/mappings"
    return Invoke-NcentralApi -Uri $uri -Method "GET"
}
