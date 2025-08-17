function New-NcentralMaintenanceWindow {
<#
.SYNOPSIS
Get a list of all maintenance windows for a specified DeviceID

.DESCRIPTION
This function gets a list of all maintenance windows for a specified DeviceID

.PARAMETER DeviceID
Required. The DeviceID.

.EXAMPLE
Get-NcentralMaintenanceWindows -DeviceID 12345679

This example fetches all maintenance windows for the device with ID 13245679

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int]$DeviceID
    )

    Show-Warning

    $body = @{
        deviceIDs = @($DeviceID)
        maintenanceWindows = @(
            @{
                applicableAction = @(
                    @{
                    }
                )
                name = "Test Maintenance Window"
                type = "downtime"
                cron = "0 0 0 ? 2 1,4 *"
                duration = 60
                enabled = $false
                maxDowntime = 0
                rebootMethod = "allowUserToPostpone"
                rebootDelay = 0
                downtimeOnAction = $false
                userMessageEnabled = $false
                userMessage = $null
                messageSenderEnabled = $false
                messageSender = $null
                preserveStateEnabled = $false
                scheduleId = Get-Random -Minimum 100000 -Maximum 9999999999
            }
        )
    }

    $uri = "$script:BaseUrl/api/devices/maintenance-windows"

    return Invoke-NcentralApi -Uri $uri -Method "POST" -Body $Body
}