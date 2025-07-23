function Get-NcentralActiveIssues {
<#
.SYNOPSIS
Get a list of all active issues for a specified customer

.DESCRIPTION
This function gets a list of all active issues for a given CustomerID

.PARAMETER CustomerID
Required. The Customer ID. Defaults to 50 if not specified.

.PARAMETER PageNumber
Optional. Gets a specific page with a specified number of items if there are more items to show then PageSize. Defaults to 1 if not specified

.PARAMETER PageSize
Optional. Sets how many items should be fetched per page. Defaults to 50 if not specified.

.PARAMETER All
Optional. This specifies to retrieve all active issues

.EXAMPLE
Get-NcentralActiveIssues -CustomerID 50

This example fetches all active issues for a customer with ID 50

#>
    [cmdletbinding(DefaultParameterSetName = 'Paged')]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'All')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Paged')]
        [int]$CustomerID = 50,

        [Parameter(Mandatory = $false, ParameterSetName = 'Paged')]
        [int]$PageNumber = 1,

        [Parameter(Mandatory = $false, ParameterSetName = 'Paged')]
        [int]$PageSize = 50,

        [Parameter(Mandatory = $false, ParameterSetName = 'All')]
        [switch]$All
    )

    Show-Warning

    $uri = "$script:BaseUrl/api/org-units/$CustomerID/active-issues?pageNumber=$PageNumber&pageSize=$PageSize"
    switch ($PsCmdlet.ParameterSetName) {
        'All' {
            $RawData = Invoke-NcentralApi -Uri $uri -Method "GET"
            $Pages = $RawData.totalPages
            $Data = $RawData.data
            For ($PageNumber = $PageNumber + 1; $PageNumber -le $Pages; $PageNumber++) {
                $Data += (Invoke-NcentralApi -Uri $uri -Method "GET").data
            }
            return $Data
        }
        'Paged' {
            return (Invoke-NcentralApi -Uri $uri -Method "GET").data
        }
    }
}