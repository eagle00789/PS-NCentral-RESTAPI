Describe "Get-NcentralDeviceFilters" {
    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\DeviceFilters\Get-NcentralDeviceFilters.ps1"

        $script:BaseUrl = "https://api.test.com"
    }

    BeforeEach {
        Mock Invoke-NcentralApi { return @{ data = @(); totalPages = 1 } }
    }

    Context "Parameter validation" {
        It "accepts valid viewScope values (all, own_and_used)" {
            { Get-NcentralDeviceFilters -viewScope all } | Should -Not -Throw
            { Get-NcentralDeviceFilters -viewScope own_and_used } | Should -Not -Throw
        }

        It "rejects invalid viewScope values" {
            { Get-NcentralDeviceFilters -viewScope invalid } | Should -Throw
        }

        It "accepts valid SortOrder values (asc, desc, ascending, descending)" {
            { Get-NcentralDeviceFilters -SortOrder asc } | Should -Not -Throw
            { Get-NcentralDeviceFilters -SortOrder descending } | Should -Not -Throw
        }

        It "rejects invalid SortOrder values" {
            { Get-NcentralDeviceFilters -SortOrder sideways } | Should -Throw
        }
    }

    Context "Paged mode" {
        It "calls Invoke-NcentralApi with correct URI" {
            $expectedUri = "$script:BaseUrl/api/device-filters?viewScope=ALL&pageNumber=1&pageSize=50"

            Get-NcentralDeviceFilters -PageNumber 1 -PageSize 50 | Out-Null

            Assert-MockCalled Invoke-NcentralApi -Times 1 -ParameterFilter {
                $Uri -eq $expectedUri -and $Method -eq "GET"
            }
        }

        It "returns the .data array from API response" {
            Mock Invoke-NcentralApi { return @{ data = @( @{ id = 1 }, @{ id = 2 } ); totalPages = 1 } }

            $result = Get-NcentralDeviceFilters -PageNumber 1 -PageSize 50
            $result | Should -HaveCount 2
            $result.id | Should -Contain 1
            $result.id | Should -Contain 2
        }
    }

    Context "All mode" {
        It "retrieves and combines multiple pages" {
            Mock Invoke-NcentralApi {
                param($Uri, $Method)

                if ($Uri -match "pageNumber=1") {
                    return @{ data = @( @{ id = 1 } ); totalPages = 2 }
                }
                elseif ($Uri -match "pageNumber=2") {
                    return @{ data = @( @{ id = 2 } ); totalPages = 2 }
                }
            }

            $result = Get-NcentralDeviceFilters -All
            $result.id | Should -Contain 1
            $result.id | Should -Contain 2
            $result    | Should -HaveCount 2
        }

        It "appends SortOrder to URIs in loop pages" {
            $script:seenUris = @()

            Mock Invoke-NcentralApi {
                param($Uri, $Method)
                # capture the actual Uri string
                $script:seenUris += $Uri

                if ($Uri -match "pageNumber=1") {
                    return @{ data = @( @{ id = 1 } ); totalPages = 2 }
                }
                elseif ($Uri -match "pageNumber=2") {
                    return @{ data = @( @{ id = 2 } ); totalPages = 2 }
                }
            }

            $result = Get-NcentralDeviceFilters -All -SortOrder asc

            # ensure both URIs have sortOrder appended
            $script:seenUris[0] | Should -Match "sortOrder=asc"
            $script:seenUris[1] | Should -Match "sortOrder=asc"
        }
    }
}
