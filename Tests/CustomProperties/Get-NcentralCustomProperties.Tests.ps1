Describe "Get-NcentralCustomProperties" {
    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\CustomProperties\Get-NcentralCustomProperties.ps1"

        $script:BaseUrl = "https://api.test.com"
        $orgUnitId = 50
        $propertyId = 1234
    }

    BeforeEach {
        Mock Invoke-NcentralApi { return @{ data = @( @{ id = 1; name = "Prop1" }, @{ id = 2; name = "Prop2" } ) } }
        Mock Show-Warning {}
    }

    Context "Parameter validation" {
        It "defaults OrgUnitId to 50, PageNumber to 1, PageSize to 50" {
            Get-NcentralCustomProperties | Out-Null

            Assert-MockCalled Invoke-NcentralApi -ParameterFilter {
                $Uri -like "*org-units/50/custom-properties?pageNumber=1&pageSize=50"
            }
        }

        It "accepts OrgUnitId override" {
            Get-NcentralCustomProperties -OrgUnitId 99 | Out-Null

            Assert-MockCalled Invoke-NcentralApi -ParameterFilter {
                $Uri -like "*org-units/99/custom-properties?pageNumber=1&pageSize=50"
            }
        }

        It "accepts PropertyId and switches to 'Single' parameter set" {
            Get-NcentralCustomProperties -OrgUnitId $orgUnitId -PropertyId $propertyId | Out-Null

            Assert-MockCalled Invoke-NcentralApi -ParameterFilter {
                $Uri -eq "$script:BaseUrl/api/org-units/$orgUnitId/custom-properties/$propertyId"
            }
        }
    }

    Context "API Call" {
        It "calls Invoke-NcentralApi with the correct URI and method for Multi" {
            $expectedUri = "$script:BaseUrl/api/org-units/$orgUnitId/custom-properties?pageNumber=2&pageSize=25"

            Get-NcentralCustomProperties -OrgUnitId $orgUnitId -PageNumber 2 -PageSize 25 | Out-Null

            Assert-MockCalled Invoke-NcentralApi -Times 1 -ParameterFilter {
                $Uri -eq $expectedUri -and $Method -eq "GET"
            }
        }

        It "calls Invoke-NcentralApi with the correct URI for Single" {
            $expectedUri = "$script:BaseUrl/api/org-units/$orgUnitId/custom-properties/$propertyId"

            Get-NcentralCustomProperties -OrgUnitId $orgUnitId -PropertyId $propertyId | Out-Null

            Assert-MockCalled Invoke-NcentralApi -Times 1 -ParameterFilter {
                $Uri -eq $expectedUri -and $Method -eq "GET"
            }
        }
    }

    Context "Return behavior" {
        It "returns the .data collection for Multi mode" {
            $result = Get-NcentralCustomProperties -OrgUnitId $orgUnitId
            $result | Should -Not -BeNullOrEmpty
            $result.Count | Should -Be 2
            $result[0].id | Should -Be 1
            $result[1].name | Should -Be "Prop2"
        }

        It "returns the full object for Single mode" {
            Mock Invoke-NcentralApi { return @{ id = 1234; name = "TestProperty" } }

            $result = Get-NcentralCustomProperties -OrgUnitId $orgUnitId -PropertyId $propertyId
            $result.id   | Should -Be 1234
            $result.name | Should -Be "TestProperty"
        }

        It "returns nothing when API returns no data" {
            Mock Invoke-NcentralApi { return @{ data = $null } }

            $result = Get-NcentralCustomProperties -OrgUnitId $orgUnitId
            $result | Should -BeNullOrEmpty
        }
    }

    Context "Warnings" {
        It "calls Show-Warning once per invocation" {
            Get-NcentralCustomProperties -OrgUnitId $orgUnitId | Out-Null
            Assert-MockCalled Show-Warning -Times 1
        }
    }
}
