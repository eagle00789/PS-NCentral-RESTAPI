Describe "Get-NcentralApiServerHealth" {
    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\API-Service\Get-NcentralApiServerHealth.ps1"
        Mock Invoke-NcentralApi
    }

    Context "Successful call" {
        It "Calls Invoke-NcentralApi with the correct URI and method" {
            Get-NcentralApiServerHealth
            Assert-MockCalled Invoke-NcentralApi -Exactly 1 -Scope It -ParameterFilter {
                $Uri -eq "$script:BaseUrl/api/health" -and $Method -eq "GET"
            }
        }

        It "Returns the data from Invoke-NcentralApi" {
            Mock Invoke-NcentralApi { return @{ status = "Healthy"; serverTime = "2025-08-17T12:34:56Z" } }
            $result = Get-NcentralApiServerHealth
            $result.status | Should -Be "Healthy"
            $result.serverTime | Should -Be "2025-08-17T12:34:56Z"
        }
    }

    Context "Failure handling" {
        It "Returns null when Invoke-NcentralApi returns nothing" {
            Mock Invoke-NcentralApi { return $null }
            $result = Get-NcentralApiServerHealth
            $result | Should -BeNullOrEmpty
        }

        It "Writes an error when Invoke-NcentralApi throws" {
            Mock Invoke-NcentralApi { throw "Server error" }
            { Get-NcentralApiServerHealth } | Should -Throw "Server error"
        }
    }
}
