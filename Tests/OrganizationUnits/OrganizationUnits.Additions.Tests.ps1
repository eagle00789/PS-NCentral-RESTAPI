Describe "Organization Unit additions" {
    BeforeAll {
        . "$PSScriptRoot\..\..\Internal\Helpers.ps1"
        . "$PSScriptRoot\..\..\OrganizationUnits\New-NcentralServiceOrganization.ps1"
        . "$PSScriptRoot\..\..\OrganizationUnits\Get-NcentralServiceOrganization.ps1"
        . "$PSScriptRoot\..\..\OrganizationUnits\New-NcentralSite.ps1"
        . "$PSScriptRoot\..\..\OrganizationUnits\Get-NcentralCustomerLimits.ps1"
        . "$PSScriptRoot\..\..\OrganizationUnits\Set-NcentralCustomerLimits.ps1"
        . "$PSScriptRoot\..\..\AccessGroups\New-NcentralAccessGroup.ps1"
        . "$PSScriptRoot\..\..\AccessGroups\New-NcentralDeviceAccessGroup.ps1"
        . "$PSScriptRoot\..\..\UserRoles\New-NcentralUserRole.ps1"
        $script:BaseUrl = "https://server"
    }

    BeforeEach {
        Mock Invoke-NcentralApi { return @{ ok = $true } }
        Mock Show-Warning {}
    }

    It "service organization and limits commands call the expected endpoints" {
        $null = New-NcentralServiceOrganization -Body @{ soName = "SO" }
        $null = Get-NcentralServiceOrganization -ServiceOrganizationID 50
        $null = Get-NcentralCustomerLimits -OrganizationUnitID 50
        $null = Set-NcentralCustomerLimits -OrganizationUnitID 50 -Body @(@{ limit = 1 })
        Assert-MockCalled Invoke-NcentralApi -Times 4
    }

    It "preview site and user role creation call Show-Warning" {
        $null = New-NcentralSite -CustomerID 50 -Body @{ siteName = "Site A" }
        $null = New-NcentralUserRole -OrganizationUnitID 50 -Body @{ roleName = "Role A" }
        Assert-MockCalled Show-Warning -Times 2
    }

    It "access group creation commands post to their endpoints" {
        $null = New-NcentralAccessGroup -OrganizationUnitID 50 -Body @{ name = "A" }
        $null = New-NcentralDeviceAccessGroup -OrganizationUnitID 50 -Body @{ name = "B" }
        Assert-MockCalled Invoke-NcentralApi -Times 2 -ParameterFilter {
            $Method -eq "POST"
        }
    }
}
