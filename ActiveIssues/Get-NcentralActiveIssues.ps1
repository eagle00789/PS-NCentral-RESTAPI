function Get-NcentralActiveIssues {
<#
.SYNOPSIS
Get a list of all active issues for a specified customer

.DESCRIPTION
This function gets a list of all active issues for a given CustomerID

.PARAMETER CustomerID
Optional. The Customer ID. Defaults to 50 if not specified.

.PARAMETER PageNumber
Optional. Gets a specific page with a specified number of items if there are more items to show then PageSize. Defaults to 1 if not specified

.PARAMETER PageSize
Optional. Sets how many items should be fetched per page. Defaults to 50 if not specified.

.PARAMETER All
Optional. If specified, retrieves all active issues across all pages.

.PARAMETER SortOrder
Optional. Specifies the sort order of the results. Valid case-insensitive input is asc, ascending, desc, descending, natural, reverse

.EXAMPLE
Get-NcentralActiveIssues -CustomerID 50

This example fetches all active issues for a customer with ID 50

#>
    [cmdletbinding(DefaultParameterSetName = 'Paged')]
    param(
        [Parameter(Mandatory = $false)]
        [int]$CustomerID = 50,

        [Parameter(Mandatory = $false, ParameterSetName = 'Paged')]
        [int]$PageNumber = 1,

        [Parameter(Mandatory = $false, ParameterSetName = 'Paged')]
        [int]$PageSize = 50,

        [Parameter(Mandatory = $false, ParameterSetName = 'All')]
        [switch]$All,

        [Parameter(Mandatory = $false)]
        [ValidateSet("asc", "ascending", "desc", "descending", "natural", "reverse")]
        [string]$SortOrder
    )

    Show-Warning

    if ($PSBoundParameters.ContainsKey('SortOrder')) {
        $SortOrder = $SortOrder.ToLower()
    }
    switch ($PsCmdlet.ParameterSetName) {
        'All' {
            $uri = "$script:BaseUrl/api/org-units/$CustomerID/active-issues?pageNumber=$PageNumber&pageSize=$PageSize"
            if ($PSBoundParameters.ContainsKey('SortOrder')) {
                $uri = "$uri&sortOrder=$SortOrder"
            }
            $RawData = Invoke-NcentralApi -Uri $uri -Method "GET"
            if (-not $RawData) { return $null }
            $Pages = $RawData.totalPages
            $Data = New-Object System.Collections.Generic.List[Object]
            $Data.AddRange($RawData.data)
            For ($PageNumber = 2; $PageNumber -le $Pages; $PageNumber++) {
                $uri = "$script:BaseUrl/api/org-units/$CustomerID/active-issues?pageNumber=$PageNumber&pageSize=$PageSize"
                if ($PSBoundParameters.ContainsKey('SortOrder')) {
                    $uri = "$uri&sortOrder=$SortOrder"
                }
                $Data.AddRange((Invoke-NcentralApi -Uri $uri -Method "GET").data)
            }
            return $Data
        }
        'Paged' {
            $uri = "$script:BaseUrl/api/org-units/$CustomerID/active-issues?pageNumber=$PageNumber&pageSize=$PageSize"
            if ($PSBoundParameters.ContainsKey('SortOrder')) {
                $uri = "$uri&sortOrder=$SortOrder"
            }
            return (Invoke-NcentralApi -Uri $uri -Method "GET").data
        }
    }
}