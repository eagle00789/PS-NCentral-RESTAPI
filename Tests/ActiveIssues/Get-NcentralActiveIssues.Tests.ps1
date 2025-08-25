Describe "Get-NcentralActiveIssues" {
    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\ActiveIssues\Get-NcentralActiveIssues.ps1"
    }

    Context "Parameter validation" {
        It "Defaults CustomerID to 50" {
            Mock Invoke-NcentralApi { @{ data = @("issue1") } }

            $result = Get-NcentralActiveIssues
            $result | Should -Contain "issue1"

            Assert-MockCalled Invoke-NcentralApi -ParameterFilter {
                $Uri -like "*/org-units/50/active-issues*"
            } -Times 1
        }

        It "Accepts a custom CustomerID" {
            Mock Invoke-NcentralApi { @{ data = @("issueX") } }

            $null = Get-NcentralActiveIssues -CustomerID 123
            Assert-MockCalled Invoke-NcentralApi -ParameterFilter {
                $Uri -like "*/org-units/123/active-issues*"
            } -Times 1
        }

        It "Normalizes SortOrder to lowercase" {
            Mock Invoke-NcentralApi { @{ data = @("sorted") } }

            $null = Get-NcentralActiveIssues -SortOrder "DESC"
            Assert-MockCalled Invoke-NcentralApi -ParameterFilter {
                $Uri -like "*sortOrder=desc"
            } -Times 1
        }
    }

    Context "Paged retrieval" {
        BeforeEach {
            Mock Invoke-NcentralApi { @{ data = @("issueA","issueB") } }
        }

        It "Fetches a single page of results" {
            $result = Get-NcentralActiveIssues -CustomerID 99 -PageNumber 1 -PageSize 25
            $result | Should -Be @("issueA","issueB")

            Assert-MockCalled Invoke-NcentralApi -ParameterFilter {
                $Uri -like "*/org-units/99/active-issues?pageNumber=1&pageSize=25*"
            } -Times 1
        }
    }

    Context "All pages retrieval" {
        BeforeEach {
            $page1 = @{ totalPages = 2; data = @("p1") }
            $page2 = @{ data = @("p2") }

            $callCount = 0
            Mock Invoke-NcentralApi {
                $callCount++
                if ($callCount -eq 1) { return $page1 }
                else { return $page2 }
            }
        }

        It "Fetches multiple pages when All is specified" {
            $page1 = @{ totalPages = 2; data = @("p1") }
            $page2 = @{ data = @("p2") }

            # Must be outside the Mock so it persists across calls
            $script:callCount = 0  

            Mock Invoke-NcentralApi {
                $script:callCount++
                if ($script:callCount -eq 1) { return $page1 }
                else { return $page2 }
            }

            $result = Get-NcentralActiveIssues -All

            $result | Should -Be @("p1","p2")
            Assert-MockCalled Invoke-NcentralApi -Times 2
        }

        It "Returns null if first page has no data" {
            Mock Invoke-NcentralApi { $null }

            $result = Get-NcentralActiveIssues -All
            $result | Should -Be $null
        }
    }

    Context "SortOrder handling" {
        It "Appends sortOrder to the URI in Paged mode" {
            Mock Invoke-NcentralApi { @{ data = @("sortedIssue") } }

            $result = Get-NcentralActiveIssues -SortOrder asc
            $result | Should -Be @("sortedIssue")

            Assert-MockCalled Invoke-NcentralApi -ParameterFilter {
                $Uri -match "sortOrder=asc"
            } -Times 1
        }

        It "Appends sortOrder to the URI in All mode" {
            $page1 = @{ totalPages = 1; data = @("sortedAllIssues") }
            Mock Invoke-NcentralApi { $page1 }

            $result = Get-NcentralActiveIssues -All -SortOrder desc
            $result | Should -Be @("sortedAllIssues")

            Assert-MockCalled Invoke-NcentralApi -ParameterFilter {
                $Uri -match "sortOrder=desc"
            } -Times 1
        }
    }

    Context "SortOrder handling in All loop" {
        It "Appends sortOrder when fetching subsequent pages" {
            $page1 = @{ totalPages = 2; data = @("i1") }
            $page2 = @{ data = @("i2") }

            Mock Invoke-NcentralApi {
                if ($Uri -match "pageNumber=1") { $page1 }
                elseif ($Uri -match "pageNumber=2") { $page2 }
            }

            $result = Get-NcentralActiveIssues -All -SortOrder desc
            $result | Should -Be @("i1", "i2")

            Assert-MockCalled Invoke-NcentralApi -ParameterFilter {
                $Uri -match "pageNumber=2" -and $Uri -match "sortOrder=desc"
            } -Times 1
        }
    }
}
