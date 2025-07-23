function Get-NcentralApiServerInfoExtra {
<#
.SYNOPSIS
Get the NCentral server API version information

.DESCRIPTION
This function will retrieve the N-Central Server API version information

.EXAMPLE
Get-NcentralApiServerInfoExtra

#>
    [cmdletbinding()]
    param()
    
    Show-Warning

    $uri = "$script:BaseUrl/api/server-info/extra"
    return Invoke-NcentralApi -Uri $uri -Method "GET"
}
