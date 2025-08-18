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
                $resp = New-Object PSObject -Property @{
                    StatusCode = New-Object PSObject -Property @{ value__ = 429 }
                }
                $ex = New-Object Exception "Rate limit"
                Add-Member -InputObject $ex -MemberType NoteProperty -Name Response -Value $resp
                throw $ex
            }

            $warning = $null
            $result = Invoke-NcentralApi -Uri "https://server/api/test" -Method GET -WarningVariable warning

            $result | Should -BeNullOrEmpty
            $warning | Should -Match "Rate limit exceeded"
        }

        It "returns null and writes error when server error (500)" {
            Mock -CommandName Invoke-RestMethod {
                throw [System.Net.WebException]::new(
                    "Server error",
                    [System.Net.WebExceptionStatus]::ProtocolError
                )
            }

            $errors = $null
            $result = Invoke-NcentralApi -Uri "https://server/api/test" -Method Get -ErrorAction SilentlyContinue -ErrorVariable +errors

            $result | Should -BeNullOrEmpty
            $errors | Should -Not -BeNullOrEmpty
            $errors[0].ToString() | Should -Match "Server error"
        }
    }
}

Describe "Show-Warning" {
    BeforeAll {
        . "$PSScriptRoot\..\Internal\Helpers.ps1"
    }

    It "Writes a fixed warning message" {
        $result = & {
            $WarningPreference = "Continue"
            Show-Warning 3>&1  # redirect warning stream to success stream
        }
        $result | Should -Be "This feature is still in preview and is subject to change in future versions."
    }
}