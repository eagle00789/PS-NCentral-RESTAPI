Describe "Get-NcentralDeviceAssetsLifecycleInfo" {

    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\Devices\Get-NcentralDeviceAssetsLifecycleInfo.ps1"

        $script:BaseUrl = "https://api.test.com"
        $testDeviceId   = 12345
    }

    BeforeEach {
        Mock Invoke-NcentralApi { return @{ lifecycle = "active"; warrantyEnd = "2026-01-01" } }
    }

    Context "Parameter validation" {
        It "requires DeviceID" {
            { Get-NcentralDeviceAssetsLifecycleInfo @{} } | 
                Should -Throw -ErrorId "ParameterArgumentTransformationError,Get-NcentralDeviceAssetsLifecycleInfo"
        }

        It "accepts a valid DeviceID" {
            { Get-NcentralDeviceAssetsLifecycleInfo -DeviceID $testDeviceId } | Should -Not -Throw
        }
    }

    Context "API Call" {
        It "calls Invoke-NcentralApi with the correct URI" {
            $expectedUri = "$script:BaseUrl/api/devices/$testDeviceId/assets/lifecycle-info"

            Get-NcentralDeviceAssetsLifecycleInfo -DeviceID $testDeviceId | Out-Null

            Assert-MockCalled Invoke-NcentralApi -Times 1 -ParameterFilter {
                $Uri -eq $expectedUri -and $Method -eq "GET"
            }
        }
    }

    Context "Return behavior" {
        It "returns the raw object from the API response" {
            $result = Get-NcentralDeviceAssetsLifecycleInfo -DeviceID $testDeviceId
            $result.lifecycle   | Should -Be "active"
            $result.warrantyEnd | Should -Be "2026-01-01"
        }
    }
}
