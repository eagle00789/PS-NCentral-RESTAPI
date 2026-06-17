function New-NcentralDirectScheduledTask {
<#
.SYNOPSIS
Create a direct support scheduled task

.DESCRIPTION
This function creates a direct support scheduled task against a specific device

.PARAMETER Body
Required. The request body matching DirectSupportTask in the API Explorer.

.EXAMPLE
New-NcentralDirectScheduledTask -Body @{ deviceId = 12345; taskId = 100 }

This example creates a direct support scheduled task

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [hashtable]$Body
    )

    $uri = "$script:BaseUrl/api/scheduled-tasks/direct"
    return Invoke-NcentralApi -Uri $uri -Method "POST" -Body $Body
}
