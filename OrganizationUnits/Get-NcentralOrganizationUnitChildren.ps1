function Get-NcentralOrganizationUnitChildren {
<#
.SYNOPSIS
Get a list of child Organization Units under a specific parent Organization Unit ID

.DESCRIPTION
This function gets a list of child Organization Units under a specific parent Organization Unit ID

.PARAMETER OrganizationUnitID
Required. The parent OrganizationUnitID for which you would like to fetch all child organization units.

.PARAMETER PageNumber
Optional. Specifies which page of results to retrieve. Used when the total number of organization units exceeds the page size. Defaults to 1 if not specified

.PARAMETER PageSize
Optional. Specifies the number of Organization Units to retrieve per page. Defaults to 50 if not specified.

.PARAMETER All
Optional. If specified, retrieves all child Organization Units across all pages

.PARAMETER SortBy
Optional. Specifies the field on which to sort the results.

.PARAMETER SortOrder
Optional. Specifies the sort order of the results. Valid case-insensitive input is asc, ascending, desc, descending, natural, reverse

.EXAMPLE
Get-NcentralOrganizationUnitChildren -OrganizationUnitID 50 -All

This example fetches all child organization units under organization unit id 50

#>
    [cmdletbinding(DefaultParameterSetName = 'Paged')]
    param(
        [Parameter(Mandatory = $true)]
        [int]$OrganizationUnitID,

        [Parameter(Mandatory = $false, ParameterSetName = 'Paged')]
        [int]$PageNumber = 1,

        [Parameter(Mandatory = $false, ParameterSetName = 'Paged')]
        [int]$PageSize = 50,

        [Parameter(Mandatory = $false, ParameterSetName = 'All')]
        [switch]$All,

        [Parameter(Mandatory = $false)]
        [string]$SortBy,

        [Parameter(Mandatory = $false)]
        [ValidateSet("asc", "ascending", "desc", "descending", "natural", "reverse")]
        [string]$SortOrder
    )

    if ($PSBoundParameters.ContainsKey('SortOrder')) {
        $SortOrder = $SortOrder.ToLower()
    }
    switch ($PsCmdlet.ParameterSetName) {
        'All' {
            $uri = "$script:BaseUrl/api/org-units/$OrganizationUnitID/children?pageNumber=$PageNumber&pageSize=$PageSize"
            if ($PSBoundParameters.ContainsKey('SortOrder')) {
                $uri = "$uri&sortOrder=$SortOrder"
            }
            if ($PSBoundParameters.ContainsKey('SortBy')) {
                $uri = "$uri&sortBy=$SortBy"
            }
            $RawData = Invoke-NcentralApi -Uri $uri -Method "GET"
            $Pages = $RawData.totalPages
            $Data = New-Object System.Collections.Generic.List[Object]
            if ($RawData.data) {
                $Data.AddRange($RawData.data)
            }
            For ($PageNumber = 2; $PageNumber -le $Pages; $PageNumber++) {
                $uri = "$script:BaseUrl/api/org-units/$OrganizationUnitID/children?pageNumber=$PageNumber&pageSize=$PageSize"
                if ($PSBoundParameters.ContainsKey('SortOrder')) {
                    $uri = "$uri&sortOrder=$SortOrder"
                }
                if ($PSBoundParameters.ContainsKey('SortBy')) {
                    $uri = "$uri&sortBy=$SortBy"
                }
                $pageData = (Invoke-NcentralApi -Uri $uri -Method "GET").data
                if ($pageData) {
                    $Data.AddRange($pageData)
                }
            }
            return $Data
        }
        'Paged' {
            $uri = "$script:BaseUrl/api/org-units/$OrganizationUnitID/children?pageNumber=$PageNumber&pageSize=$PageSize"
            if ($PSBoundParameters.ContainsKey('SortOrder')) {
                $uri = "$uri&sortOrder=$SortOrder"
            }
            if ($PSBoundParameters.ContainsKey('SortBy')) {
                $uri = "$uri&sortBy=$SortBy"
            }
            return (Invoke-NcentralApi -Uri $uri -Method "GET").data
        }
    }
}
