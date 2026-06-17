Describe "Get-NcentralCustomer" {
    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\OrganizationUnits\Get-NcentralCustomer.ps1"
        $script:BaseUrl = "https://api.test.com"
    }

    BeforeEach {
        Mock Invoke-NcentralApi {}
    }

    It "requires CustomerID" {
        { Get-NcentralCustomer @{} } | Should -Throw
    }

    It "calls Invoke-NcentralApi with the correct Uri and Method" {
        Get-NcentralCustomer -CustomerID 12345 | Out-Null

        Assert-MockCalled Invoke-NcentralApi -Times 1 -ParameterFilter {
            $Uri -eq "https://api.test.com/api/customers/12345" -and
            $Method -eq "GET"
        }
    }

    It "returns the API response" {
        Mock Invoke-NcentralApi { return @{ customerId = 12345; customerName = "Customer A" } }

        $result = Get-NcentralCustomer -CustomerID 12345

        $result.customerId | Should -Be 12345
        $result.customerName | Should -Be "Customer A"
    }
}
