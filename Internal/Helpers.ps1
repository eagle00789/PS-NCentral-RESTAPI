function Invoke-NcentralApi {
	[cmdletbinding()]
    param (
        [Parameter(Mandatory)] [string] $Uri,
        [Parameter(Mandatory)] [string] $Method,
        [object] $Body = $null,
        [hashtable] $Query = $null
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
            $response = Invoke-RestMethod -Uri $Uri -Method $Method -Headers $headers -Body ($Body | ConvertTo-Json -Depth 5) -ContentType "application/json"
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

        Write-Host "Succesfully connected to N-Central version $($ServerInfo.ncentral) on $BaseUrl" -ForegroundColor Yellow
    } catch {
        Write-Error "Failed to authenticate: $_"
    }
}
