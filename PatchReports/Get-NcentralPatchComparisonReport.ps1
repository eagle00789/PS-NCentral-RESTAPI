function Get-NcentralPatchComparisonReport {
<#
.SYNOPSIS
Get a patch comparison report by ReportID

.DESCRIPTION
This function gets a patch comparison report for a given report id

.PARAMETER ReportID
Required. The report id.

.EXAMPLE
Get-NcentralPatchComparisonReport -ReportID 12345

This example fetches the patch comparison report with id 12345

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ReportID
    )

    $uri = "$script:BaseUrl/api/report/$ReportID"
    return Invoke-NcentralApi -Uri $uri -Method "GET"
}
