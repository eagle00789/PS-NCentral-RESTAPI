Describe "Get-NcentralAccessGroup" {
    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\AccessGroups\Get-NcentralAccessGroup.ps1"
    }

    BeforeEach {
        $script:BaseUrl = "https://server"
    }

    Context "Request building" {
        It "Calls Invoke-NcentralApi with correct Uri and Method" {
            Mock Invoke-NcentralApi { return @{ data = @{ id = 42; name = "Admins" } } }
            Mock Show-Warning {}

            $result = Get-NcentralAccessGroup -AccessGroupID 42

            $result.id   | Should -Be 42
            $result.name | Should -Be "Admins"

            Assert-MockCalled Invoke-NcentralApi -Times 1 -ParameterFilter {
                $Uri -eq "https://server/api/access-groups/42" -and
                $Method -eq "GET"
            }
        }
    }

    Context "Warnings" {
        It "Calls Show-Warning once" {
            Mock Invoke-NcentralApi { return @{ data = @{ id = 100 } } }
            Mock Show-Warning {}

            $null = Get-NcentralAccessGroup -AccessGroupID 100

            Assert-MockCalled Show-Warning -Times 1
        }
    }

    Context "Validation / Negative tests" {
        It "Throws when AccessGroupID is missing (mandatory)" {
            Mock Invoke-NcentralApi { return @{ data = @{ id = 5 } } }
            Mock Show-Warning {}

            { Get-NcentralAccessGroup @{} } | Should -Throw -ErrorId "ParameterArgumentTransformationError,Get-NcentralAccessGroup"
        }

        It "Throws when AccessGroupID is not an integer" {
            Mock Invoke-NcentralApi { return @{ data = @{ id = 5 } } }
            Mock Show-Warning {}

            { Get-NcentralAccessGroup -AccessGroupID "abc" } | Should -Throw -ExceptionType ([System.Management.Automation.ParameterBindingException])
        }
    }
}
