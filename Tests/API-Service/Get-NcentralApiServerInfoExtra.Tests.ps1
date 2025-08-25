Describe "Get-NcentralApiServerInfoExtra" {
    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\API-Service\Get-NcentralApiServerInfoExtra.ps1"
        Mock Show-Warning
        Mock Invoke-NcentralApi
    }

    Context "Function behavior" {
        It "Calls Show-Warning once" {
            Get-NcentralApiServerInfoExtra
            Assert-MockCalled Show-Warning -Exactly 1 -Scope It
        }

        It "Calls Invoke-NcentralApi with correct URI and method" {
            Get-NcentralApiServerInfoExtra
            Assert-MockCalled Invoke-NcentralApi -Exactly 1 -Scope It -ParameterFilter {
                $Uri -eq "$script:BaseUrl/api/server-info/extra" -and $Method -eq "GET"
            }
        }
    }

    Context "Successful call" {
        It "Returns the .data._extra value when present" {
            $expected = @{ build = "12.3.4"; revision = "5678" }
            Mock Invoke-NcentralApi { return @{ data = @{ _extra = $expected } } }

            $result = Get-NcentralApiServerInfoExtra
            $result | Should -Be $expected
        }

        It "Returns null when .data._extra is missing" {
            Mock Invoke-NcentralApi { return @{ data = @{} } }

            $result = Get-NcentralApiServerInfoExtra
            $result | Should -BeNullOrEmpty
        }
    }

    Context "Failure handling" {
        It "Returns null when Invoke-NcentralApi returns nothing" {
            Mock Invoke-NcentralApi { return $null }

            $result = Get-NcentralApiServerInfoExtra
            $result | Should -BeNullOrEmpty
        }

        It "Throws when Invoke-NcentralApi errors" {
            Mock Invoke-NcentralApi { throw "Server error" }

            { Get-NcentralApiServerInfoExtra } | Should -Throw "Server error"
        }
    }
}
