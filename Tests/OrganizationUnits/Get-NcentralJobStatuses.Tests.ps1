Describe "Get-NcentralJobStatuses" {
    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\OrganizationUnits\Get-NcentralJobStatuses.ps1"
        $script:BaseUrl = "https://api.test.com"
    }

    BeforeEach {
        Mock Invoke-NcentralApi {}
    }

    It "requires OrganizationUnitID" {
        { Get-NcentralJobStatuses -OrganizationUnitID $null } | Should -Throw
    }

    It "calls Invoke-NcentralApi with the correct Uri and Method" {
        Get-NcentralJobStatuses -OrganizationUnitID 50 | Out-Null

        Assert-MockCalled Invoke-NcentralApi -Times 1 -ParameterFilter {
            $Uri -eq "https://api.test.com/api/org-units/50/job-statuses" -and
            $Method -eq "GET"
        }
    }

    It "returns the .data portion of the response" {
        Mock Invoke-NcentralApi { return @{ data = @("Queued", "Completed") } }

        $result = Get-NcentralJobStatuses -OrganizationUnitID 50

        $result | Should -Contain "Queued"
        $result | Should -Contain "Completed"
    }
}
