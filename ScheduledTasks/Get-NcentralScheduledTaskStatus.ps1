function Get-NcentralScheduledTaskStatus {
<#
.SYNOPSIS
Get the aggregated information about a scheduled task for a given TaskID

.DESCRIPTION
This function gets the aggregated information about a scheduled task for a given TaskID

.PARAMETER TaskID
Required. The TaskID.

.EXAMPLE
Get-NcentralScheduledTaskStatus -TaskID 95748585

This example fetches the task information with TaskID 95748585

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $True)]
        [int]$TaskID
    )

    $uri = "$script:BaseUrl/api/scheduled-tasks/$TaskID/status"

    return (Invoke-NcentralApi -Uri $uri -Method "GET").data
}