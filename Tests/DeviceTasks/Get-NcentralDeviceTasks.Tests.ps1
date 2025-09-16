Describe "Get-NcentralDeviceTasks" {
    $testDeviceId = 1954813854
    $baseUrl      = "https://api.test.com"

    BeforeAll {
        . "$PSScriptRoot\..\..\DeviceTasks\Get-NcentralDeviceTasks.ps1"
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        $script:BaseUrl = $baseUrl
        $testDeviceId = 1954813854
    }

    Context "Return behavior" {
        BeforeEach {
            Mock Invoke-NcentralApi -MockWith {
                [pscustomobject]@{
                    data = @(
                        [pscustomobject]@{ id = 1; name = "TestTask" }
                    )
                }
            }
        }

        It "returns the .data object from the API response" {
            $result = Get-NcentralDeviceTasks -DeviceID $testDeviceId
            $result | Should -Not -BeNullOrEmpty
            $result[0].id   | Should -Be 1
            $result[0].name | Should -Be "TestTask"
        }
    }

    Context "Request building" {
        BeforeEach {
            Mock Invoke-NcentralApi -MockWith {
                @{ data = @() }
            }
        }

        It "calls the correct endpoint with the given DeviceID" {
            $null = Get-NcentralDeviceTasks -DeviceID $testDeviceId

            Assert-MockCalled Invoke-NcentralApi -Exactly 1 -ParameterFilter {
                $Uri -eq "$baseUrl/api/devices/$testDeviceId/scheduled-tasks" -and
                $Method -eq "GET"
            }
        }
    }

    Context "Edge cases" {
        It "returns empty when API response contains no data" {
            Mock Invoke-NcentralApi -MockWith { @{ data = @() } }

            $result = Get-NcentralDeviceTasks -DeviceID $testDeviceId
            $result | Should -BeNullOrEmpty
        }

        It "handles multiple tasks returned from the API" {
            Mock Invoke-NcentralApi -MockWith {
                @{ data = @(
                    @{ id = 1; name = "TaskOne" }
                    @{ id = 2; name = "TaskTwo" }
                ) }
            }

            $result = Get-NcentralDeviceTasks -DeviceID $testDeviceId
            $result.Count    | Should -Be 2
            $result[0].name  | Should -Be "TaskOne"
            $result[1].id    | Should -Be 2
        }
    }
}
