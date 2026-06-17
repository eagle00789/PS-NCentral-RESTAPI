function New-NcentralCustomPsaTicket {
<#
.SYNOPSIS
Create a Custom PSA ticket in N-Central

.DESCRIPTION
This function creates a Custom PSA ticket in N-Central based on the provided information

.PARAMETER Body
Required. The request body matching CustomPsaTicketCreateRequest in the API Explorer.

.EXAMPLE
New-NcentralCustomPsaTicket -Body @{ title = "Issue"; description = "Details" }

This example creates a Custom PSA ticket in N-Central

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [hashtable]$Body
    )

    $uri = "$script:BaseUrl/api/custom-psa/tickets"
    return Invoke-NcentralApi -Uri $uri -Method "POST" -Body $Body
}
