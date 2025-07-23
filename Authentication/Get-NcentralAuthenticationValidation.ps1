function Get-NcentralAuthenticationValidation {
<#
.SYNOPSIS
Check the validity of the API-Access Token

.DESCRIPTION
This function checks the validity of the API-Access Token

.EXAMPLE
Get-NcentralAuthenticationValidation

This is the only way to validate the API-Access Token

#>
    [cmdletbinding()]
    param()

    $uri = "$script:BaseUrl/api/auth/validate"
    return (Invoke-NcentralApi -Uri $uri -Method "GET").message
}
