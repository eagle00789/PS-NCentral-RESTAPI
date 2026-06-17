Describe "Get-NcentralOrganizationUnits" {
    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\OrganizationUnits\Get-NcentralOrganizationUnits.ps1"
        $script:BaseUrl = "https://api.test.com"
    }

    Context "Paged mode" {
        It "returns the .data portion of the response" {
            Mock Invoke-NcentralApi {
                @{
                    data = @(
                        @{ orgUnitId = 1; orgUnitName = "Org 1" },
                        @{ orgUnitId = 2; orgUnitName = "Org 2" }
                    )
                    totalPages = 1
                }
            }

            $result = Get-NcentralOrganizationUnits

            $result.orgUnitId | Should -Contain 1
            $result.orgUnitId | Should -Contain 2
        }

        It "includes SortBy and SortOrder in the URI if provided" {
            $script:calledUri = $null
            Mock Invoke-NcentralApi {
                $script:calledUri = $Uri
                @{ data = @(@{ orgUnitId = 1 }); totalPages = 1 }
            }

            $null = Get-NcentralOrganizationUnits -SortBy orgUnitName -SortOrder Asc

            $script:calledUri | Should -Be "https://api.test.com/api/org-units?pageNumber=1&pageSize=50&sortOrder=asc&sortBy=orgUnitName"
        }
    }

    Context "All mode" {
        It "retrieves and combines multiple pages" {
            Mock Invoke-NcentralApi {
                if ($Uri -match "pageNumber=1") {
                    @{
                        data = @(@{ orgUnitId = 1 })
                        totalPages = 2
                    }
                }
                else {
                    @{
                        data = @(@{ orgUnitId = 2 })
                        totalPages = 2
                    }
                }
            }

            $result = Get-NcentralOrganizationUnits -All

            $result.orgUnitId | Should -Contain 1
            $result.orgUnitId | Should -Contain 2
        }
    }
}
