Describe "Authentication additions" {
    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\Authentication\Invoke-NcentralAuthenticationLogout.ps1"
        . "$PSScriptRoot\..\..\Authentication\Connect-NcentralSso.ps1"
        . "$PSScriptRoot\..\..\Authentication\Disconnect-Ncentral.ps1"
        . "$PSScriptRoot\..\..\API-Service\Get-NcentralApiServerInfo.ps1"
    }

    It "Invoke-NcentralAuthenticationLogout calls the logout endpoint and disconnects" {
        $script:BaseUrl = "https://server"
        $script:AccessToken = "token"
        $script:RefreshToken = "refresh"
        $script:Connected = $true
        Mock Invoke-NcentralApi { return @{ success = $true } }

        $result = Invoke-NcentralAuthenticationLogout

        $result.success | Should -BeTrue
        Assert-MockCalled Invoke-NcentralApi -Times 1 -ParameterFilter {
            $Uri -eq "https://server/api/auth/logout" -and $Method -eq "POST"
        }
        $script:Connected | Should -BeFalse
    }

    It "Connect-NcentralSso authenticates using the SSO endpoint" {
        Mock Invoke-RestMethod {
            return @{
                tokens = @{
                    access = @{ token = "access123" }
                    refresh = @{ token = "refresh123" }
                }
            }
        }
        Mock Get-NcentralApiServerInfo { return @{ ncentral = "2026.1" } }

        $null = Connect-NcentralSso -SsoToken "sso-token" -BaseUrl "ncentral.example.com"

        $script:BaseUrl | Should -Be "https://ncentral.example.com"
        $script:AccessToken | Should -Be "access123"
        Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter {
            $Uri -eq "https://ncentral.example.com/api/auth/sso" -and
            $Method -eq "Post" -and
            $Headers["Authorization"] -eq "Bearer sso-token"
        }
    }
}
