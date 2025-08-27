Describe "Get-NcentralCustomProperties" {
    BeforeEach {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\CustomProperties\Get-NcentralCustomProperties.ps1"
        Mock Show-Warning {}
        Mock Invoke-NcentralApi { return @{ data = @("prop1","prop2") } }
    }

    Context "Multi mode" {
        It "Calls Invoke-NcentralApi with correct URI and parameters" {
            $result = Get-NcentralCustomProperties -OrgUnitId 123 -PageNumber 2 -PageSize 10
            $result | Should -Be @("prop1","prop2")

            Should -Invoke Invoke-NcentralApi -Times 1 -ParameterFilter {
                $Uri -eq "$script:BaseUrl/api/org-units/123/custom-properties?pageNumber=2&pageSize=10" -and
                $Method -eq "GET"
            }
        }

        It "Defaults to OrgUnitId=50, PageNumber=1, PageSize=50" {
            $null = Get-NcentralCustomProperties
            Should -Invoke Invoke-NcentralApi -Times 1 -ParameterFilter {
                $Uri -eq "$script:BaseUrl/api/org-units/50/custom-properties?pageNumber=1&pageSize=50"
            }
        }
    }

    Context "Single mode" {
        BeforeEach {
            Mock Invoke-NcentralApi { return @{ id = 999; value = "custom-prop" } }
        }

        It "Calls Invoke-NcentralApi with correct URI when PropertyId is provided" {
            $result = Get-NcentralCustomProperties -OrgUnitId 456 -PropertyId 789
            $result.id   | Should -Be 999
            $result.value | Should -Be "custom-prop"

            Should -Invoke Invoke-NcentralApi -Times 1 -ParameterFilter {
                $Uri -eq "$script:BaseUrl/api/org-units/456/custom-properties/789" -and
                $Method -eq "GET"
            }
        }
    }
}