Describe "Get-NcentralServerTime" {
    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\API-Service\Get-NcentralServerTime.ps1"
        $script:BaseUrl = "https://ncentral.example.com"
    }

    BeforeEach {
        Mock Invoke-NcentralApi {}
    }

    It "calls Invoke-NcentralApi with the correct URI and method" {
        Get-NcentralServerTime | Out-Null

        Assert-MockCalled Invoke-NcentralApi -Times 1 -ParameterFilter {
            $Uri -eq "https://ncentral.example.com/api/server-info/time" -and
            $Method -eq "GET"
        }
    }

    It "returns server time info from API" {
        Mock Invoke-NcentralApi {
            return @{
                serverTime = "2026-02-26T21:15:30+01:00"
                timezone = "Europe/Amsterdam"
                utcOffset = "+01:00"
            }
        }

        $result = Get-NcentralServerTime

        $result.serverTime | Should -Be "2026-02-26T21:15:30+01:00"
        $result.timezone | Should -Be "Europe/Amsterdam"
        $result.utcOffset | Should -Be "+01:00"
    }
}
