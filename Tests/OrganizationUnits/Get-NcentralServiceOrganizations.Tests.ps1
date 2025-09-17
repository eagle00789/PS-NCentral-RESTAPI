Describe "Get-NcentralServiceOrganizations" {

    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\OrganizationUnits\Get-NcentralServiceOrganizations.ps1"
        # Common values for mocks
        $BaseUrl = "https://example.com"
        $script:BaseUrl = $BaseUrl
    }

    Context "Paged mode" {
        It "calls the correct URI with default parameters" {
            $calledUri = $null
            Mock Invoke-NcentralApi {
                param([string]$Uri, [string]$Method)
                $script:calledUri = $Uri
                return @{ data = @(@{ id = 1 }); totalPages = 1 }
            }

            $result = Get-NcentralServiceOrganizations

            $script:calledUri | Should -Be "$BaseUrl/api/service-orgs?pageNumber=1&pageSize=50"
            $result.id | Should -Be 1
        }

        It "includes SortOrder in the URI if provided" {
            $calledUri = $null
            Mock Invoke-NcentralApi {
                param([string]$Uri, [string]$Method)
                $script:calledUri = $Uri
                return @{ data = @(@{ id = 2 }); totalPages = 1 }
            }

            $null = Get-NcentralServiceOrganizations -PageNumber 1 -PageSize 50 -SortOrder desc

            $script:calledUri | Should -Match "sortOrder=desc"
        }
    }

    Context "All mode" {
        It "retrieves and combines multiple pages" {
            $callCount = 0
            Mock Invoke-NcentralApi {
                param([string]$Uri, [string]$Method)
                $script:callCount++
                if ($script:callCount -eq 1) {
                    return @{
                        data = @(@{ id = 1 })
                        totalPages = 2
                    }
                } else {
                    return @{
                        data = @(@{ id = 2 })
                        totalPages = 2
                    }
                }
            }

            $result = Get-NcentralServiceOrganizations -All

            $result.id | Should -Contain 1
            $result.id | Should -Contain 2
        }
    }
}
