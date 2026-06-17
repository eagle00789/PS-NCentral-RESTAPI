function Get-NcentralApplianceTask {
<#
.SYNOPSIS
Get a single appliance task based on TaskID

.DESCRIPTION
This function gets a single appliance task based on TaskID

.PARAMETER TaskID
Required.

.EXAMPLE
Get-NcentralApplianceTask -TaskID "ABC123"

This example fetches a single appliance task by id ABC123

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$TaskID
    )

    $uri = "$script:BaseUrl/api/appliance-tasks/$TaskID"
    return Invoke-NcentralApi -Uri $uri -Method "GET"
}
