function Get-NcentralApiServerInfo {
<#
.SYNOPSIS
Get the NCentral server API information

.DESCRIPTION
This function will retrieve the N-Central Server API information

.EXAMPLE
Get-NcentralApiServerInfo

#>
    [cmdletbinding()]
    $uri = "$script:BaseUrl/api/server-info"
    return Invoke-NcentralApi -Uri $uri -Method "GET"
}
