Describe "Get-NcentralDeviceActivationKey" {

    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\Devices\Get-NcentralDeviceActivationKey.ps1"

        $script:BaseUrl = "https://api.test.com"
        $testDeviceId   = 12345
    }

    BeforeEach {
        Mock Invoke-NcentralApi { return @{ data = @{ key = "ABC-123-XYZ" } } }
    }

    Context "Parameter validation" {
        It "requires DeviceID" {
            { Get-NcentralDeviceActivationKey @{} } | Should -Throw -ErrorId "ParameterArgumentTransformationError,Get-NcentralDeviceActivationKey"
        }

        It "accepts a long DeviceID" {
            { Get-NcentralDeviceActivationKey -DeviceID 9223372036854775807 } | Should -Not -Throw
        }
    }

    Context "API Call" {
        It "calls Invoke-NcentralApi with the correct URI" {
            $expectedUri = "$script:BaseUrl/api/devices/$testDeviceId/activation-key"

            Get-NcentralDeviceActivationKey -DeviceID $testDeviceId | Out-Null

            Assert-MockCalled Invoke-NcentralApi -Times 1 -ParameterFilter {
                $Uri -eq $expectedUri -and $Method -eq "GET"
            }
        }
    }

    Context "Return behavior" {
        It "returns the .data object from the API response" {
            $result = Get-NcentralDeviceActivationKey -DeviceID $testDeviceId
            $result | Should -Not -BeNullOrEmpty
            $result.key | Should -Be "ABC-123-XYZ"
        }

        It "returns nothing when API returns no data" {
            Mock Invoke-NcentralApi { return @{ data = $null } }

            $result = Get-NcentralDeviceActivationKey -DeviceID $testDeviceId
            $result | Should -BeNullOrEmpty
        }
    }
}
