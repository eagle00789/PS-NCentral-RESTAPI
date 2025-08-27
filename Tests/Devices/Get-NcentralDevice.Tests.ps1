Describe "Get-NcentralDevice" {

    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\Devices\Get-NcentralDevice.ps1"

        # Default mock of Invoke-NcentralApi
        $script:BaseUrl = "https://api.test.com"
        $testDeviceId = 12345
    }

    BeforeEach {
        Mock Invoke-NcentralApi { return @{ data = @{ id = 12345; name = "TestDevice" } } }
    }
    
    Context "Parameter validation" {
        It "requires DeviceID" {
            { Get-NcentralDevice @{} } | Should -Throw -ErrorId "ParameterArgumentTransformationError,Get-NcentralDevice"
        }

        It "accepts a long DeviceID" {
            { Get-NcentralDevice -DeviceID 9223372036854775807 } | Should -Not -Throw
        }
    }

    Context "API Call" {
        It "calls Invoke-NcentralApi with the correct URI" {
            $expectedUri = "$script:BaseUrl/api/devices/$testDeviceId"

            Get-NcentralDevice -DeviceID $testDeviceId | Out-Null

            Assert-MockCalled Invoke-NcentralApi -Times 1 -ParameterFilter {
                $Uri -eq $expectedUri -and $Method -eq "GET"
            }
        }
    }

    Context "Return behavior" {
        It "returns the .data object from the API response" {
            $result = Get-NcentralDevice -DeviceID $testDeviceId
            $result | Should -Not -BeNullOrEmpty
            $result.id   | Should -Be 12345
            $result.name | Should -Be "TestDevice"
        }

        It "returns nothing when API returns no data" {
            Mock Invoke-NcentralApi { return @{ data = $null } }

            $result = Get-NcentralDevice -DeviceID $testDeviceId
            $result | Should -BeNullOrEmpty
        }
    }
}