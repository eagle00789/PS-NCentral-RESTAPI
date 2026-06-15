function Connect-Ncentral {
<#
.SYNOPSIS
Connect to N-Central using the REST API

.DESCRIPTION
This function will connect to the REST API of N-Central 

.PARAMETER JwtToken
Required. Defines the JWT Token used for authorization to the API

.PARAMETER BaseUrl
Required. To which URL are we connecting to

.EXAMPLE
Connect-Ncentral -JwtToken as34789kjasndcv9813247891234asjkldv.qwuiop1237894jfvhqwiop2973 -BaseUrl ncentral.example.com

This will connect to the NCentral server hosted on ncentral.example.com using the provided Access Token

#>
    [cmdletbinding()]
	param (
        [Parameter(Mandatory)] [string] $JwtToken,
        [Parameter(Mandatory)] [string] $BaseUrl
    )

    try {
		$BaseUrl = 'https://' + ($BaseUrl -replace '^.*://', '')
        $normalizedBaseUrl = $BaseUrl.TrimEnd('/')
        $uri = "$normalizedBaseUrl/api/auth/authenticate"
        $headers = @{ Authorization = "Bearer $JwtToken" }
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
        Write-Error "Failed to authenticate: $_"
    }
}
