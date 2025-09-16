function Get-NcentralCustomerSites {
<#
.SYNOPSIS
Get a list of all N-Central sites under a specific Customer ID

.DESCRIPTION
This function gets a list of all N-Central sites under a specific Customer ID

.PARAMETER CustomerID
Required. The CustomerID for which you would like to fetch all sites.

.PARAMETER PageNumber
Optional. Specifies which page of results to retrieve. Used when the total number of users exceeds the page size. Defaults to 1 if not specified

.PARAMETER PageSize
Optional. Specifies the number of sites to retrieve per page. Defaults to 50 if not specified.

.PARAMETER All
Optional. If specified, retrieves all sites across all pages

.PARAMETER SortBy
Optional. Specifies the field on which to sort the results. Valid case-insensitive input is siteId, siteName, parentId, externalId, externalId2, phone, contactTitle, contactFirstName, contactLastName, contactEmail, contactPhone, contactPhoneExt, contactDepartment, street1, street2, city, stateProv, country, county, postalCode

.PARAMETER SortOrder
Optional. Specifies the sort order of the results. Default is asc. Valid case-insensitive input is asc, ascending, desc, descending, natural, reverse

.EXAMPLE
Get-NcentralServiceOrganisations -All

This example fetches all N-Central sites

#>
    [cmdletbinding(DefaultParameterSetName = 'Paged')]
    param(
        [Parameter(Mandatory = $True)]
        [int]$CustomerID,

        [Parameter(Mandatory = $false, ParameterSetName = 'Paged')]
        [int]$PageNumber = 1,

        [Parameter(Mandatory = $false, ParameterSetName = 'Paged')]
        [int]$PageSize = 50,

        [Parameter(Mandatory = $false, ParameterSetName = 'All')]
        [switch]$All,

        [Parameter(Mandatory = $false)]
        [ValidateSet("siteId", "siteName", "parentId", "externalId", "externalId2", "phone", "contactTitle", "contactFirstName", "contactLastName", "contactEmail", "contactPhone", "contactPhoneExt", "contactDepartment", "street1", "street2", "city", "stateProv", "country", "county", "postalCode")]
        [string]$SortBy,

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
            $uri = "$script:BaseUrl/api/customers/$CustomerID/sites?pageNumber=$PageNumber&pageSize=$PageSize"
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
                $uri = "$script:BaseUrl/api/customers/$CustomerID/sites?pageNumber=$PageNumber&pageSize=$PageSize"
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
            $uri = "$script:BaseUrl/api/customers/$CustomerID/sites?pageNumber=$PageNumber&pageSize=$PageSize"
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