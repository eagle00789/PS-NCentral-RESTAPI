function Get-NcentralDevices {
<#
.SYNOPSIS
Get a list of all N-Central Devices

.DESCRIPTION
This function gets a list of all N-Central devices. Optionally can be filtered by using the FilterID or OrgUnitID

.PARAMETER OrgUnitID
Optional. The Organisation Unit ID.

.PARAMETER FilterID
Optional. The Filter ID.

.PARAMETER PageNumber
Optional. Specifies which page of results to retrieve. Used when the total number of users exceeds the page size. Defaults to 1 if not specified

.PARAMETER PageSize
Optional. Specifies the number of users to retrieve per page. Defaults to 50 if not specified.

.PARAMETER All
Optional. If specified, retrieves all users across all pages

.PARAMETER Select
Optional. Specifies a comma-separated list of fields to return.

.PARAMETER SortBy
Optional. Specifies the field on which to sort the results.

.PARAMETER SortOrder
Optional. Specifies the sort order of the results. Valid case-insensitive input is asc, ascending, desc, descending, natural, reverse

.EXAMPLE
Get-NcentralDevices -FilterID 38225172

This example fetches all N-Central devices that match with filter ID 38225172

#>
    [cmdletbinding(DefaultParameterSetName = 'Paged')]
    param(
        [Parameter(Mandatory = $false)]
        [int]$FilterID,

        [Parameter(Mandatory = $false)]
        [int]$OrgUnitID,

        [Parameter(Mandatory = $false, ParameterSetName = 'Paged')]
        [int]$PageNumber = 1,

        [Parameter(Mandatory = $false, ParameterSetName = 'Paged')]
        [int]$PageSize = 50,

        [Parameter(Mandatory = $false, ParameterSetName = 'All')]
        [switch]$All,

        [Parameter(Mandatory = $false)]
        [string]$Select,

        [Parameter(Mandatory = $false)]
        [string]$SortBy,

        [Parameter(Mandatory = $false)]
        [ValidateSet("asc", "ascending", "desc", "descending", "natural", "reverse")]
        [string]$SortOrder
    )


    if ($PSBoundParameters.ContainsKey('SortOrder')) {
        $SortOrder = $SortOrder.ToLower()
    }

    if ($PSBoundParameters.ContainsKey('OrgUnitID')) {
        $uri = "$script:BaseUrl/api/org-units/$OrgUnitID/devices"
    }
    else {
        $uri = "$script:BaseUrl/api/devices"
    }

    $query = @{
        pageNumber = $PageNumber
        pageSize = $PageSize
    }
    if ($PSBoundParameters.ContainsKey('SortOrder')) {
        $query.sortOrder = $SortOrder
    }
    if ($PSBoundParameters.ContainsKey('SortBy')) {
        $query.sortBy = $SortBy
    }
    if ($PSBoundParameters.ContainsKey('Select')) {
        $query.select = $Select
    }
    if ($PSBoundParameters.ContainsKey('FilterID')) {
        $query.filterId = $FilterID
    }

    switch ($PsCmdlet.ParameterSetName) {
        'All' {
            $rawData = Invoke-NcentralApi -Uri $uri -Method "GET" -Query $query
            $pages = [Math]::Max([int]$rawData.totalPages, 1)
            $data = [System.Collections.Generic.List[object]]::new()

            foreach ($item in @($rawData.data)) {
                $data.Add($item)
            }

            for ($currentPage = 2; $currentPage -le $pages; $currentPage++) {
                $query.pageNumber = $currentPage
                $page = Invoke-NcentralApi -Uri $uri -Method "GET" -Query $query
                foreach ($item in @($page.data)) {
                    $data.Add($item)
                }
            }

            return $data
        }
        'Paged' {
            return (Invoke-NcentralApi -Uri $uri -Method "GET" -Query $query).data
        }
    }
}
