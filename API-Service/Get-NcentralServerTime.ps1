function Get-NcentralServerTime {
<#
.SYNOPSIS
Get the current N-Central server time information

.DESCRIPTION
This function gets the current N-Central server time information

.EXAMPLE
Get-NcentralServerTime

This example fetches the current server time information from N-Central

#>
    [cmdletbinding()]
    param()

    $uri = "$script:BaseUrl/api/server-info/time"
    return Invoke-NcentralApi -Uri $uri -Method "GET"
}
