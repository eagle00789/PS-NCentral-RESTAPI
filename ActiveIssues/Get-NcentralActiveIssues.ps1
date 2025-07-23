function Get-NcentralActiveIssues {
<#
.SYNOPSIS
Get a list of all active issues for a specified customer

.DESCRIPTION
This function gets a list of all custom properties and it's value for a given SoId

.PARAMETER CustomerID
Optional. The Customer ID. Defaults to 50 if not specified.

.PARAMETER PageNumber
Optional. Gets a specific page with a specified number of items if there are more items to show then PageSize. Defaults to 1 if not specified

.PARAMETER PageSize
Optional. Sets how many items should be fetched per page. Defaults to 50 if not specified.

.EXAMPLE
Get-NcentralCustomProperties -CustomerID 50

This example creates a new customer record for Acme Corp with a contact email address.

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $false)]
        [int]$CustomerID = 50,

        [Parameter(Mandatory = $false)]
        [int]$PageNumber = 1,

        [Parameter(Mandatory = $false)]
        [int]$PageSize = 50
    )

    Show-Warning

    $uri = "$script:BaseUrl/api/org-units/$CustomerID/active-issues?pageNumber=$PageNumber&pageSize=$PageSize"
    return (Invoke-NcentralApi -Uri $uri -Method "GET").data
}