Describe "Get-NcentralApplianceTask" {
    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\Devices\Get-NcentralApplianceTask.ps1"
        $script:BaseUrl = "https://api.test.com"
    }

    BeforeEach {
        Mock Invoke-NcentralApi {}
    }

    It "requires TaskID" {
        { Get-NcentralApplianceTask -TaskID $null } | Should -Throw
    }

    It "calls Invoke-NcentralApi with the correct Uri and Method" {
        Get-NcentralApplianceTask -TaskID "ABC123" | Out-Null

        Assert-MockCalled Invoke-NcentralApi -Times 1 -ParameterFilter {
            $Uri -eq "https://api.test.com/api/appliance-tasks/ABC123" -and
            $Method -eq "GET"
        }
    }

    It "returns the API response" {
        Mock Invoke-NcentralApi { return @{ taskId = "ABC123"; status = "Completed" } }

        $result = Get-NcentralApplianceTask -TaskID "ABC123"

        $result.taskId | Should -Be "ABC123"
        $result.status | Should -Be "Completed"
    }
}
