Describe "PS-NCentral-RESTAPI module" {
    BeforeAll {
        $modulePath = Join-Path $PSScriptRoot '..\PS-NCentral-RESTAPI.psd1'
        Import-Module $modulePath -Force
    }

    AfterAll {
        Remove-Module PS-NCentral-RESTAPI -Force -ErrorAction SilentlyContinue
    }

    It "exports the maintenance window command" {
        Get-Command New-NcentralMaintenanceWindow -Module PS-NCentral-RESTAPI |
            Should -Not -BeNullOrEmpty
    }

    It "does not expose internal helper functions" {
        Get-Command Invoke-NcentralApi -Module PS-NCentral-RESTAPI -ErrorAction SilentlyContinue |
            Should -BeNullOrEmpty
    }

    It "exports every function declared in the manifest" {
        $manifest = Import-PowerShellDataFile (Join-Path $PSScriptRoot '..\PS-NCentral-RESTAPI.psd1')
        $exported = Get-Command -Module PS-NCentral-RESTAPI | Select-Object -ExpandProperty Name

        $manifest.FunctionsToExport | ForEach-Object {
            $_ | Should -BeIn $exported
        }
    }
}
