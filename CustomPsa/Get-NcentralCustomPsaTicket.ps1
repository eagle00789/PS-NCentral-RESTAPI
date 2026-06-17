function Get-NcentralCustomPsaTicket {
<#
.SYNOPSIS
Get a Custom PSA ticket without PSA credentials

.DESCRIPTION
This function retrieves detailed information for a specific Custom PSA ticket without requiring PSA credentials

.PARAMETER CustomPsaTicketID
Required. The Custom PSA ticket id.

.EXAMPLE
Get-NcentralCustomPsaTicket -CustomPsaTicketID 12345

This example retrieves detailed information for Custom PSA ticket 12345

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$CustomPsaTicketID
    )

    $uri = "$script:BaseUrl/api/custom-psa/tickets/$CustomPsaTicketID"
    return Invoke-NcentralApi -Uri $uri -Method "GET"
}
