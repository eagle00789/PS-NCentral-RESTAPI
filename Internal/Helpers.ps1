function Invoke-NcentralApi {
	[cmdletbinding()]
    param (
        [Parameter(Mandatory)] [string] $Uri,
        [Parameter(Mandatory)] [string] $Method,
        [object] $Body = $null,
        [hashtable] $Query = $null,
        [boolean] $ConvertToJson = $True
    )

    try {
        $headers = @{ Authorization = "Bearer $script:AccessToken" }

        if ($Query) {
            $queryString = ($Query.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "&"
            if ($queryString) {
                $Uri += "?" + $queryString
            }
        }

        if ($Body -ne $null) {
            if ($ConvertToJson) {
                $response = Invoke-RestMethod -Uri $Uri -Method $Method -Headers $headers -Body ($Body | ConvertTo-Json -Depth 5) -ContentType "application/json"
            } else {
                $response = Invoke-RestMethod -Uri $Uri -Method $Method -Headers $headers -Body $Body -ContentType "text/plain"
            }
        } else {
            $response = Invoke-RestMethod -Uri $Uri -Method $Method -Headers $headers
        }

        return $response
    } catch {
        $code = $_.Exception.Response.StatusCode.value__
        if ($code -eq 401) {
            Write-Warning "Authentication failed or expired. Please reconnect using Connect-Ncentral."
        } elseif ($code -eq 429) {
            Write-Warning "Rate limit exceeded. Please retry after a delay."
        } else {
            Write-Error "API call failed with HTTP $code : $_"
        }
    }
}

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
        $script:BaseUrl = $BaseUrl.TrimEnd('/')
        $uri = "$script:BaseUrl/api/auth/authenticate"
        $headers = @{ Authorization = "Bearer $JwtToken" }
        $response = Invoke-RestMethod -Uri $uri -Method Post -Headers $headers

        $script:AccessToken = $response.tokens.access.token
        $script:RefreshToken = $response.tokens.refresh.token

        $ServerInfo = Get-NcentralApiServerInfo

        Write-Information "Succesfully connected to N-Central version $($ServerInfo.ncentral) on $BaseUrl" -InformationAction Continue
    } catch {
        Write-Error "Failed to authenticate: $_"
    }
}

function Show-Warning {
    Write-Warning "This feature is still in preview and is subject to change in future versions."
}