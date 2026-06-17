Describe "Remove-NcentralDevice" {
    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\Devices\Remove-NcentralDevice.ps1"
        $script:BaseUrl = "https://fake-ncentral.local"
    }

    BeforeEach {
        Mock Invoke-NcentralApi { @{ success = $true } }
    }

    It "calls Invoke-NcentralApi with the correct URI and method" {
        Remove-NcentralDevice -DeviceID 123 -Confirm:$false | Out-Null

        Assert-MockCalled Invoke-NcentralApi -Times 1 -ParameterFilter {
            $Uri -eq "https://fake-ncentral.local/api/devices/123" -and
            $Method -eq "DELETE"
        }
    }

    It "passes removeAgents when specified" {
        Remove-NcentralDevice -DeviceID 123 -RemoveAgents $true -Confirm:$false | Out-Null

        Assert-MockCalled Invoke-NcentralApi -Times 1 -ParameterFilter {
            $Query.removeAgents -eq $true
        }
    }
}
