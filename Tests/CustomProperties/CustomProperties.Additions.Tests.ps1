Describe "Custom Properties additions" {
    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\CustomProperties\Get-NcentralDeviceCustomProperties.ps1"
        . "$PSScriptRoot\..\..\CustomProperties\Get-NcentralDeviceCustomProperty.ps1"
        . "$PSScriptRoot\..\..\CustomProperties\Set-NcentralDeviceCustomProperty.ps1"
        . "$PSScriptRoot\..\..\CustomProperties\Get-NcentralOrganizationUnitCustomProperty.ps1"
        . "$PSScriptRoot\..\..\CustomProperties\Set-NcentralOrganizationUnitCustomProperty.ps1"
        . "$PSScriptRoot\..\..\CustomProperties\Get-NcentralDeviceCustomPropertyDefault.ps1"
        . "$PSScriptRoot\..\..\CustomProperties\Get-NcentralOrganizationUnitCustomPropertyDefault.ps1"
        . "$PSScriptRoot\..\..\CustomProperties\Set-NcentralOrganizationUnitCustomPropertyDefault.ps1"
        $script:BaseUrl = "https://server"
    }

    It "Get-NcentralDeviceCustomProperties calls the list endpoint" {
        Mock Invoke-NcentralApi { return @{ data = @("p1") } }
        $result = Get-NcentralDeviceCustomProperties -DeviceID 10
        $result | Should -Be @("p1")
    }

    It "Get-NcentralDeviceCustomProperty calls the single property endpoint" {
        Mock Invoke-NcentralApi { return @{ value = "abc" } }
        $result = Get-NcentralDeviceCustomProperty -DeviceID 10 -PropertyID 20
        $result.value | Should -Be "abc"
    }

    It "Set-NcentralDeviceCustomProperty uses PUT" {
        Mock Invoke-NcentralApi { return @{ ok = $true } }
        $null = Set-NcentralDeviceCustomProperty -DeviceID 10 -PropertyID 20 -Body @{ value = "x" }
        Assert-MockCalled Invoke-NcentralApi -Times 1 -ParameterFilter {
            $Method -eq "PUT" -and $Uri -eq "https://server/api/devices/10/custom-properties/20"
        }
    }

    It "Organization unit custom property commands target the correct endpoints" {
        Mock Invoke-NcentralApi { return @{ ok = $true } }
        $null = Get-NcentralOrganizationUnitCustomProperty -OrganizationUnitID 50 -PropertyID 60
        $null = Set-NcentralOrganizationUnitCustomProperty -OrganizationUnitID 50 -PropertyID 60 -Body @{ value = "x" }
        $null = Get-NcentralDeviceCustomPropertyDefault -OrganizationUnitID 50 -PropertyID 60
        $null = Get-NcentralOrganizationUnitCustomPropertyDefault -OrganizationUnitID 50 -PropertyID 60
        $null = Set-NcentralOrganizationUnitCustomPropertyDefault -OrganizationUnitID 50 -Body @{ propertyId = 60 }
        Assert-MockCalled Invoke-NcentralApi -Times 5
    }
}
