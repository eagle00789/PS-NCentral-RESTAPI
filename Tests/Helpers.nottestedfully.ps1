Describe "Invoke-NcentralApi" {
    BeforeAll {
        . "$PSScriptRoot\..\Internal\Helpers.ps1"
    }

    BeforeEach {
        # Ensure we have a dummy access token for the Authorization header
        $script:AccessToken = "dummyAccess"
    }

    Context "Successful calls" {
        It "Calls Invoke-RestMethod with correct headers and returns response" {
            Mock Invoke-RestMethod { return @{ success = $true } }

            $result = Invoke-NcentralApi -Uri "https://server/api/test" -Method "GET"

            $result.success | Should -Be $true
            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter {
                $Headers["Authorization"] -eq "Bearer dummyAccess"
            }
        }

        It "Appends query parameters to Uri" {
            Mock Invoke-RestMethod { return "ok" }

            $null = Invoke-NcentralApi -Uri "https://server/api/test" -Method "GET" -Query @{ id = 42; name = "bob" }

            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter {
                $Uri -match "id=42" -and $Uri -match "name=bob"
            }
        }

        It "Serializes body as JSON when ConvertToJson is true" {
            Mock Invoke-RestMethod { return "ok" }

            $body = @{ key = "value" }
            $null = Invoke-NcentralApi -Uri "https://server/api/test" -Method "POST" -Body $body -ConvertToJson $true

            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter {
                $ContentType -eq "application/json"
            }
        }

        It "Sends body as plain text when ConvertToJson is false" {
            Mock Invoke-RestMethod { return "ok" }

            $body = "raw text"
            $null = Invoke-NcentralApi -Uri "https://server/api/test" -Method "POST" -Body $body -ConvertToJson $false

            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter {
                $ContentType -eq "text/plain"
            }
        }
    }

    Context "Error handling" {
        It "Returns null and warns when 401 unauthorized occurs" {
            Mock Invoke-RestMethod {
                $ex = New-Object Exception "Unauthorized"
                $status = New-Object PSObject -Property @{ value__ = [int][System.Net.HttpStatusCode]::Unauthorized }
                $resp = New-Object PSObject -Property @{ StatusCode = $status }
                $ex | Add-Member -MemberType NoteProperty -Name Response -Value $resp
                throw $ex
            }

            $result = Invoke-NcentralApi -Uri "https://server/api/test" -Method "GET"
            $result | Should -BeNullOrEmpty
        }

        It "returns null and warns when API rate limit exceeded" {
            Mock Invoke-RestMethod {
                $ex = New-Object Exception "Rate limit"
                throw $ex
            }

            $warning = $null
            $result = Invoke-NcentralApi -Uri "https://server/api/test" -Method GET -WarningVariable warning

            $result | Should -BeNullOrEmpty
            $warning | Should -Match "Rate limit"
        }

        It "Returns null and writes error for other HTTP codes" {
            Mock Invoke-RestMethod {
                $ex = New-Object Exception "Server error"
                $status = New-Object PSObject -Property @{ value__ = [int][System.Net.HttpStatusCode]::InternalServerError }
                $resp = New-Object PSObject -Property @{ StatusCode = $status }
                $ex | Add-Member -MemberType NoteProperty -Name Response -Value $resp
                throw $ex
            }

            $result = Invoke-NcentralApi -Uri "https://server/api/test" -Method "GET"
            $result | Should -BeNullOrEmpty
        }
    }
}

Describe "Show-Warning" {
    BeforeAll {
        . "$PSScriptRoot\..\Helpers.ps1"
    }

    It "Writes a fixed warning message" {
        { Show-Warning } | Should -ThrowExactly ([System.Management.Automation.WarningRecord]) -Because "Write-Warning outputs warnings"
    }
}