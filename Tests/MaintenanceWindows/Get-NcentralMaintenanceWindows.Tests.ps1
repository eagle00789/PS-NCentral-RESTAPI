Describe "Get-NcentralMaintenanceWindows" {
    BeforeAll {
        . "$PSScriptRoot\..\..\MaintenanceWindows\Get-NcentralMaintenanceWindows.ps1"
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        $script:BaseUrl = "https://api.test.com"
    }

    Context "Return behavior" {
        It "returns the .data object from the API response" {
            Mock Invoke-NcentralApi {
                [pscustomobject]@{
                    data = @(
                        @{ id = 1; name = "Window A" }
                        @{ id = 2; name = "Window B" }
                    )
                }
            }

            $result = Get-NcentralMaintenanceWindows -DeviceID 12345

            $result | Should -Not -BeNullOrEmpty
            $result[0].id | Should -Be 1
            $result[1].id | Should -Be 2
        }
    }

    Context "Uri building" {
        It "calls the correct endpoint for the given DeviceID" {
            Mock Invoke-NcentralApi {}

            $deviceId = 999
            Get-NcentralMaintenanceWindows -DeviceID $deviceId

            Assert-MockCalled Invoke-NcentralApi -Exactly 1 -ParameterFilter {
                $Uri -eq "$script:BaseUrl/api/devices/$deviceId/maintenance-windows" -and
                $Method -eq "GET"
            }
        }
    }
}
