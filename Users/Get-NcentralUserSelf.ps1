function Get-NcentralUserSelf {
<#
.SYNOPSIS
Get the profile of the authenticated N-Central user

.DESCRIPTION
This function gets the profile of the authenticated N-Central user

.EXAMPLE
Get-NcentralUserSelf

This example fetches the profile of the authenticated N-Central user

#>
    [cmdletbinding()]
    param()

    $uri = "$script:BaseUrl/api/users/me"
    return Invoke-NcentralApi -Uri $uri -Method "GET"
}
