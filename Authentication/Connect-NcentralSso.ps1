function Connect-NcentralSso {
<#
.SYNOPSIS
Connect to N-Central using the REST API and an SSO access token

.DESCRIPTION
This function connects to the REST API of N-Central using an SSO access token

.PARAMETER SsoToken
Required. Defines the SSO access token used for authorization to the API

.PARAMETER BaseUrl
Required. To which URL are we connecting to

.PARAMETER AccessExpiryOverride
Optional. Overrides the access token expiry using values like 120s, 30m or 1h

.PARAMETER RefreshExpiryOverride
Optional. Overrides the refresh token expiry using values like 120s, 30m or 1h

.EXAMPLE
Connect-NcentralSso -SsoToken "token" -BaseUrl ncentral.example.com

This example connects to the NCentral server hosted on ncentral.example.com using the provided SSO token

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory)] [string] $SsoToken,
        [Parameter(Mandatory)] [string] $BaseUrl,
        [Parameter(Mandatory = $false)] [string] $AccessExpiryOverride,
        [Parameter(Mandatory = $false)] [string] $RefreshExpiryOverride
    )

    try {
        $BaseUrl = 'https://' + ($BaseUrl -replace '^.*://', '')
        $normalizedBaseUrl = $BaseUrl.TrimEnd('/')
        $uri = "$normalizedBaseUrl/api/auth/sso"
        $headers = @{ Authorization = "Bearer $SsoToken" }
        if ($PSBoundParameters.ContainsKey('AccessExpiryOverride')) {
            $headers['X-ACCESS-EXPIRY-OVERRIDE'] = $AccessExpiryOverride
        }
        if ($PSBoundParameters.ContainsKey('RefreshExpiryOverride')) {
            $headers['X-REFRESH-EXPIRY-OVERRIDE'] = $RefreshExpiryOverride
        }
        $response = Invoke-RestMethod -Uri $uri -Method Post -Headers $headers

        if ([string]::IsNullOrWhiteSpace($response.tokens.access.token) -or
            [string]::IsNullOrWhiteSpace($response.tokens.refresh.token)) {
            throw "Authentication response did not contain access and refresh tokens."
        }

        $script:BaseUrl = $normalizedBaseUrl
        $script:AccessToken = $response.tokens.access.token
        $script:RefreshToken = $response.tokens.refresh.token
        $script:Connected = $true

        $ServerInfo = Get-NcentralApiServerInfo

        Write-Information "Succesfully connected to N-Central version $($ServerInfo.ncentral) on $BaseUrl" -InformationAction Continue
    }
    catch {
        $script:BaseUrl = $null
        $script:AccessToken = $null
        $script:RefreshToken = $null
        $script:Connected = $false
        Write-Error "Failed to authenticate using SSO: $_"
    }
}
