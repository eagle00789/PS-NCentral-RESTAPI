function Get-NcentralDevices {
<#
.SYNOPSIS
Get a list of all N-Central Devices

.DESCRIPTION
This function gets a list of all N-Central devices. Optionally can be filtered by using the FilterID

.PARAMETER FilterID
Optional. The Filter ID.

.PARAMETER PageNumber
Optional. Specifies which page of results to retrieve. Used when the total number of users exceeds the page size. Defaults to 1 if not specified

.PARAMETER PageSize
Optional. Specifies the number of users to retrieve per page. Defaults to 50 if not specified.

.PARAMETER All
Optional. If specified, retrieves all users across all pages

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
            $uri = "$script:BaseUrl/api/devices?pageNumber=$PageNumber&pageSize=$PageSize"
            if ($PSBoundParameters.ContainsKey('SortOrder')) {
                $uri = "$uri&sortOrder=$SortOrder"
            }
            if ($PSBoundParameters.ContainsKey('FilterID')) {
                $uri = "$uri&filterID=$FilterID"
            }
            $RawData = Invoke-NcentralApi -Uri $uri -Method "GET"
            $Pages = $RawData.totalPages
            $Data = New-Object System.Collections.Generic.List[Object]
            $Data.AddRange($RawData.data)
            For ($PageNumber = 2; $PageNumber -le $Pages; $PageNumber++) {
                $uri = "$script:BaseUrl/api/devices?pageNumber=$PageNumber&pageSize=$PageSize"
                if ($PSBoundParameters.ContainsKey('SortOrder')) {
                    $uri = "$uri&sortOrder=$SortOrder"
                }
                if ($PSBoundParameters.ContainsKey('FilterID')) {
                    $uri = "$uri&filterID=$FilterID"
                }
                $Data.AddRange((Invoke-NcentralApi -Uri $uri -Method "GET").data)
            }
            return $Data
        }
        'Paged' {
            $uri = "$script:BaseUrl/api/devices?pageNumber=$PageNumber&pageSize=$PageSize"
            if ($PSBoundParameters.ContainsKey('SortOrder')) {
                $uri = "$uri&sortOrder=$SortOrder"
            }
            if ($PSBoundParameters.ContainsKey('FilterID')) {
                $uri = "$uri&filterID=$FilterID"
            }
            return (Invoke-NcentralApi -Uri $uri -Method "GET").data
        }
    }
}