# Get-NcentralDevices.Tests.ps1
Describe 'Get-NcentralDevices' {
    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\Devices\Get-NcentralDevices.ps1"
        # Mock externe functies

        Mock Invoke-NcentralApi {
            return @{
                totalPages = 2
                data = @("Device1", "Device2")
            }
        }

        Mock Show-Warning { }

        # Zet een dummy BaseUrl
        $script:BaseUrl = 'https://dummy-ncentral.local'
    }

    Context 'Paged parameter set' {
        It 'should call Invoke-NcentralApi with correct URI for paged request' {
            $result = Get-NcentralDevices -PageNumber 1 -PageSize 50

            Assert-MockCalled Invoke-NcentralApi -Exactly 1 -Scope It
            $result | Should -Contain 'Device1'
        }

        It 'should include FilterID and SortOrder in URI if provided' {
            Mock Invoke-NcentralApi {
                param($Uri, $Method)
                $Uri | Should -Match 'filterId=123'
                $Uri | Should -Match 'sortOrder=asc'
                return @{ data = @("FilteredDevice") }
            }

            $result = Get-NcentralDevices -FilterID 123 -SortOrder 'asc'
            $result | Should -Contain 'FilteredDevice'
        }
    }

    Context 'All parameter set' {
        It 'should iterate through all pages and aggregate results' {
            Mock Invoke-NcentralApi {
                param($Uri, $Method)
                if ($Uri -match 'pageNumber=1') {
                    return @{ totalPages = 2; data = @("Device1") }
                } else {
                    return @{ data = @("Device2") }
                }
            }

            $result = Get-NcentralDevices -All
            $result | Should -Contain 'Device1'
            $result | Should -Contain 'Device2'
        }

        It 'should call Show-Warning when OrgUnitID is used' {
            $null = Get-NcentralDevices -All -OrgUnitID 999
            Assert-MockCalled Show-Warning -Exactly 1 -Scope It
        }
    }

    Context 'SortOrder normalization' {
        It 'should normalize SortOrder to lowercase' {
            Mock Invoke-NcentralApi {
                param($Uri, $Method)
                $Uri | Should -Match 'sortOrder=descending'
                return @{ data = @("SortedDevice") }
            }

            $result = Get-NcentralDevices -SortOrder 'Descending'
            $result | Should -Contain 'SortedDevice'
        }
    }
}
