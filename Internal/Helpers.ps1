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
        $code = $null
        try { $code = $_.Exception.Response.StatusCode.value__ } catch {}
        if ($code -eq 401) {
            Write-Warning "Authentication failed or expired. Please reconnect using Connect-Ncentral."
        } elseif ($code -eq 429) {
            Write-Warning "Rate limit exceeded. Please retry after a delay."
        } else {
            Write-Error "API call failed with HTTP $code : $_"
        }
        return $null
    }
}

function Show-Warning {
    Write-Warning "This feature is still in preview and is subject to change in future versions."
}