function Get-NcentralCustomer {
<#
.SYNOPSIS
Get a single customer based on CustomerID

.DESCRIPTION
This function gets a single customer based on CustomerID

.PARAMETER CustomerID
Required.

.EXAMPLE
Get-NcentralCustomer -CustomerID 1085

This example fetches a single customer by id 1085

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int]$CustomerID
    )

    $uri = "$script:BaseUrl/api/customers/$CustomerID"
    return Invoke-NcentralApi -Uri $uri -Method "GET"
}
