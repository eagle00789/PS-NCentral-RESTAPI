Describe "Connect-Ncentral" {
    BeforeAll {
        . "$PSScriptRoot\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\Authentication\Connect-Ncentral.ps1"
        . "$PSScriptRoot\..\API-Service\Get-NcentralApiServerInfo.ps1"
    }

    Context "Parameter validation" {
        It "Throws when JwtToken is null" {
            { Connect-Ncentral -JwtToken $null -BaseUrl "ncentral.example.com" } | Should -Throw
        }

        It "Throws when BaseUrl is null" {
            { Connect-Ncentral -JwtToken "abc123" -BaseUrl $null } | Should -Throw
        }

        It "Throws when BaseUrl is empty" {
            { Connect-Ncentral -JwtToken "abc123" -BaseUrl "" } | Should -Throw
        }
    }

    Context "Successful connection" {
        BeforeEach {
            Remove-Variable -Name BaseUrl -Scope Script -ErrorAction SilentlyContinue
            Remove-Variable -Name JwtToken -Scope Script -ErrorAction SilentlyContinue

            # Return a value consistent with what the script expects
            Mock Invoke-RestMethod { return @{ success = $true } }
        }

        It "Returns $true and sets script variables" {
            $result = Connect-Ncentral -JwtToken "abc123" -BaseUrl "ncentral.example.com"
            $result | Should -BeTrue
            $script:BaseUrl  | Should -Be "https://ncentral.example.com"
            $script:JwtToken | Should -Be "abc123"
        }

        It "Normalizes BaseUrl to include https and no trailing slash" {
            Connect-Ncentral -JwtToken "abc123" -BaseUrl "http://ncentral.example.com/" | Out-Null
            $script:BaseUrl | Should -Be "https://ncentral.example.com"
        }

        It "Calls Invoke-RestMethod with correct parameters" {
            Connect-Ncentral -JwtToken "abc123" -BaseUrl "ncentral.example.com" | Out-Null
            Assert-MockCalled Invoke-RestMethod -ParameterFilter {
                $Uri   -eq "https://ncentral.example.com/api/auth/authenticate" -and
                $Method -eq "Post" -and
                $Headers["Authorization"] -eq "Bearer abc123"
            } -Times 1
        }
    }

    Context "Failed connection" {
        BeforeEach {
            # Reset script variables before each test
            Remove-Variable -Name BaseUrl -Scope Script -ErrorAction SilentlyContinue
            Remove-Variable -Name JwtToken -Scope Script -ErrorAction SilentlyContinue

            Mock Invoke-RestMethod { throw "Auth failed" }
        }

        It "Returns $false when Invoke-RestMethod fails" {
            $result = Connect-Ncentral -JwtToken "abc123" -BaseUrl "ncentral.example.com"
            $result | Should -BeFalse
        }

        It "Does not set script variables when connection fails" {
            Connect-Ncentral -JwtToken "abc123" -BaseUrl "ncentral.example.com" | Out-Null
            $script:BaseUrl  | Should -BeNullOrEmpty
            $script:JwtToken | Should -BeNullOrEmpty
        }
    }
}
