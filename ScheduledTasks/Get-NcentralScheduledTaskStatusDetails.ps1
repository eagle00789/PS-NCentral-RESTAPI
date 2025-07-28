function Get-NcentralScheduledTaskStatusDetails {
<#
.SYNOPSIS
Get the detailed status per device for a given TaskID

.DESCRIPTION
This function gets the detailed status per device for a given TaskID

.PARAMETER TaskID
Required. The TaskID.

.EXAMPLE
Get-NcentralScheduledTaskStatusDetails -TaskID 95748585

This example fetches the task information with TaskID 95748585

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $True)]
        [int]$TaskID
    )

    $uri = "$script:BaseUrl/api/scheduled-tasks/$TaskID/status/details"

    return (Invoke-NcentralApi -Uri $uri -Method "GET").data
}