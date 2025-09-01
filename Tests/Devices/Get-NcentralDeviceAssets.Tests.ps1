Describe "Get-NcentralDeviceAssets" {

    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\Devices\Get-NcentralDeviceAssets.ps1"

        $script:BaseUrl = "https://api.test.com"
        $testDeviceId   = 12345
    }

    BeforeEach {
        Mock Invoke-NcentralApi { return @{ data = @{ cpu = "Intel i7"; memory = "16GB" } } }
    }

    Context "Parameter validation" {
        It "requires DeviceID" {
            { Get-NcentralDeviceAssets @{} } | Should -Throw -ErrorId "ParameterArgumentTransformationError,Get-NcentralDeviceAssets"
        }

        It "accepts a long DeviceID" {
            { Get-NcentralDeviceAssets -DeviceID 9223372036854775807 } | Should -Not -Throw
        }
    }

    Context "API Call" {
        It "calls Invoke-NcentralApi with the correct URI" {
            $expectedUri = "$script:BaseUrl/api/devices/$testDeviceId/assets"

            Get-NcentralDeviceAssets -DeviceID $testDeviceId | Out-Null

            Assert-MockCalled Invoke-NcentralApi -Times 1 -ParameterFilter {
                $Uri -eq $expectedUri -and $Method -eq "GET"
            }
        }
    }

    Context "Return behavior" {
        It "returns the .data object from the API response" {
            $result = Get-NcentralDeviceAssets -DeviceID $testDeviceId
            $result | Should -Not -BeNullOrEmpty
            $result.cpu    | Should -Be "Intel i7"
            $result.memory | Should -Be "16GB"
        }

        It "returns nothing when API returns no data" {
            Mock Invoke-NcentralApi { return @{ data = $null } }

            $result = Get-NcentralDeviceAssets -DeviceID $testDeviceId
            $result | Should -BeNullOrEmpty
        }
    }
}
