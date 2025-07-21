function Get-NcentralCustomProperties {
<#
.SYNOPSIS
Get a list of all custom properties

.DESCRIPTION
This function gets a list of all custom properties and it's value for a given SoId

.PARAMETER SoId
Optional. The Service Organization ID. Defaults to 50 if not specified.

.EXAMPLE
Get-NcentralCustomProperties -SoId 50

This example creates a new customer record for Acme Corp with a contact email address.

#>[cmdletbinding()]
    param(
        [Parameter(Mandatory = $false)]
        [int]$SoId = 50
    )
    $uri = "$script:BaseUrl/api/org-units/$SoId/custom-properties"
    return Invoke-NcentralApi -Uri $uri -Method "GET"
}
