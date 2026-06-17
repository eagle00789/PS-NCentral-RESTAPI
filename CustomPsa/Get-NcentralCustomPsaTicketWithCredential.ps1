function Get-NcentralCustomPsaTicketWithCredential {
<#
.SYNOPSIS
Get a Custom PSA ticket using PSA credentials

.DESCRIPTION
This function retrieves detailed information for a specific Custom PSA ticket using PSA credentials

.PARAMETER CustomPsaTicketID
Required. The Custom PSA ticket id.

.PARAMETER Body
Required. The request body matching PsaCredentialRequest in the API Explorer.

.EXAMPLE
Get-NcentralCustomPsaTicketWithCredential -CustomPsaTicketID 12345 -Body @{ username = "user"; password = "pass" }

This example retrieves detailed information for Custom PSA ticket 12345 using PSA credentials

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$CustomPsaTicketID,

        [Parameter(Mandatory = $true)]
        [hashtable]$Body
    )

    $uri = "$script:BaseUrl/api/custom-psa/tickets/$CustomPsaTicketID"
    return Invoke-NcentralApi -Uri $uri -Method "POST" -Body $Body
}
