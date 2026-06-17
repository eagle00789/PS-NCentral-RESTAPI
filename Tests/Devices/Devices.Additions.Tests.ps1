Describe "Devices additions" {
    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\Devices\New-NcentralDevice.ps1"
        . "$PSScriptRoot\..\..\Devices\Remove-NcentralDevice.ps1"
        . "$PSScriptRoot\..\..\Devices\Set-NcentralDeviceAssetsLifecycleInfo.ps1"
        . "$PSScriptRoot\..\..\Devices\Update-NcentralDeviceAssetsLifecycleInfo.ps1"
        . "$PSScriptRoot\..\..\Devices\Get-NcentralDeviceNotes.ps1"
        . "$PSScriptRoot\..\..\Devices\New-NcentralDeviceNote.ps1"
        . "$PSScriptRoot\..\..\Devices\Remove-NcentralDeviceNoteBatch.ps1"
        . "$PSScriptRoot\..\..\Devices\Set-NcentralDeviceNote.ps1"
        . "$PSScriptRoot\..\..\Devices\Remove-NcentralDeviceNote.ps1"
        . "$PSScriptRoot\..\..\Devices\New-NcentralDeviceNoteBatch.ps1"
        $script:BaseUrl = "https://server"
    }

    BeforeEach {
        Mock Invoke-NcentralApi { return @{ data = @("n1"); ok = $true } }
    }

    It "device CRUD and lifecycle commands call the expected methods" {
        $null = New-NcentralDevice -Body @{ name = "server01" }
        $null = Remove-NcentralDevice -DeviceID 10 -Confirm:$false
        $null = Set-NcentralDeviceAssetsLifecycleInfo -DeviceID 10 -Body @{ field = "a" }
        $null = Update-NcentralDeviceAssetsLifecycleInfo -DeviceID 10 -Body @{ field = "b" }
        Assert-MockCalled Invoke-NcentralApi -Times 4
    }

    It "device note commands target the notes endpoints" {
        $notes = Get-NcentralDeviceNotes -DeviceID 10
        $notes | Should -Be @("n1")
        $null = New-NcentralDeviceNote -DeviceID 10 -Body @{ note = "a" }
        $null = Remove-NcentralDeviceNoteBatch -DeviceID 10 -Body @{ noteIds = @(1) } -Confirm:$false
        $null = Set-NcentralDeviceNote -DeviceID 10 -NoteID 1 -Body @{ note = "b" }
        $null = Remove-NcentralDeviceNote -DeviceID 10 -NoteID 1 -Confirm:$false
        $null = New-NcentralDeviceNoteBatch -Body @{ note = "c"; deviceIds = @(10) }
        Assert-MockCalled Invoke-NcentralApi -Times 6
    }
}
