@{
    RootModule = 'PS-NCentral-RESTAPI.psm1'
    ModuleVersion = '0.5.8'
    GUID = 'b3f4c223-5dd6-4de4-a6c1-5f6e7d71c505'
    Author = 'eagle00789'
    Description = 'PowerShell module for the N-central REST-API'
	PowerShellVersion = '5.1'
    FunctionsToExport = @(
        'Connect-Ncentral',
        'Disconnect-Ncentral',
        'Get-NcentralAccessGroup',
        'Get-NcentralAccessGroups',
        'Get-NcentralActiveIssues',
        'Get-NcentralApiServerHealth',
        'Get-NcentralApiServerInfo',
        'Get-NcentralApiServerInfoExtra',
        'Get-NcentralAuthenticationRefresh',
        'Get-NcentralAuthenticationValidation',
        'Get-NcentralCustomerSites',
        'Get-NcentralCustomProperties',
        'Get-NcentralDevice',
        'Get-NcentralDeviceActivationKey',
        'Get-NcentralDeviceAssets',
        'Get-NcentralDeviceAssetsLifecycleInfo',
        'Get-NcentralDeviceFilters',
        'Get-NcentralDevices',
        'Get-NcentralDeviceServiceMonitorStatus',
        'Get-NcentralDeviceTasks',
        'Get-NcentralMaintenanceWindows',
        'Get-NcentralRegistrationToken',
        'Get-NcentralScheduledTask',
        'Get-NcentralScheduledTaskStatus',
        'Get-NcentralScheduledTaskStatusDetails',
        'Get-NcentralServiceOrganisations',
        'Get-NcentralServiceOrganisationsCustomers',
        'Get-NcentralSite',
        'Get-NcentralSites',
        'Get-NcentralUserRoles',
        'Get-NcentralUsers',
        'New-NcentralCustomer'
    )
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            ProjectUri = 'https://github.com/eagle00789/PS-NCentral-RESTAPI'
            LicenseUri = 'https://github.com/eagle00789/PS-NCentral-RESTAPI/blob/main/LICENSE'
            IconUri = 'https://raw.githubusercontent.com/eagle00789/PS-NCentral-RESTAPI/refs/heads/main/.github/icon-n-central-128x128-fullcolor.png'
        }
    }
}
