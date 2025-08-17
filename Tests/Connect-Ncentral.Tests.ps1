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
            # Reset script variables
            Remove-Variable -Name BaseUrl -Scope Script -ErrorAction SilentlyContinue
            Remove-Variable -Name AccessToken -Scope Script -ErrorAction SilentlyContinue
            Remove-Variable -Name RefreshToken -Scope Script -ErrorAction SilentlyContinue
            Remove-Variable -Name Connected -Scope Script -ErrorAction SilentlyContinue

            # Mock the REST call to return expected token structure
            Mock Invoke-RestMethod {
                return @{
                    tokens = @{
                        access  = @{ token = "access123" }
                        refresh = @{ token = "refresh123" }
                    }
                }
            }

            # Mock server info call
            Mock Get-NcentralApiServerInfo { return @{ ncentral = "2025.1" } }
        }

        It "Sets script variables correctly" {
            $null = Connect-Ncentral -JwtToken "abc123" -BaseUrl "ncentral.example.com"

            $script:BaseUrl      | Should -Be "https://ncentral.example.com"
            $script:AccessToken  | Should -Be "access123"
            $script:RefreshToken | Should -Be "refresh123"
            $script:Connected    | Should -BeTrue
        }

        It "Normalizes BaseUrl to https and removes trailing slash" {
            $null = Connect-Ncentral -JwtToken "abc123" -BaseUrl "http://ncentral.example.com/"
            $script:BaseUrl | Should -Be "https://ncentral.example.com"
        }

        It "Calls Invoke-RestMethod with correct parameters" {
            $null = Connect-Ncentral -JwtToken "abc123" -BaseUrl "ncentral.example.com"
            Assert-MockCalled Invoke-RestMethod -ParameterFilter {
                $Uri   -eq "https://ncentral.example.com/api/auth/authenticate" -and
                $Method -eq "Post" -and
                $Headers["Authorization"] -eq "Bearer abc123"
            } -Times 1
        }

        It "Calls Get-NcentralApiServerInfo once" {
            $null = Connect-Ncentral -JwtToken "abc123" -BaseUrl "ncentral.example.com"
            Assert-MockCalled Get-NcentralApiServerInfo -Times 1
        }
    }
}
