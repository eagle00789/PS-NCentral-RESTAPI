function Get-NcentralUsers {
<#
.SYNOPSIS
Get a list of all N-Central users created under a specific Organisation ID

.DESCRIPTION
This function gets a list of users for a given OrganisationID

.PARAMETER orgUnitID
Optional. The Organisation ID. Defaults to 50 if not specified.

.PARAMETER PageNumber
Optional. Specifies which page of results to retrieve. Used when the total number of users exceeds the page size. Defaults to 1 if not specified

.PARAMETER PageSize
Optional. Specifies the number of users to retrieve per page. Defaults to 50 if not specified.

.PARAMETER All
Optional. If specified, retrieves all users across all pages

.PARAMETER SortOrder
Optional. Specifies the sort order of the results. Valid case-insensitive input is asc, ascending, desc, descending

.EXAMPLE
Get-NcentralUsers -orgUnitID 50

This example fetches all N-Central users for a customer with ID 50

#>
    [cmdletbinding(DefaultParameterSetName = 'Paged')]
    param(
        [Parameter(Mandatory = $false)]
        [int]$orgUnitID = 50,

        [Parameter(Mandatory = $false, ParameterSetName = 'Paged')]
        [int]$PageNumber = 1,

        [Parameter(Mandatory = $false, ParameterSetName = 'Paged')]
        [int]$PageSize = 50,

        [Parameter(Mandatory = $false, ParameterSetName = 'All')]
        [switch]$All,

        [Parameter(Mandatory = $false)]
        [ValidateSet("asc", "ascending", "desc", "descending")]
        [string]$SortOrder
    )

    Show-Warning

    if ($PSBoundParameters.ContainsKey('SortOrder')) {
        $SortOrder = $SortOrder.ToLower()
    }
    switch ($PsCmdlet.ParameterSetName) {
        'All' {
            $uri = "$script:BaseUrl/api/org-units/$orgUnitID/users?pageNumber=$PageNumber&pageSize=$PageSize"
            if ($PSBoundParameters.ContainsKey('SortOrder')) {
                $uri = "$uri&sortOrder=$SortOrder"
            }
            $RawData = Invoke-NcentralApi -Uri $uri -Method "GET"
            $Pages = $RawData.totalPages
            $Data = New-Object System.Collections.Generic.List[Object]
            $Data.AddRange($RawData.data)
            For ($PageNumber = 2; $PageNumber -le $Pages; $PageNumber++) {
                $uri = "$script:BaseUrl/api/org-units/$orgUnitID/users?pageNumber=$PageNumber&pageSize=$PageSize"
                if ($PSBoundParameters.ContainsKey('SortOrder')) {
                    $uri = "$uri&sortOrder=$SortOrder"
                }
                $Data.AddRange((Invoke-NcentralApi -Uri $uri -Method "GET").data)
            }
            return $Data
        }
        'Paged' {
            $uri = "$script:BaseUrl/api/org-units/$orgUnitID/users?pageNumber=$PageNumber&pageSize=$PageSize"
            if ($PSBoundParameters.ContainsKey('SortOrder')) {
                $uri = "$uri&sortOrder=$SortOrder"
            }
            return (Invoke-NcentralApi -Uri $uri -Method "GET").data
        }
    }
}