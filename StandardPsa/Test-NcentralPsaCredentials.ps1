function Test-NcentralPsaCredentials {
<#
.SYNOPSIS
Validate standard PSA credentials

.DESCRIPTION
This function validates credentials for a supported standard PSA system

.PARAMETER PsaType
Required. The PSA type to validate.

.PARAMETER Body
Required. The request body matching PsaCredentialRequest in the API Explorer.

.EXAMPLE
Test-NcentralPsaCredentials -PsaType 3 -Body @{ username = "user"; password = "pass" }

This example validates the credentials for a standard PSA system

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$PsaType,

        [Parameter(Mandatory = $true)]
        [hashtable]$Body
    )

    $uri = "$script:BaseUrl/api/standard-psa/$PsaType/credential"
    return Invoke-NcentralApi -Uri $uri -Method "POST" -Body $Body
}
