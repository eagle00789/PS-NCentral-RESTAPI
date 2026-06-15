Describe "Invoke-NcentralApi" {
    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
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

        It "Appends encoded query parameters to Uri" {
            $script:CapturedUri = $null
            Mock Invoke-RestMethod {
                $script:CapturedUri = $Uri
                return "ok"
            }

            $null = Invoke-NcentralApi -Uri "https://server/api/test" -Method "GET" -Query @{
                id = 42
                name = "bob smith"
                filter = "x&y"
            }

            Assert-MockCalled Invoke-RestMethod -Times 1
            $script:CapturedUri.AbsoluteUri |
                Should -Be "https://server/api/test?filter=x%26y&id=42&name=bob%20smith"
        }

        It "Appends query parameters with an ampersand when the Uri already has a query" {
            Mock Invoke-RestMethod { return "ok" }

            $null = Invoke-NcentralApi -Uri "https://server/api/test?existing=true" -Method "GET" -Query @{ id = 42 }

            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter {
                $Uri -eq "https://server/api/test?existing=true&id=42"
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
        It "Throws a clear error when 401 unauthorized occurs" {
            Mock Invoke-RestMethod {
                $ex = New-Object Exception "Unauthorized"
                $status = New-Object PSObject -Property @{ value__ = [int][System.Net.HttpStatusCode]::Unauthorized }
                $resp = New-Object PSObject -Property @{ StatusCode = $status }
                $ex | Add-Member -MemberType NoteProperty -Name Response -Value $resp
                throw $ex
            }

            { Invoke-NcentralApi -Uri "https://server/api/test" -Method "GET" } |
                Should -Throw "*Authentication failed or expired*"
        }

        It "Throws a clear error when the API rate limit is exceeded" {
            Mock Invoke-RestMethod {
                $resp = New-Object PSObject -Property @{
                    StatusCode = New-Object PSObject -Property @{ value__ = 429 }
                }
                $ex = New-Object Exception "Rate limit"
                Add-Member -InputObject $ex -MemberType NoteProperty -Name Response -Value $resp
                throw $ex
            }

            { Invoke-NcentralApi -Uri "https://server/api/test" -Method GET } |
                Should -Throw "*Rate limit exceeded*"
        }

        It "Throws when the server returns an error" {
            Mock -CommandName Invoke-RestMethod {
                throw [System.Net.WebException]::new(
                    "Server error",
                    [System.Net.WebExceptionStatus]::ProtocolError
                )
            }

            { Invoke-NcentralApi -Uri "https://server/api/test" -Method Get } |
                Should -Throw "*Server error*"
        }

        It "Does not pass -Body when none is provided" {
            Mock Invoke-RestMethod { return "ok" }

            $null = Invoke-NcentralApi -Uri "https://server/api/test" -Method "GET"

            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter {
                -not ($PSBoundParameters.ContainsKey("Body"))
            }
        }

        It "Converts body object to JSON string" {
            Mock Invoke-RestMethod { return "ok" }

            $body = @{ key = "value" }
            $null = Invoke-NcentralApi -Uri "https://server/api/test" -Method "POST" -Body $body

            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter {
                $Body -match '"key":\s*"value"'
            }
        }

        It "Handles exceptions without HTTP status code" {
            Mock Invoke-RestMethod { throw (New-Object Exception "Some other error") }

            { Invoke-NcentralApi -Uri "https://server/api/test" -Method GET } |
                Should -Throw "*Some other error*"
        }

        It "Throws before making a request when no access token is available" {
            $script:AccessToken = $null
            Mock Invoke-RestMethod { return "not called" }

            { Invoke-NcentralApi -Uri "https://server/api/test" -Method "GET" } |
                Should -Throw "*Not connected to N-Central*"
            Assert-MockCalled Invoke-RestMethod -Times 0
        }
    }
}

Describe "Show-Warning" {
    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
    }

    It "Writes a fixed warning message" {
        $result = & {
            $WarningPreference = "Continue"
            Show-Warning 3>&1  # redirect warning stream to success stream
        }
        $result | Should -Be "This feature is still in preview and is subject to change in future versions."
    }
}
