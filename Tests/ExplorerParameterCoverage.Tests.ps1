Describe "Explorer parameter coverage" {
    BeforeAll {
        . "$PSScriptRoot\..\Internal\Helpers.ps1"

        . "$PSScriptRoot\..\OrganizationUnits\Get-NcentralCustomers.ps1"
        . "$PSScriptRoot\..\OrganizationUnits\Get-NcentralCustomerSites.ps1"
        . "$PSScriptRoot\..\DeviceFilters\Get-NcentralDeviceFilters.ps1"
        . "$PSScriptRoot\..\Devices\Get-NcentralDevices.ps1"
        . "$PSScriptRoot\..\CustomProperties\Get-NcentralCustomProperties.ps1"
        . "$PSScriptRoot\..\OrganizationUnits\Get-NcentralOrganizationUnits.ps1"
        . "$PSScriptRoot\..\AccessGroups\Get-NcentralAccessGroups.ps1"
        . "$PSScriptRoot\..\ActiveIssues\Get-NcentralActiveIssues.ps1"
        . "$PSScriptRoot\..\OrganizationUnits\Get-NcentralOrganizationUnitChildren.ps1"
        . "$PSScriptRoot\..\OrganizationUnits\Get-NcentralServiceOrganizations.ps1"
        . "$PSScriptRoot\..\OrganizationUnits\Get-NcentralServiceOrganizationsCustomers.ps1"
        . "$PSScriptRoot\..\OrganizationUnits\Get-NcentralSites.ps1"
        . "$PSScriptRoot\..\Users\Get-NcentralUsers.ps1"
        . "$PSScriptRoot\..\UserRoles\Get-NcentralUserRoles.ps1"

        $script:BaseUrl = "https://api.test.com"
    }

    Context "URI-based list commands" {
        BeforeEach {
            Mock Show-Warning {}
            Mock Invoke-NcentralApi { @{ data = @(); totalPages = 1 } }
        }

        It "supports select on customer lists" {
            Get-NcentralCustomers -Select 'customerId,customerName' | Out-Null

            Assert-MockCalled Invoke-NcentralApi -ParameterFilter {
                $Uri -eq "https://api.test.com/api/customers?pageNumber=1&pageSize=50&select=customerId,customerName"
            }
        }

        It "supports select on customer sites" {
            Get-NcentralCustomerSites -CustomerID 7 -Select 'siteId,siteName' | Out-Null

            Assert-MockCalled Invoke-NcentralApi -ParameterFilter {
                $Uri -eq "https://api.test.com/api/customers/7/sites?pageNumber=1&pageSize=50&select=siteId,siteName"
            }
        }

        It "supports sortBy and select on device filters" {
            Get-NcentralDeviceFilters -SortBy name -Select 'id,name' | Out-Null

            Assert-MockCalled Invoke-NcentralApi -ParameterFilter {
                $Uri -eq "https://api.test.com/api/device-filters?viewScope=ALL&pageNumber=1&pageSize=50&sortBy=name&select=id,name"
            }
        }

        It "supports select on custom properties" {
            Get-NcentralCustomProperties -OrgUnitId 5 -Select 'propertyId,name' | Out-Null

            Assert-MockCalled Invoke-NcentralApi -ParameterFilter {
                $Uri -eq "https://api.test.com/api/org-units/5/custom-properties?pageNumber=1&pageSize=50&select=propertyId,name"
            }
        }

        It "supports select on organization units" {
            Get-NcentralOrganizationUnits -Select 'orgUnitId,orgUnitName' | Out-Null

            Assert-MockCalled Invoke-NcentralApi -ParameterFilter {
                $Uri -eq "https://api.test.com/api/org-units?pageNumber=1&pageSize=50&select=orgUnitId,orgUnitName"
            }
        }

        It "supports sortBy and select on access groups" {
            Get-NcentralAccessGroups -SortBy name -Select 'id,name' | Out-Null

            Assert-MockCalled Invoke-NcentralApi -ParameterFilter {
                $Uri -eq "https://api.test.com/api/org-units/50/access-groups?pageNumber=1&pageSize=50&sortBy=name&select=id,name"
            }
        }

        It "supports sortBy and select on active issues" {
            Get-NcentralActiveIssues -SortBy priority -Select 'issueId,priority' | Out-Null

            Assert-MockCalled Invoke-NcentralApi -ParameterFilter {
                $Uri -eq "https://api.test.com/api/org-units/50/active-issues?pageNumber=1&pageSize=50&sortBy=priority&select=issueId,priority"
            }
        }

        It "supports select on organization unit children" {
            Get-NcentralOrganizationUnitChildren -OrganizationUnitID 9 -Select 'orgUnitId,orgUnitName' | Out-Null

            Assert-MockCalled Invoke-NcentralApi -ParameterFilter {
                $Uri -eq "https://api.test.com/api/org-units/9/children?pageNumber=1&pageSize=50&select=orgUnitId,orgUnitName"
            }
        }

        It "supports sortBy and select on service organizations" {
            Get-NcentralServiceOrganizations -SortBy soName -Select 'soId,soName' | Out-Null

            Assert-MockCalled Invoke-NcentralApi -ParameterFilter {
                $Uri -eq "https://api.test.com/api/service-orgs?pageNumber=1&pageSize=50&sortBy=soName&select=soId,soName"
            }
        }

        It "supports sortBy and select on service organization customers" {
            Get-NcentralServiceOrganizationsCustomers -ServiceOrganizationID 11 -SortBy customerName -Select 'customerId,customerName' | Out-Null

            Assert-MockCalled Invoke-NcentralApi -ParameterFilter {
                $Uri -eq "https://api.test.com/api/service-orgs/11/customers?pageNumber=1&pageSize=50&sortBy=customerName&select=customerId,customerName"
            }
        }

        It "supports select on sites" {
            Get-NcentralSites -Select 'siteId,siteName' | Out-Null

            Assert-MockCalled Invoke-NcentralApi -ParameterFilter {
                $Uri -eq "https://api.test.com/api/sites?pageNumber=1&pageSize=50&select=siteId,siteName"
            }
        }

        It "supports sortBy and select on users" {
            Get-NcentralUsers -SortBy userName -Select 'userId,userName' | Out-Null

            Assert-MockCalled Invoke-NcentralApi -ParameterFilter {
                $Uri -eq "https://api.test.com/api/org-units/50/users?pageNumber=1&pageSize=50&sortBy=userName&select=userId,userName"
            }
        }

        It "supports sortBy and select on user roles" {
            Get-NcentralUserRoles -SortBy name -Select 'userRoleId,name' | Out-Null

            Assert-MockCalled Invoke-NcentralApi -ParameterFilter {
                $Uri -eq "https://api.test.com/api/org-units/50/user-roles?pageNumber=1&pageSize=50&sortBy=name&select=userRoleId,name"
            }
        }
    }

    Context "Query-based list commands" {
        BeforeEach {
            Mock Invoke-NcentralApi { @{ data = @(); totalPages = 1 } }
        }

        It "supports sortBy and select on devices" {
            Get-NcentralDevices -SortBy longName -Select 'deviceId,longName' | Out-Null

            Assert-MockCalled Invoke-NcentralApi -ParameterFilter {
                $Query.sortBy -eq "longName" -and
                $Query.select -eq "deviceId,longName"
            }
        }
    }
}
