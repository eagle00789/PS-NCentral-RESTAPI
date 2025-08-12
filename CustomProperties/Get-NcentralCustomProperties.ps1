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

.PARAMETER PropertyId
Optional. Get a specific Propery by ID

.EXAMPLE
Get-NcentralCustomProperties -OrgUnitId 50

This example fetches the custom properties defined in N-Central for OrgUnitId 50

.EXAMPLE
Get-NcentralCustomProperties -OrgUnitId 50 -PropertyId 2514585

This example fetches the custom properties defined in N-Central for OrgUnitId 50 with PropertyId 2514585

#>
    [cmdletbinding(DefaultParameterSetName = 'Multi')]
    param(
        [Parameter(Mandatory = $false, ParameterSetName = 'Multi')]
        [Parameter(Mandatory = $false, ParameterSetName = 'Single')]
        [int]$OrgUnitId = 50,

        [Parameter(Mandatory = $false, ParameterSetName = 'Multi')]
        [int]$PageNumber = 1,

        [Parameter(Mandatory = $false, ParameterSetName = 'Multi')]
        [int]$PageSize = 50,

        [Parameter(Mandatory = $false, ParameterSetName = 'Single')]
        [int]$PropertyId
    )

    Show-Warning

    switch ($PsCmdlet.ParameterSetName) {
        'Multi' {
            $uri = "$script:BaseUrl/api/org-units/$OrgUnitId/custom-properties?pageNumber=$PageNumber&pageSize=$PageSize"
            return (Invoke-NcentralApi -Uri $uri -Method "GET").data
        }
        'Single' {
            $uri = "$script:BaseUrl/api/org-units/$OrgUnitId/custom-properties/$PropertyId"
            return Invoke-NcentralApi -Uri $uri -Method "GET"
        }
    }
}
