Describe "Get-NcentralAccessGroups" {
    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\AccessGroups\Get-NcentralAccessGroups.ps1"
    }

    BeforeEach {
        # Reset script variables
        $script:BaseUrl = "https://ncentral.example.com"

        # Default mock for Show-Warning
        Mock Show-Warning {}

        # Default mock for Invoke-NcentralApi
        Mock Invoke-NcentralApi { return @{ data = @("group1","group2"); totalPages = 1 } }
    }

    Context "Parameter validation" {
        It "Defaults orgUnitID to 50" {
            $null = Get-NcentralAccessGroups
            Assert-MockCalled Invoke-NcentralApi -ParameterFilter {
                $Uri -match "/org-units/50/"
            } -Times 1
        }

        It "Defaults PageNumber to 1 and PageSize to 50" {
            $null = Get-NcentralAccessGroups
            Assert-MockCalled Invoke-NcentralApi -ParameterFilter {
                $Uri -match "pageNumber=1" -and $Uri -match "pageSize=50"
            } -Times 1
        }

        It "Normalizes SortOrder to lowercase" {
            $null = Get-NcentralAccessGroups -SortOrder "ASCENDING"
            Assert-MockCalled Invoke-NcentralApi -ParameterFilter {
                $Uri -match "sortOrder=ascending"
            } -Times 1
        }

        It "Throws if SortOrder is invalid" {
            { Get-NcentralAccessGroups -SortOrder "INVALID" } | Should -Throw
        }
    }

    Context "Paged retrieval" {
        It "Builds correct URI for paged request" {
            $null = Get-NcentralAccessGroups -orgUnitID 123 -PageNumber 2 -PageSize 25
            Assert-MockCalled Invoke-NcentralApi -ParameterFilter {
                $Uri -eq "https://ncentral.example.com/api/org-units/123/access-groups?pageNumber=2&pageSize=25"
            } -Times 1
        }

        It "Returns only the data property from response" {
            Mock Invoke-NcentralApi { return @{ data = @("g1","g2"); totalPages = 1 } }
            $result = Get-NcentralAccessGroups
            $result | Should -Be @("g1","g2")
        }
    }

    Context "All pages retrieval" {
        It "Fetches multiple pages when All is specified" {
            Mock Invoke-NcentralApi {
                if ($Uri -match "pageNumber=1") {
                    return @{ data = @("page1"); totalPages = 2 }
                }
                elseif ($Uri -match "pageNumber=2") {
                    return @{ data = @("page2"); totalPages = 2 }
                }
            }

            $result = Get-NcentralAccessGroups -All -orgUnitID 42
            $result | Should -Be @("page1","page2")

            Assert-MockCalled Invoke-NcentralApi -Times 2
        }

        It "Appends SortOrder when All is specified" {
            $null = Get-NcentralAccessGroups -All -SortOrder "desc"
            Assert-MockCalled Invoke-NcentralApi -ParameterFilter {
                $Uri -match "sortOrder=desc"
            } -Times 1
        }
    }

    Context "Warning behavior" {
        It "Calls Show-Warning once" {
            $null = Get-NcentralAccessGroups
            Assert-MockCalled Show-Warning -Times 1
        }
    }

    Context "SortOrder handling" {
        It "Appends sortOrder to the URI in Paged mode" {
            Mock Invoke-NcentralApi { @{ data = @("sorted") } }

            $result = Get-NcentralAccessGroups -SortOrder asc
            $result | Should -Be @("sorted")

            Assert-MockCalled Invoke-NcentralApi -ParameterFilter {
                $Uri -match "sortOrder=asc"
            } -Times 1
        }

        It "Appends sortOrder to the URI in All mode" {
            $page1 = @{ totalPages = 1; data = @("sortedAll") }
            Mock Invoke-NcentralApi { $page1 }

            $result = Get-NcentralAccessGroups -All -SortOrder desc
            $result | Should -Be @("sortedAll")

            Assert-MockCalled Invoke-NcentralApi -ParameterFilter {
                $Uri -match "sortOrder=desc"
            } -Times 1
        }
    }

    Context "SortOrder handling in All loop" {
        It "Appends sortOrder when fetching subsequent pages" {
            $page1 = @{ totalPages = 2; data = @("page1") }
            $page2 = @{ data = @("page2") }

            # First call returns page1, second call returns page2
            Mock Invoke-NcentralApi {
                if ($Uri -match "pageNumber=1") { $page1 }
                elseif ($Uri -match "pageNumber=2") { $page2 }
            }

            $result = Get-NcentralAccessGroups -All -SortOrder asc
            $result | Should -Be @("page1", "page2")

            # Specifically check the page 2 URI had sortOrder
            Assert-MockCalled Invoke-NcentralApi -ParameterFilter {
                $Uri -match "pageNumber=2" -and $Uri -match "sortOrder=asc"
            } -Times 1
        }
    }
}
