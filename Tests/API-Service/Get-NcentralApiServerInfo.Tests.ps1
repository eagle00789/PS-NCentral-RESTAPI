Describe "Get-NcentralApiServerInfo" {
    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\API-Service\Get-NcentralApiServerInfo.ps1"
    }

    Context "Environment validation" {
        It "Returns $null if script:BaseUrl is not set" {
            $script:BaseUrl = $null
            Mock Invoke-NcentralApi { return $null }
            $result = Get-NcentralApiServerInfo
            $result | Should -BeNullOrEmpty
        }
    }

    Context "Successful retrieval" {
        BeforeEach {
            $script:BaseUrl = "https://ncentral.example.com"
            Mock Invoke-NcentralApi {
                return @{ serverName = "MockServer"; version = "1.2.3" }
            }
        }

        It "Returns server info from API" {
            $result = Get-NcentralApiServerInfo
            $result.serverName | Should -Be "MockServer"
            $result.version    | Should -Be "1.2.3"
        }

        It "Calls Invoke-NcentralApi with correct URI and method" {
            Get-NcentralApiServerInfo | Out-Null
            Assert-MockCalled Invoke-NcentralApi -ParameterFilter {
                $Uri   -eq "https://ncentral.example.com/api/server-info" -and
                $Method -eq "GET"
            } -Times 1
        }
    }

    Context "API error handling" {
        BeforeEach {
            $script:BaseUrl = "https://ncentral.example.com"
            Mock Invoke-NcentralApi { return $null }
        }

        It "Returns $null when API call fails" {
            $result = Get-NcentralApiServerInfo
            $result | Should -BeNullOrEmpty
        }
    }
}