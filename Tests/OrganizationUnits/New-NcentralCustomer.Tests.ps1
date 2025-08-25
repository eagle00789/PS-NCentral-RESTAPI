Describe "New-NcentralCustomer" {
    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\OrganizationUnits\New-NCentralCustomer.ps1"
    }

    BeforeEach {
        # Set dummy base URL so we know what the full Uri will be
        $script:BaseUrl = "https://server"
    }

    Context "Request building" {
        It "Calls Invoke-NcentralApi with required customerName only" {
            Mock Invoke-NcentralApi { return @{ id = 123 } }
            Mock Show-Warning {}

            $result = New-NcentralCustomer -customerName "Acme"

            $result.id | Should -Be 123
            Assert-MockCalled Invoke-NcentralApi -Times 1 -ParameterFilter {
                $Uri -eq "https://server/api/service-orgs/50/customers" -and
                $Method -eq "POST" -and
                $Body.customerName -eq "Acme"
            }
        }

        It "Uses provided SoId in Uri" {
            Mock Invoke-NcentralApi { return "ok" }
            Mock Show-Warning {}

            $null = New-NcentralCustomer -SoId 99 -customerName "BetaCo"

            Assert-MockCalled Invoke-NcentralApi -Times 1 -ParameterFilter {
                $Uri -eq "https://server/api/service-orgs/99/customers"
            }
        }

        It "Includes non-null parameters in body" {
            Mock Invoke-NcentralApi { return "ok" }
            Mock Show-Warning {}

            $params = @{
                customerName = "TestCo"
                contactEmail = "test@example.com"
                phone        = "123456789"
            }
            $null = New-NcentralCustomer @params

            Assert-MockCalled Invoke-NcentralApi -Times 1 -ParameterFilter {
                $Body.ContainsKey("contactEmail") -and
                $Body["contactEmail"] -eq "test@example.com" -and
                $Body.ContainsKey("phone")
            }
        }

        It "Omits parameters that are null or empty" {
            Mock Invoke-NcentralApi { return "ok" }
            Mock Show-Warning {}

            $params = @{
                customerName = "TestCo"
                contactEmail = ""   # empty string should be removed
                phone        = $null
            }
            $null = New-NcentralCustomer @params

            Assert-MockCalled Invoke-NcentralApi -Times 1 -ParameterFilter {
                -not $Body.ContainsKey("contactEmail") -and
                -not $Body.ContainsKey("phone")
            }
        }

        It "Accepts licenseType from ValidateSet" {
            Mock Invoke-NcentralApi { return "ok" }
            Mock Show-Warning {}

            $null = New-NcentralCustomer -customerName "LicTest" -licenseType "Professional"

            Assert-MockCalled Invoke-NcentralApi -Times 1 -ParameterFilter {
                $Body.licenseType -eq "Professional"
            }
        }
    }

    Context "Warnings" {
        It "Calls Show-Warning at least once" {
            Mock Invoke-NcentralApi { return "ok" }
            Mock Show-Warning {}

            $null = New-NcentralCustomer -customerName "WarnTest"

            Assert-MockCalled Show-Warning -Times 1
        }
    }

    Context "Validation / Negative tests" {
        It "Throws when customerName is missing (mandatory)" {
            Mock Invoke-NcentralApi { return "ok" }
            Mock Show-Warning {}

            { New-NcentralCustomer @{} } | Should -Throw -ErrorId "ParameterArgumentTransformationError,New-NcentralCustomer"
        }

        It "Throws when licenseType is not in ValidateSet" {
            Mock Invoke-NcentralApi { return "ok" }
            Mock Show-Warning {}

            { New-NcentralCustomer -customerName "InvalidLic" -licenseType "Gold" } | Should -Throw
        }
    }
}
