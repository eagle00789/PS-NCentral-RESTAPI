Describe "Get-NcentralAuthenticationRefresh" {
    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\Authentication\Get-NcentralAuthenticationRefresh.ps1"

        $script:BaseUrl      = "https://fake-ncentral.test"
        $script:RefreshToken = "fake-refresh-token"
    }


    Context "Calls Invoke-NcentralApi with the correct parameters" {
        BeforeEach {
            # Reset tokens before each test
            $script:AccessToken  = $null
            $script:RefreshToken = "fake-refresh-token"

            # Mock the API call
            Mock Invoke-NcentralApi {
                Write-Host "Mock called with: Uri=$Uri Method=$Method Body=$Body ConvertToJson=$ConvertToJson"
                return @{
                    tokens = @{
                        access  = @{ token = "access-token" }
                        refresh = @{ token = "refresh-token" }
                    }
                }
            }
        }

        It "calls Invoke-NcentralApi with the expected arguments" {
            Get-NcentralAuthenticationRefresh

            Should -Invoke Invoke-NcentralApi -Times 1 -Exactly -ParameterFilter {
                $Uri -eq "https://fake-ncentral.test/api/auth/refresh" -and
                $Method -eq "POST" -and
                $Body -eq "fake-refresh-token" -and
                $Headers.Count -eq 0 -and
                -not $ConvertToJson
            }
        }

        It "passes expiry override headers when provided" {
            Get-NcentralAuthenticationRefresh -AccessExpiryOverride "30m" -RefreshExpiryOverride "7d"

            Should -Invoke Invoke-NcentralApi -Times 1 -Exactly -ParameterFilter {
                $Headers["X-ACCESS-EXPIRY-OVERRIDE"] -eq "30m" -and
                $Headers["X-REFRESH-EXPIRY-OVERRIDE"] -eq "7d"
            }
        }

        It "updates the script tokens correctly" {
            Get-NcentralAuthenticationRefresh

            $script:AccessToken  | Should -Be "access-token"
            $script:RefreshToken | Should -Be "refresh-token"
        }

        It "writes an informational message after refreshing tokens" {
            $info = & {
                Get-NcentralAuthenticationRefresh -InformationAction Continue
            } 6>&1 | Out-String

            $info | Should -Match "successfully refreshed"
        }

        It "does not replace tokens when the refresh response is incomplete" {
            $script:AccessToken = "existing-access-token"
            $script:RefreshToken = "existing-refresh-token"
            Mock Invoke-NcentralApi {
                return @{ tokens = @{ access = @{ token = $null }; refresh = @{ token = $null } } }
            }

            { Get-NcentralAuthenticationRefresh } | Should -Throw "*did not contain access and refresh tokens*"
            $script:AccessToken | Should -Be "existing-access-token"
            $script:RefreshToken | Should -Be "existing-refresh-token"
        }
    }
}
