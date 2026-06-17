function Get-NcentralCustomProperties {
<#
.SYNOPSIS
Get a list of all custom properties

.DESCRIPTION
This function gets a list of all custom properties and it's value for a given SoId

.PARAMETER OrgUnitId
Optional. The Service Organization ID. Defaults to 50 if not specified.

.PARAMETER PageNumber
Optional. Gets a specific page with a specified number of items if there are more items to show then PageSize. Defaults to 1 if not specified

.PARAMETER PageSize
Optional. Sets how many items should be fetched per page. Defaults to 50 if not specified.

.PARAMETER All
Optional. If specified, retrieves all custom properties across all pages.

.PARAMETER Select
Optional. Specifies a comma-separated list of fields to return.

.PARAMETER SortBy
Optional. Specifies the field on which to sort the results.

.PARAMETER SortOrder
Optional. Specifies the sort order of the results. Valid case-insensitive input is asc, ascending, desc, descending, natural, reverse

.PARAMETER PropertyId
Optional. Get a specific Propery by ID

.EXAMPLE
Get-NcentralCustomProperties -OrgUnitId 50

This example fetches the custom properties defined in N-Central for OrgUnitId 50

.EXAMPLE
Get-NcentralCustomProperties -OrgUnitId 50 -PropertyId 2514585

This example fetches the custom properties defined in N-Central for OrgUnitId 50 with PropertyId 2514585

#>
    [cmdletbinding(DefaultParameterSetName = 'Paged')]
    param(
        [Parameter(Mandatory = $false, ParameterSetName = 'Paged')]
        [Parameter(Mandatory = $false, ParameterSetName = 'All')]
        [Parameter(Mandatory = $false, ParameterSetName = 'Single')]
        [int]$OrgUnitId = 50,

        [Parameter(Mandatory = $false, ParameterSetName = 'Paged')]
        [int]$PageNumber = 1,

        [Parameter(Mandatory = $false, ParameterSetName = 'Paged')]
        [int]$PageSize = 50,

        [Parameter(Mandatory = $false, ParameterSetName = 'All')]
        [switch]$All,

        [Parameter(Mandatory = $false, ParameterSetName = 'Paged')]
        [Parameter(Mandatory = $false, ParameterSetName = 'All')]
        [string]$Select,

        [Parameter(Mandatory = $false, ParameterSetName = 'Paged')]
        [Parameter(Mandatory = $false, ParameterSetName = 'All')]
        [string]$SortBy,

        [Parameter(Mandatory = $false, ParameterSetName = 'Paged')]
        [Parameter(Mandatory = $false, ParameterSetName = 'All')]
        [ValidateSet("asc", "ascending", "desc", "descending", "natural", "reverse")]
        [string]$SortOrder,

        [Parameter(Mandatory = $false, ParameterSetName = 'Single')]
        [int]$PropertyId
    )

    if ($PSBoundParameters.ContainsKey('SortOrder')) {
        $SortOrder = $SortOrder.ToLower()
    }

    switch ($PsCmdlet.ParameterSetName) {
        'All' {
            $uri = "$script:BaseUrl/api/org-units/$OrgUnitId/custom-properties?pageNumber=$PageNumber&pageSize=$PageSize"
            if ($PSBoundParameters.ContainsKey('SortOrder')) {
                $uri = "$uri&sortOrder=$SortOrder"
            }
            if ($PSBoundParameters.ContainsKey('SortBy')) {
                $uri = "$uri&sortBy=$SortBy"
            }
            if ($PSBoundParameters.ContainsKey('Select')) {
                $uri = "$uri&select=$Select"
            }

            $RawData = Invoke-NcentralApi -Uri $uri -Method "GET"
            $Pages = $RawData.totalPages
            $Data = New-Object System.Collections.Generic.List[Object]
            if ($RawData.data) {
                $Data.AddRange($RawData.data)
            }

            For ($PageNumber = 2; $PageNumber -le $Pages; $PageNumber++) {
                $uri = "$script:BaseUrl/api/org-units/$OrgUnitId/custom-properties?pageNumber=$PageNumber&pageSize=$PageSize"
                if ($PSBoundParameters.ContainsKey('SortOrder')) {
                    $uri = "$uri&sortOrder=$SortOrder"
                }
                if ($PSBoundParameters.ContainsKey('SortBy')) {
                    $uri = "$uri&sortBy=$SortBy"
                }
                if ($PSBoundParameters.ContainsKey('Select')) {
                    $uri = "$uri&select=$Select"
                }
                $pageData = (Invoke-NcentralApi -Uri $uri -Method "GET").data
                if ($pageData) {
                    $Data.AddRange($pageData)
                }
            }
            return $Data
        }
        'Paged' {
            $uri = "$script:BaseUrl/api/org-units/$OrgUnitId/custom-properties?pageNumber=$PageNumber&pageSize=$PageSize"
            if ($PSBoundParameters.ContainsKey('SortOrder')) {
                $uri = "$uri&sortOrder=$SortOrder"
            }
            if ($PSBoundParameters.ContainsKey('SortBy')) {
                $uri = "$uri&sortBy=$SortBy"
            }
            if ($PSBoundParameters.ContainsKey('Select')) {
                $uri = "$uri&select=$Select"
            }
            return (Invoke-NcentralApi -Uri $uri -Method "GET").data
        }
        'Single' {
            $uri = "$script:BaseUrl/api/org-units/$OrgUnitId/custom-properties/$PropertyId"
            return Invoke-NcentralApi -Uri $uri -Method "GET"
        }
    }
}
