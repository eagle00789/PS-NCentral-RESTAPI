function Get-NcentralPsaCustomerMappingDeprecated {
<#
.SYNOPSIS
Get deprecated PSA customer mappings for a customer

.DESCRIPTION
This function retrieves customer mappings for a given customer id using the deprecated endpoint

.PARAMETER CustomerID
Required. The customer id.

.EXAMPLE
Get-NcentralPsaCustomerMappingDeprecated -CustomerID 50

This example retrieves customer mappings using the deprecated endpoint for customer 50

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int]$CustomerID
    )

    $uri = "$script:BaseUrl/api/standard-psa/customer-mapping/$CustomerID"
    return Invoke-NcentralApi -Uri $uri -Method "GET"
}
