Describe "Integration additions" {
    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\MaintenanceWindows\Set-NcentralMaintenanceWindows.ps1"
        . "$PSScriptRoot\..\..\MaintenanceWindows\Remove-NcentralMaintenanceWindows.ps1"
        . "$PSScriptRoot\..\..\ScheduledTasks\New-NcentralDirectScheduledTask.ps1"
        . "$PSScriptRoot\..\..\PatchReports\New-NcentralPatchComparisonReport.ps1"
        . "$PSScriptRoot\..\..\PatchReports\Get-NcentralPatchComparisonReport.ps1"
        . "$PSScriptRoot\..\..\SoftwareInstallers\Get-NcentralSoftwareInstallers.ps1"
        . "$PSScriptRoot\..\..\SoftwareInstallers\New-NcentralSoftwareInstallerDownloadLink.ps1"
        . "$PSScriptRoot\..\..\StandardPsa\Test-NcentralPsaCredentials.ps1"
        . "$PSScriptRoot\..\..\StandardPsa\Get-NcentralPsaCustomerMappingDeprecated.ps1"
        . "$PSScriptRoot\..\..\StandardPsa\Get-NcentralPsaCustomerMappings.ps1"
        . "$PSScriptRoot\..\..\StandardPsa\Set-NcentralPsaCustomerMappings.ps1"
        . "$PSScriptRoot\..\..\StandardPsa\Get-NcentralPsaCompanies.ps1"
        . "$PSScriptRoot\..\..\StandardPsa\Get-NcentralPsaContacts.ps1"
        . "$PSScriptRoot\..\..\StandardPsa\Get-NcentralPsaSites.ps1"
        . "$PSScriptRoot\..\..\CustomPsa\New-NcentralCustomPsaTicket.ps1"
        . "$PSScriptRoot\..\..\CustomPsa\Get-NcentralCustomPsaTicket.ps1"
        . "$PSScriptRoot\..\..\CustomPsa\Get-NcentralCustomPsaTicketWithCredential.ps1"
        . "$PSScriptRoot\..\..\CustomPsa\Reopen-NcentralCustomPsaTicket.ps1"
        . "$PSScriptRoot\..\..\CustomPsa\Resolve-NcentralCustomPsaTicket.ps1"
        $script:BaseUrl = "https://server"
    }

    BeforeEach {
        Mock Invoke-NcentralApi { return @{ ok = $true; data = @("x") } }
    }

    It "maintenance, scheduled task, report and software installer commands call the API" {
        $null = Set-NcentralMaintenanceWindows -Body @{ scheduleIds = @(1) }
        $null = Remove-NcentralMaintenanceWindows -Body @{ scheduleIds = @(1) } -Confirm:$false
        $null = New-NcentralDirectScheduledTask -Body @{ deviceId = 1 }
        $null = New-NcentralPatchComparisonReport -Body @{ customerId = 50 }
        $null = Get-NcentralPatchComparisonReport -ReportID 100
        $null = Get-NcentralSoftwareInstallers -CustomerID 50 -SoftwareType Agent
        $null = New-NcentralSoftwareInstallerDownloadLink -CustomerID 50 -Body @{ softwareType = "Agent" }
        Assert-MockCalled Invoke-NcentralApi -Times 7
    }

    It "standard PSA commands call the API" {
        $null = Test-NcentralPsaCredentials -PsaType 3 -Body @{ username = "u" }
        $null = Get-NcentralPsaCustomerMappingDeprecated -CustomerID 50
        $null = Get-NcentralPsaCustomerMappings -CustomerID 50
        $null = Set-NcentralPsaCustomerMappings -CustomerID 50 -Body @{ mappings = @() }
        $null = Get-NcentralPsaCompanies -CustomerID 50
        $null = Get-NcentralPsaContacts -CustomerID 50 -PsaCompanyID 60
        $null = Get-NcentralPsaSites -CustomerID 50 -PsaCompanyID 60
        Assert-MockCalled Invoke-NcentralApi -Times 7
    }

    It "custom PSA commands call the API" {
        $null = New-NcentralCustomPsaTicket -Body @{ title = "Issue" }
        $null = Get-NcentralCustomPsaTicket -CustomPsaTicketID 100
        $null = Get-NcentralCustomPsaTicketWithCredential -CustomPsaTicketID 100 -Body @{ username = "u" }
        $null = Reopen-NcentralCustomPsaTicket -CustomPsaTicketID 100
        $null = Resolve-NcentralCustomPsaTicket -CustomPsaTicketID 100
        Assert-MockCalled Invoke-NcentralApi -Times 5
    }
}
