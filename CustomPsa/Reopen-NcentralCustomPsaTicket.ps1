function Reopen-NcentralCustomPsaTicket {
<#
.SYNOPSIS
Reopen a Custom PSA ticket in N-Central

.DESCRIPTION
This function reopens a Custom PSA ticket in N-Central based on the provided ticket id

.PARAMETER CustomPsaTicketID
Required. The Custom PSA ticket id.

.EXAMPLE
Reopen-NcentralCustomPsaTicket -CustomPsaTicketID 12345

This example reopens Custom PSA ticket 12345

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$CustomPsaTicketID
    )

    $uri = "$script:BaseUrl/api/custom-psa/tickets/$CustomPsaTicketID/reopen"
    return Invoke-NcentralApi -Uri $uri -Method "POST"
}
