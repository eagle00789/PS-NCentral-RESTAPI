function Set-NcentralPsaCustomerMappings {
<#
.SYNOPSIS
Update PSA customer mappings for a customer

.DESCRIPTION
This function updates customer mappings for a given customer id

.PARAMETER CustomerID
Required. The customer id.

.PARAMETER Body
Required. The request body matching PsaCustomerMappingUpdateItem in the API Explorer.

.EXAMPLE
Set-NcentralPsaCustomerMappings -CustomerID 50 -Body @{ mappings = @() }

This example updates customer mappings for customer 50

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int]$CustomerID,

        [Parameter(Mandatory = $true)]
        [object]$Body
    )

    $uri = "$script:BaseUrl/api/standard-psa/customer/$CustomerID/mappings"
    return Invoke-NcentralApi -Uri $uri -Method "PUT" -Body $Body
}
