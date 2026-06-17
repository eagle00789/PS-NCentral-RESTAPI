function Invoke-NcentralAuthenticationLogout {
<#
.SYNOPSIS
Invalidates the current authenticated N-Central API session

.DESCRIPTION
This function invalidates the current authenticated N-Central API session

.EXAMPLE
Invoke-NcentralAuthenticationLogout

This example invalidates the current N-Central API session

#>
    [cmdletbinding()]
    param()

    $uri = "$script:BaseUrl/api/auth/logout"
    $result = Invoke-NcentralApi -Uri $uri -Method "POST"
    Disconnect-Ncentral
    return $result
}
