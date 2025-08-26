function Get-NcentralAuthenticationRefresh {
<#
.SYNOPSIS
Refresh the API-Token

.DESCRIPTION
This function will refresh the API Token

.EXAMPLE
Get-NcentralAuthenticationRefresh

This is the only way to refresh the API-Access Token

#>
    [cmdletbinding()]
    param()

    $uri = "$script:BaseUrl/api/auth/refresh"
    $body = $script:RefreshToken

    $tokens = Invoke-NcentralApi -Uri $uri -Method "POST" -Body $body -ConvertToJson $false
    $script:AccessToken = $tokens.tokens.access.token
    $script:RefreshToken = $tokens.tokens.refresh.token
    Write-Information "The Access and Refresh tokens have been successfully refreshed"
}
