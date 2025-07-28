function Get-NcentralAccessGroup {
<#
.SYNOPSIS
Get the detailed information for a specific Access Group by AccessGroupID

.DESCRIPTION
This function gets the detailed information for a specified Access Group by AccessGroupID

.PARAMETER AccessGroupID
Required. The AccessGroupID.

.EXAMPLE
Get-NcentralAccessGroups -orgUnitID 50

This example fetches all N-Central Access Groups for a customer with ID 50

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $True)]
        [int]$AccessGroupID
    )

    Show-Warning

    $uri = "$script:BaseUrl/api/access-groups/$AccessGroupID"

    return (Invoke-NcentralApi -Uri $uri -Method "GET").data
}