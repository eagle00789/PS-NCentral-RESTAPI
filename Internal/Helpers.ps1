function Invoke-NcentralApi {
	[cmdletbinding()]
    param (
        [Parameter(Mandatory)] [string] $Uri,
        [Parameter(Mandatory)]
        [ValidateSet("DELETE", "GET", "PATCH", "POST", "PUT")]
        [string] $Method,
        [object] $Body = $null,
        [hashtable] $Query = $null,
        [boolean] $ConvertToJson = $True
    )

    try {
        if ([string]::IsNullOrWhiteSpace($script:AccessToken)) {
            throw "Not connected to N-Central. Run Connect-Ncentral before calling an API endpoint."
        }

        $headers = @{ Authorization = "Bearer $script:AccessToken" }

        if ($Query) {
            $queryString = ($Query.GetEnumerator() |
                Sort-Object Key |
                ForEach-Object {
                    $key = [uri]::EscapeDataString([string]$_.Key)
                    $value = [uri]::EscapeDataString([string]$_.Value)
                    "$key=$value"
                }) -join "&"
            if ($queryString) {
                $separator = if ($Uri.Contains('?')) { '&' } else { '?' }
                $Uri += $separator + $queryString
            }
        }

        if ($Body -ne $null) {
            if ($ConvertToJson) {
                $response = Invoke-RestMethod -Uri $Uri -Method $Method -Headers $headers -Body ($Body | ConvertTo-Json -Depth 10) -ContentType "application/json"
            } else {
                $response = Invoke-RestMethod -Uri $Uri -Method $Method -Headers $headers -Body $Body -ContentType "text/plain"
            }
        } else {
            $response = Invoke-RestMethod -Uri $Uri -Method $Method -Headers $headers
        }

        return $response
    }
    catch {
        $code = $null
        try { $code = $_.Exception.Response.StatusCode.value__ } catch {}

        if ($code -eq 401) {
            $message = "Authentication failed or expired. Reconnect using Connect-Ncentral."
        }
        elseif ($code -eq 429) {
            $message = "Rate limit exceeded. Retry after a delay."
        }
        elseif ($null -ne $code) {
            $message = "N-Central API call failed with HTTP ${code}: $($_.Exception.Message)"
        }
        else {
            $message = "N-Central API call failed: $($_.Exception.Message)"
        }

        $errorRecord = [System.Management.Automation.ErrorRecord]::new(
            [System.InvalidOperationException]::new($message, $_.Exception),
            'NcentralApiRequestFailed',
            [System.Management.Automation.ErrorCategory]::InvalidOperation,
            $Uri
        )
        $PSCmdlet.ThrowTerminatingError($errorRecord)
    }
}

function Show-Warning {
    Write-Warning "This feature is still in preview and is subject to change in future versions."
}
