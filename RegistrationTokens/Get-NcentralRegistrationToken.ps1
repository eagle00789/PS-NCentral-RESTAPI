function Get-NcentralRegistrationToken {
    <#
.SYNOPSIS
Get a list of all active issues for a specified customer

.DESCRIPTION
This function gets a list of all active issues for a given CustomerID

.PARAMETER SiteID
Required. The Site ID to fetch the registration token from.

.PARAMETER CustomerID
Required. The Customer ID to fetch the registration token from.

.PARAMETER OrganisationID
Required. The Organisation ID to fetch the registration token from.

.EXAMPLE
Get-NcentralActiveIssues -SiteID 1234

This example fetches the RegistrationToken for a site with SiteID 1234.

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'Site')]
        [int]$SiteID,

        [Parameter(Mandatory = $true, ParameterSetName = 'Customer')]
        [int]$CustomerID,

        [Parameter(Mandatory = $true, ParameterSetName = 'Organisation')]
        [int]$OrganisationID
    )

    Show-Warning

    switch ($PSCmdlet.ParameterSetName) {
        'Site'        { $uri = "$script:BaseUrl/api/sites/$SiteID/registration-token" }
        'Customer'    { $uri = "$script:BaseUrl/api/customers/$CustomerID/registration-token" }
        'Organisation'{ $uri = "$script:BaseUrl/api/org-units/$OrganisationID/registration-token" }
        default       { Write-Error "No parameter specified" }
    }
    
    return (Invoke-NcentralApi -Uri $uri -Method "GET").data
}