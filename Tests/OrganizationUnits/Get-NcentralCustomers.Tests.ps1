Describe "Get-NcentralCustomers" {
    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\OrganizationUnits\Get-NcentralCustomers.ps1"
        $script:BaseUrl = "https://api.test.com"
    }

    Context "Paged mode" {
        It "returns the .data portion of the response" {
            Mock Invoke-NcentralApi {
                @{
                    data = @(
                        @{ customerId = 1; customerName = "Customer 1" },
                        @{ customerId = 2; customerName = "Customer 2" }
                    )
                    totalPages = 1
                }
            }

            $result = Get-NcentralCustomers

            $result.customerId | Should -Contain 1
            $result.customerId | Should -Contain 2
        }

        It "includes SortBy and SortOrder in the URI if provided" {
            $script:calledUri = $null
            Mock Invoke-NcentralApi {
                $script:calledUri = $Uri
                @{ data = @(@{ customerId = 1 }); totalPages = 1 }
            }

            $null = Get-NcentralCustomers -SortBy customerName -SortOrder Desc

            $script:calledUri | Should -Be "https://api.test.com/api/customers?pageNumber=1&pageSize=50&sortOrder=desc&sortBy=customerName"
        }
    }

    Context "All mode" {
        It "retrieves and combines multiple pages" {
            Mock Invoke-NcentralApi {
                if ($Uri -match "pageNumber=1") {
                    @{
                        data = @(@{ customerId = 1 })
                        totalPages = 2
                    }
                }
                else {
                    @{
                        data = @(@{ customerId = 2 })
                        totalPages = 2
                    }
                }
            }

            $result = Get-NcentralCustomers -All

            $result.customerId | Should -Contain 1
            $result.customerId | Should -Contain 2
        }
    }
}
