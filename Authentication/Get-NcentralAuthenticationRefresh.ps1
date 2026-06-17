function Get-NcentralAuthenticationRefresh {
<#
.SYNOPSIS
Refresh the API-Token

.DESCRIPTION
This function will refresh the API Token

.PARAMETER AccessExpiryOverride
Optional. Overrides the access token expiry using values like 120s, 30m or 1h

.PARAMETER RefreshExpiryOverride
Optional. Overrides the refresh token expiry using values like 120s, 30m or 1h

.EXAMPLE
Get-NcentralAuthenticationRefresh

This is the only way to refresh the API-Access Token

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]$AccessExpiryOverride,

        [Parameter(Mandatory = $false)]
        [string]$RefreshExpiryOverride
    )

    $uri = "$script:BaseUrl/api/auth/refresh"
    $body = $script:RefreshToken
    $headers = @{}

    if ($PSBoundParameters.ContainsKey('AccessExpiryOverride')) {
        $headers['X-ACCESS-EXPIRY-OVERRIDE'] = $AccessExpiryOverride
    }
    if ($PSBoundParameters.ContainsKey('RefreshExpiryOverride')) {
        $headers['X-REFRESH-EXPIRY-OVERRIDE'] = $RefreshExpiryOverride
    }

    $tokens = Invoke-NcentralApi -Uri $uri -Method "POST" -Body $body -Headers $headers -ConvertToJson $false

    if ([string]::IsNullOrWhiteSpace($tokens.tokens.access.token) -or
        [string]::IsNullOrWhiteSpace($tokens.tokens.refresh.token)) {
        throw "Token refresh response did not contain access and refresh tokens."
    }

    $script:AccessToken = $tokens.tokens.access.token
    $script:RefreshToken = $tokens.tokens.refresh.token
    Write-Information "The Access and Refresh tokens have been successfully refreshed."
}
