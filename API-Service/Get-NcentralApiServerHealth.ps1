function Get-NcentralApiServerHealth {
<#
.SYNOPSIS
Get the NCentral server API Health

.DESCRIPTION
This function will retrieve the N-Central Server API Health by returning the current date and time of the server

.EXAMPLE
Get-NcentralApiServerHealth

#>
    [cmdletbinding()]
    $uri = "$script:BaseUrl/api/health"
    return Invoke-NcentralApi -Uri $uri -Method "GET"
}
