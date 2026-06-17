Describe "Get-NcentralOrganizationUnit" {
    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\OrganizationUnits\Get-NcentralOrganizationUnit.ps1"
        $script:BaseUrl = "https://api.test.com"
    }

    BeforeEach {
        Mock Invoke-NcentralApi {}
    }

    It "requires OrganizationUnitID" {
        { Get-NcentralOrganizationUnit @{} } | Should -Throw
    }

    It "calls Invoke-NcentralApi with the correct Uri and Method" {
        Get-NcentralOrganizationUnit -OrganizationUnitID 50 | Out-Null

        Assert-MockCalled Invoke-NcentralApi -Times 1 -ParameterFilter {
            $Uri -eq "https://api.test.com/api/org-units/50" -and
            $Method -eq "GET"
        }
    }

    It "returns the API response" {
        Mock Invoke-NcentralApi { return @{ orgUnitId = 50; orgUnitName = "Main Org" } }

        $result = Get-NcentralOrganizationUnit -OrganizationUnitID 50

        $result.orgUnitId | Should -Be 50
        $result.orgUnitName | Should -Be "Main Org"
    }
}
