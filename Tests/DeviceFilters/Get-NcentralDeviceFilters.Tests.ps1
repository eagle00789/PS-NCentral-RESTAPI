Describe "Get-NcentralDeviceFilters" {
    BeforeEach {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\DeviceFilters\Get-NcentralDeviceFilters.ps1"
        Mock Show-Warning {}
        Mock Invoke-NcentralApi { return @{ totalPages = 1; data = @("filter1","filter2") } }
    }

    Context "Paged mode" {
        It "Calls Invoke-NcentralApi with correct default values" {
            $result = Get-NcentralDeviceFilters
            $result | Should -Be @("filter1","filter2")

            Should -Invoke Invoke-NcentralApi -Times 1 -ParameterFilter {
                $Uri -eq "$script:BaseUrl/api/device-filters?viewScope=ALL&pageNumber=1&pageSize=50" -and
                $Method -eq "GET"
            }
        }

        It "Includes SortOrder when specified" {
            $null = Get-NcentralDeviceFilters -PageNumber 3 -PageSize 25 -SortOrder desc -viewScope own_and_used
            Should -Invoke Invoke-NcentralApi -Times 1 -ParameterFilter {
                $Uri -eq "$script:BaseUrl/api/device-filters?viewScope=OWN_AND_USED&pageNumber=3&pageSize=25&sortOrder=desc"
            }
        }

        It "includes SortOrder in the Paged mode when specified" {
            Mock Invoke-NcentralApi { return @{ data = @(@{ id = 1; name = "Filter1" }) } }

            $expectedUri = "$script:BaseUrl/api/device-filters?viewScope=ALL&pageNumber=1&pageSize=50&sortOrder=asc"

            Get-NcentralDeviceFilters -PageNumber 1 -PageSize 50 -SortOrder asc | Out-Null

            Assert-MockCalled Invoke-NcentralApi -Times 1 -ParameterFilter {
                $Uri -eq $expectedUri -and $Method -eq "GET"
            }
        }
    }

    Context "All mode" {
        It "Retrieves multiple pages when All is specified" {
            # Simulate 2 pages
            Mock Invoke-NcentralApi {
                if ($Uri -like "*pageNumber=1*") {
                    return @{ totalPages = 2; data = @("page1-item") }
                } elseif ($Uri -like "*pageNumber=2*") {
                    return @{ data = @("page2-item") }
                }
            }

            $result = Get-NcentralDeviceFilters -All
            $result | Should -Contain "page1-item"
            $result | Should -Contain "page2-item"

            Should -Invoke Invoke-NcentralApi -Times 2
        }

        It "Includes SortOrder in all paged requests when specified" {
            Mock Invoke-NcentralApi {
                return @{ totalPages = 1; data = @("with-sort") }
            }

            $null = Get-NcentralDeviceFilters -All -SortOrder asc
            Should -Invoke Invoke-NcentralApi -ParameterFilter {
                $Uri -like "*sortOrder=asc*"
            }
        }

        It "includes SortOrder in All mode when specified" {
            # Arrange
            Mock Invoke-NcentralApi {
                return @{
                    totalPages = 1
                    data       = @(@{ id = 1; name = "Filter1" })
                }
            }

            $expectedUri = "$script:BaseUrl/api/device-filters?viewScope=ALL&pageNumber=1&pageSize=50&sortOrder=desc"

            # Act
            Get-NcentralDeviceFilters -All -SortOrder desc | Out-Null

            # Assert
            Assert-MockCalled Invoke-NcentralApi -Times 1 -ParameterFilter {
                $Uri -eq $expectedUri -and $Method -eq "GET"
            }
        }

        It "appends SortOrder in the For-Loop for page 2+ when -All is specified" {
            # Put call counter in script scope so it persists
            $script:callCount = 0

            Mock Invoke-NcentralApi {
                $script:callCount++

                if ($script:callCount -eq 1) {
                    return [pscustomobject]@{
                        totalPages = 2
                        data       = @([pscustomobject]@{ id = 1; name = "Filter1" })
                    }
                }
                else {
                    return [pscustomobject]@{
                        data = @([pscustomobject]@{ id = 2; name = "Filter2" })
                    }
                }
            }

            $expectedUriPage2 = "$script:BaseUrl/api/device-filters?viewScope=ALL&pageNumber=2&pageSize=50&sortOrder=asc"

            $result = Get-NcentralDeviceFilters -All -SortOrder asc

            Assert-MockCalled Invoke-NcentralApi -Times 1 -ParameterFilter {
                $Uri -eq $expectedUriPage2 -and $Method -eq "GET"
            }

            $result.id | Should -Contain 1
            $result.id | Should -Contain 2
        }
    }

    Context "Parameter validation" {
        It "Uppercases viewScope values" {
            $null = Get-NcentralDeviceFilters -viewScope own_and_used
            Should -Invoke Invoke-NcentralApi -ParameterFilter {
                $Uri -like "*viewScope=OWN_AND_USED*"
            }
        }
    }

    Context "API Call" {
    It "calls Invoke-NcentralApi with the correct base URI" {
        $expectedUri = "$script:BaseUrl/api/device-filters?viewScope=ALL&pageNumber=1&pageSize=50"

        Get-NcentralDeviceFilters | Out-Null

        Assert-MockCalled Invoke-NcentralApi -Times 1 -ParameterFilter {
            $Uri -eq $expectedUri -and $Method -eq "GET"
        }
    }

    It "includes SortOrder in the URI when specified" {
        $expectedUri = "$script:BaseUrl/api/device-filters?viewScope=ALL&pageNumber=1&pageSize=50&sortOrder=desc"

        Get-NcentralDeviceFilters -SortOrder desc | Out-Null

        Assert-MockCalled Invoke-NcentralApi -Times 1 -ParameterFilter {
            $Uri -eq $expectedUri -and $Method -eq "GET"
        }
    }
}
}