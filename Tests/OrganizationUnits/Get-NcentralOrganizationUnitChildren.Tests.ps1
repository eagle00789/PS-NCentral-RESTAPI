Describe "Get-NcentralOrganizationUnitChildren" {
    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\OrganizationUnits\Get-NcentralOrganizationUnitChildren.ps1"
        $script:BaseUrl = "https://api.test.com"
    }

    Context "Paged mode" {
        It "returns the .data portion of the response" {
            Mock Invoke-NcentralApi {
                @{
                    data = @(
                        @{ orgUnitId = 51; orgUnitName = "Child 1" },
                        @{ orgUnitId = 52; orgUnitName = "Child 2" }
                    )
                    totalPages = 1
                }
            }

            $result = Get-NcentralOrganizationUnitChildren -OrganizationUnitID 50

            $result.orgUnitId | Should -Contain 51
            $result.orgUnitId | Should -Contain 52
        }

        It "includes SortBy and SortOrder in the URI if provided" {
            $script:calledUri = $null
            Mock Invoke-NcentralApi {
                $script:calledUri = $Uri
                @{ data = @(@{ orgUnitId = 51 }); totalPages = 1 }
            }

            $null = Get-NcentralOrganizationUnitChildren -OrganizationUnitID 50 -SortBy orgUnitName -SortOrder Desc

            $script:calledUri | Should -Be "https://api.test.com/api/org-units/50/children?pageNumber=1&pageSize=50&sortOrder=desc&sortBy=orgUnitName"
        }
    }

    Context "All mode" {
        It "retrieves and combines multiple pages" {
            Mock Invoke-NcentralApi {
                if ($Uri -match "pageNumber=1") {
                    @{
                        data = @(@{ orgUnitId = 51 })
                        totalPages = 2
                    }
                }
                else {
                    @{
                        data = @(@{ orgUnitId = 52 })
                        totalPages = 2
                    }
                }
            }

            $result = Get-NcentralOrganizationUnitChildren -OrganizationUnitID 50 -All

            $result.orgUnitId | Should -Contain 51
            $result.orgUnitId | Should -Contain 52
        }
    }
}
