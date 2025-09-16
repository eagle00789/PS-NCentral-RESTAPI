Describe "Get-NcentralDeviceServiceMonitorStatus" {
    BeforeAll {
            . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
            . "$PSScriptRoot\..\..\Devices\Get-NcentralDeviceServiceMonitorStatus.ps1"

        $testDeviceId = 12345

        Mock Invoke-NcentralApi {
            return @{
                data = @(
                    @{ id = 1; name = "CPU Monitor"; status = "OK" }
                    @{ id = 2; name = "Memory Monitor"; status = "Warning" }
                )
            }
        }
    }

    It "calls the correct endpoint with the provided DeviceID" {
        Get-NcentralDeviceServiceMonitorStatus -DeviceID $testDeviceId | Out-Null

        Assert-MockCalled Invoke-NcentralApi -Exactly 1 -ParameterFilter {
            $Uri -eq "$script:BaseUrl/api/devices/$testDeviceId/service-monitor-status" -and
            $Method -eq "GET"
        }
    }

    It "returns the .data portion of the response" {
        $result = Get-NcentralDeviceServiceMonitorStatus -DeviceID $testDeviceId

        $result | Should -Not -BeNullOrEmpty
        $result[0].id | Should -Be 1
        $result[0].name | Should -Be "CPU Monitor"
        $result[0].status | Should -Be "OK"
        $result[1].id | Should -Be 2
        $result[1].name | Should -Be "Memory Monitor"
        $result[1].status | Should -Be "Warning"
    }
}
