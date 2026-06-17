Describe "API-Service additions" {
    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\API-Service\Get-NcentralApiServerInfoExtraAuthenticated.ps1"
        $script:BaseUrl = "https://server"
    }

    It "Get-NcentralApiServerInfoExtraAuthenticated posts to the authenticated extra endpoint" {
        Mock Invoke-NcentralApi { return @{ version = "1.0" } }

        $result = Get-NcentralApiServerInfoExtraAuthenticated -Body @{ username = "user" }

        $result.version | Should -Be "1.0"
        Assert-MockCalled Invoke-NcentralApi -Times 1 -ParameterFilter {
            $Uri -eq "https://server/api/server-info/extra/authenticated" -and
            $Method -eq "POST" -and
            $Body.username -eq "user"
        }
    }
}
