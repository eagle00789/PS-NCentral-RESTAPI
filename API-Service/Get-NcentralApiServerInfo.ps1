function Get-NcentralApiServerInfo {
    $uri = "$script:BaseUrl/api/server-info"
    return Invoke-NcentralApi -Uri $uri -Method "GET"
}
