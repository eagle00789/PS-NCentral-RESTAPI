function Get-NcentralJobStatuses {
<#
.SYNOPSIS
Get a list of job statuses for a specific Organization Unit

.DESCRIPTION
This function gets a list of job statuses for a specific Organization Unit

.PARAMETER OrganizationUnitID
Required. The OrganizationUnitID for which you would like to fetch all job statuses.

.EXAMPLE
Get-NcentralJobStatuses -OrganizationUnitID 50

This example fetches the job statuses for organization unit id 50

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OrganizationUnitID
    )

    $uri = "$script:BaseUrl/api/org-units/$OrganizationUnitID/job-statuses"
    return (Invoke-NcentralApi -Uri $uri -Method "GET").data
}
