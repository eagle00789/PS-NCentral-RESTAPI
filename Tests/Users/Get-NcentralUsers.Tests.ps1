Describe "Get-NcentralUsers" {
    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\Users\Get-NcentralUsers.ps1"
        $script:BaseUrl = "https://fake-ncentral.local"
    }

    Context "Paged results" {
        It "Calls Invoke-NcentralApi with the correct parameters (default values)" {
            Mock Invoke-NcentralApi { @{ data = @("u1","u2") } }

            $result = Get-NcentralUsers

            $result | Should -Be @("u1","u2")
            Should -Invoke Invoke-NcentralApi -Times 1 -Exactly -ParameterFilter {
                $Uri -eq "https://fake-ncentral.local/api/org-units/50/users?pageNumber=1&pageSize=50" -and
                $Method -eq "GET"
            }
        }

        It "Appends SortOrder to the URI when specified" {
            Mock Invoke-NcentralApi { @{ data = @("sorted") } }

            $result = Get-NcentralUsers -orgUnitID 99 -PageNumber 2 -PageSize 10 -SortOrder Desc

            $result | Should -Be @("sorted")
            Should -Invoke Invoke-NcentralApi -Times 1 -Exactly -ParameterFilter {
                $Uri -eq "https://fake-ncentral.local/api/org-units/99/users?pageNumber=2&pageSize=10&sortOrder=desc"
            }
        }
    }

    Context "All pages retrieval" {
        It "Includes SortOrder in all requests when provided" {
            Mock Invoke-NcentralApi {
                # Simulate different responses per page
                if ($Uri -match "pageNumber=1") {
                    return @{
                        totalPages = 2
                        data       = @("user1")
                    }
                }
                elseif ($Uri -match "pageNumber=2") {
                    return @{
                        totalPages = 2
                        data       = @("user2")
                    }
                }
            }

            $result = Get-NcentralUsers -All -orgUnitID 50 -SortOrder desc

            # Verify the combined dataset
            $result | Should -Be @("user1", "user2")

            # Verify that every Invoke-NcentralApi call included the sortOrder
            Assert-MockCalled Invoke-NcentralApi -Times 2 -Exactly -ParameterFilter {
                $Uri -match "sortOrder=desc"
            }
        }
    }

    Context "General behavior" {
        It "Calls Show-Warning once at the start" {
            Mock Show-Warning {}

            Mock Invoke-NcentralApi { @{ data = @() } }

            Get-NcentralUsers | Out-Null

            Should -Invoke Show-Warning -Times 1
        }
    }
}
