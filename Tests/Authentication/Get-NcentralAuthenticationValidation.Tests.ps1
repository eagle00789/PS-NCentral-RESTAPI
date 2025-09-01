Describe "Get-NcentralAuthenticationValidation" {
    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\Authentication\Get-NcentralAuthenticationValidation.ps1"

        $script:BaseUrl = "https://api.test.com"
    }

    BeforeEach {
        Mock Invoke-NcentralApi { return @{ message = "Token is valid" } }
    }

    Context "Parameter validation" {
        It "does not accept unexpected parameters" {
            { Get-NcentralAuthenticationValidation -BadParam "oops" } | Should -Throw
        }

        It "can be called without parameters" {
            { Get-NcentralAuthenticationValidation } | Should -Not -Throw
        }
    }

    Context "API Call" {
        It "calls Invoke-NcentralApi with the correct URI and method" {
            $expectedUri = "$script:BaseUrl/api/auth/validate"

            Get-NcentralAuthenticationValidation | Out-Null

            Assert-MockCalled Invoke-NcentralApi -Times 1 -ParameterFilter {
                $Uri -eq $expectedUri -and $Method -eq "GET"
            }
        }
    }

    Context "Return behavior" {
        It "returns the .message from the API response" {
            $result = Get-NcentralAuthenticationValidation
            $result | Should -Be "Token is valid"
        }

        It "returns nothing when API returns no message" {
            Mock Invoke-NcentralApi { return @{ message = $null } }

            $result = Get-NcentralAuthenticationValidation
            $result | Should -BeNullOrEmpty
        }
    }
}
