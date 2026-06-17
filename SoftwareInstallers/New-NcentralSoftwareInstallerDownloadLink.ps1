function New-NcentralSoftwareInstallerDownloadLink {
<#
.SYNOPSIS
Generate a software installer download link

.DESCRIPTION
This function generates a software installer download link for a given customer

.PARAMETER CustomerID
Required. The customer id.

.PARAMETER Body
Required. The request body matching GenerateSoftwareDownloadRequest in the API Explorer.

.EXAMPLE
New-NcentralSoftwareInstallerDownloadLink -CustomerID 50 -Body @{ softwareType = "Agent" }

This example generates a software installer download link for customer 50

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$CustomerID,

        [Parameter(Mandatory = $true)]
        [hashtable]$Body
    )

    $uri = "$script:BaseUrl/api/customers/$CustomerID/software/installers"
    return Invoke-NcentralApi -Uri $uri -Method "POST" -Body $Body
}
