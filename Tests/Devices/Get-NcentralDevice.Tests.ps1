Describe "Get-NcentralDevice" {

    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\Devices\Get-NcentralDevice.ps1"

        $script:BaseUrl = "https://api.test.com"
    }

    BeforeEach {
        Mock Invoke-NcentralApi {}
    }

    Context "Parameter validation" {
        It "requires DeviceID" {
            { Get-NcentralDevice @{} } | Should -Throw
        }

        It "accepts large DeviceID values without error" {
            { Get-NcentralDevice -DeviceID 9223372036854775807 } | Should -Not -Throw
        }
    }

    Context "API call" {
        It "calls Invoke-NcentralApi with the correct Uri and Method" {
            $expectedUri = "$script:BaseUrl/api/devices/12345"

            Get-NcentralDevice -DeviceID 12345 | Out-Null

            Assert-MockCalled Invoke-NcentralApi -Times 1 -ParameterFilter {
                $Uri -eq $expectedUri -and $Method -eq "GET"
            }
        }
    }

    Context "Return behavior" {
        It "returns .data from the API response" {
            Mock Invoke-NcentralApi { return @{ data = @{ id = 12345; name = "Device A" } } }

            $result = Get-NcentralDevice -DeviceID 12345

            $result.id   | Should -Be 12345
            $result.name | Should -Be "Device A"
        }

        It "returns nothing if API returns null data" {
            Mock Invoke-NcentralApi { return @{ data = $null } }

            $result = Get-NcentralDevice -DeviceID 12345

            $result | Should -BeNullOrEmpty
        }
    }
}
