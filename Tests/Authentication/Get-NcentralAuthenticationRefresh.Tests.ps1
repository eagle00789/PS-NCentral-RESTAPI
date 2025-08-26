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
                -not $ConvertToJson
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
    }
}