Describe "Get-NcentralUserSelf" {
    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\Users\Get-NcentralUserSelf.ps1"
        $script:BaseUrl = "https://fake-ncentral.local"
    }

    BeforeEach {
        Mock Invoke-NcentralApi {}
    }

    It "calls Invoke-NcentralApi with the correct URI and method" {
        Get-NcentralUserSelf | Out-Null

        Assert-MockCalled Invoke-NcentralApi -Times 1 -ParameterFilter {
            $Uri -eq "https://fake-ncentral.local/api/users/me" -and
            $Method -eq "GET"
        }
    }

    It "returns the authenticated user profile" {
        Mock Invoke-NcentralApi { return @{ userId = 10; emailAddress = "user@example.com" } }

        $result = Get-NcentralUserSelf

        $result.userId | Should -Be 10
        $result.emailAddress | Should -Be "user@example.com"
    }
}
