Describe "Disconnect-Ncentral" {
    BeforeAll {
        . "$PSScriptRoot\..\..\Authentication\Disconnect-Ncentral.ps1"
    }

    Context "When called" {
        BeforeEach {
            # Set dummy values before disconnect
            $script:AccessToken  = "dummyAccess"
            $script:RefreshToken = "dummyRefresh"
            $script:Connected    = $true
        }

        It "Clears the access token" {
            Disconnect-Ncentral
            $script:AccessToken | Should -BeNullOrEmpty
        }

        It "Clears the refresh token" {
            Disconnect-Ncentral
            $script:RefreshToken | Should -BeNullOrEmpty
        }

        It "Sets Connected to `$false" {
            Disconnect-Ncentral
            $script:Connected | Should -BeFalse
        }

        It "Is idempotent (can be called twice safely)" {
            Disconnect-Ncentral
            Disconnect-Ncentral
            $script:AccessToken  | Should -BeNullOrEmpty
            $script:RefreshToken | Should -BeNullOrEmpty
            $script:Connected    | Should -BeFalse
        }
    }
}