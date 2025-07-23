function Get-NcentralCustomProperties {
<#
.SYNOPSIS
Get a list of all custom properties

.DESCRIPTION
This function gets a list of all custom properties and it's value for a given SoId

.PARAMETER SoId
Optional. The Service Organization ID. Defaults to 50 if not specified.

.PARAMETER PageNumber
Optional. Gets a specific page with a specified number of items if there are more items to show then PageSize. Defaults to 1 if not specified

.PARAMETER PageSize
Optional. Sets how many items should be fetched per page. Defaults to 50 if not specified.

.EXAMPLE
Get-NcentralCustomProperties -SoId 50

This example creates a new customer record for Acme Corp with a contact email address.

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $false)]
        [int]$SoId = 50,

        [Parameter(Mandatory = $false)]
        [int]$PageNumber = 1,

        [Parameter(Mandatory = $false)]
        [int]$PageSize = 50
    )

    Show-Warning

    $uri = "$script:BaseUrl/api/org-units/$SoId/custom-properties?pageNumber=$PageNumber&pageSize=$PageSize"
    return (Invoke-NcentralApi -Uri $uri -Method "GET").data
}
