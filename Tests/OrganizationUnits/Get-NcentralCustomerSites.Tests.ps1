Describe "Get-NcentralCustomerSites" {

    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\OrganizationUnits\Get-NcentralCustomerSites.ps1"
        # Common values for mocks
        $CustomerID = 123
        $BaseUrl = "https://api.test.com"
        $script:BaseUrl = $BaseUrl
    }

    Context "Paged mode" {
        BeforeEach {
            Mock -CommandName Invoke-NcentralApi -MockWith {
                @{
                    data = @(
                        @{ siteId = 1; siteName = "TestSite1" },
                        @{ siteId = 2; siteName = "TestSite2" }
                    )
                    totalPages = 1
                }
            }
        }

        It "returns the .data portion of the response" {
            $result = Get-NcentralCustomerSites -CustomerID $CustomerID -PageNumber 1 -PageSize 50
            $result | Should -Not -BeNullOrEmpty
            $result[0].siteId | Should -Be 1
            $result[1].siteId | Should -Be 2
        }

        It "includes SortBy and SortOrder in the URI if provided" {
            $script:calledUris = @()   # force global tracking

            Mock -CommandName Invoke-NcentralApi -MockWith {
                $script:calledUris += $Uri
                return @{
                    data = @(@{ siteId = 1 })
                    totalPages = 1
                }
            } -Verifiable

            $null = Get-NcentralCustomerSites -CustomerID $CustomerID -PageNumber 1 -PageSize 50 -SortBy siteName -SortOrder asc

            $script:calledUris[-1] | Should -Match "sortBy=siteName"
            $script:calledUris[-1] | Should -Match "sortOrder=asc"
        }
    }

    Context "All mode" {
        BeforeEach {
            $script:seenUris = @()
            Mock -CommandName Invoke-NcentralApi -MockWith {
                $script:seenUris += $Uri
                if ($Uri -match "pageNumber=1") {
                    return @{
                        data = @(@{ siteId = 1; siteName = "Page1-Site" })
                        totalPages = 2
                    }
                }
                elseif ($Uri -match "pageNumber=2") {
                    return @{
                        data = @(@{ siteId = 2; siteName = "Page2-Site" })
                        totalPages = 2
                    }
                }
            }
        }

        It "retrieves and combines multiple pages" {
            $result = Get-NcentralCustomerSites -CustomerID $CustomerID -All
            $result | Should -Not -BeNullOrEmpty
            $result.siteId | Should -Contain 1
            $result.siteId | Should -Contain 2
        }

        It "includes SortOrder and SortBy in all looped pages if provided" {
            $null = Get-NcentralCustomerSites -CustomerID $CustomerID -All -SortBy siteId -SortOrder asc
            $script:seenUris | Should -Contain "$BaseUrl/api/customers/$CustomerID/sites?pageNumber=1&pageSize=50&sortOrder=asc&sortBy=siteId"
            $script:seenUris | Should -Contain "$BaseUrl/api/customers/$CustomerID/sites?pageNumber=2&pageSize=50&sortOrder=asc&sortBy=siteId"
        }

        It "returns nothing when API returns no data" {
            Mock -CommandName Invoke-NcentralApi -MockWith {
                @{
                    data = @()
                    totalPages = 1
                }
            }
            $result = Get-NcentralCustomerSites -CustomerID $CustomerID -All
            $result | Should -BeNullOrEmpty
        }
    }
}
