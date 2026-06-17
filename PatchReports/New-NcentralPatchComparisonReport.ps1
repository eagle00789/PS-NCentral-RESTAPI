function New-NcentralPatchComparisonReport {
<#
.SYNOPSIS
Generate a patch comparison report

.DESCRIPTION
This function submits a request to generate a patch comparison report

.PARAMETER Body
Required. The request body matching PatchComparisonReportRequest in the API Explorer.

.EXAMPLE
New-NcentralPatchComparisonReport -Body @{ customerId = 50 }

This example submits a patch comparison report request

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [hashtable]$Body
    )

    $uri = "$script:BaseUrl/api/report/patch-comparison"
    return Invoke-NcentralApi -Uri $uri -Method "POST" -Body $Body
}
