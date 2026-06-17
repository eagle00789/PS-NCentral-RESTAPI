function Resolve-NcentralCustomPsaTicket {
<#
.SYNOPSIS
Resolve a Custom PSA ticket in N-Central

.DESCRIPTION
This function resolves a Custom PSA ticket in N-Central based on the provided ticket id

.PARAMETER CustomPsaTicketID
Required. The Custom PSA ticket id.

.EXAMPLE
Resolve-NcentralCustomPsaTicket -CustomPsaTicketID 12345

This example resolves Custom PSA ticket 12345

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$CustomPsaTicketID
    )

    $uri = "$script:BaseUrl/api/custom-psa/tickets/$CustomPsaTicketID/resolve"
    return Invoke-NcentralApi -Uri $uri -Method "POST"
}
