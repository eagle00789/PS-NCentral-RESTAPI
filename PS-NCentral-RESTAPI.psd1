@{
    RootModule = 'PS-NCentral-RESTAPI.psm1'
    ModuleVersion = '1.0.1'
    GUID = 'b3f4c223-5dd6-4de4-a6c1-5f6e7d71c505'
    Author = 'eagle00789'
    Description = 'PowerShell module for the N-central REST-API'
	PowerShellVersion = '5.1'
    FunctionsToExport = @(
        'Connect-Ncentral',
        'Connect-NcentralSso',
        'Disconnect-Ncentral',
        'Get-NcentralAccessGroup',
        'Get-NcentralAccessGroups',
        'Get-NcentralActiveIssues',
        'Get-NcentralApiServerHealth',
        'Get-NcentralApiServerInfo',
        'Get-NcentralApiServerInfoExtra',
        'Get-NcentralApiServerInfoExtraAuthenticated',
        'Get-NcentralApplianceTask',
        'Get-NcentralAuthenticationRefresh',
        'Get-NcentralAuthenticationValidation',
        'Get-NcentralCustomerLimits',
        'Get-NcentralCustomer',
        'Get-NcentralCustomers',
        'Get-NcentralCustomerSites',
        'Get-NcentralCustomPsaTicket',
        'Get-NcentralCustomPsaTicketWithCredential',
        'Get-NcentralCustomProperties',
        'Get-NcentralDevice',
        'Get-NcentralDeviceActivationKey',
        'Get-NcentralDeviceAssets',
        'Get-NcentralDeviceAssetsLifecycleInfo',
        'Get-NcentralDeviceCustomProperties',
        'Get-NcentralDeviceCustomProperty',
        'Get-NcentralDeviceCustomPropertyDefault',
        'Get-NcentralDeviceFilters',
        'Get-NcentralDeviceNotes',
        'Get-NcentralDevices',
        'Get-NcentralDeviceServiceMonitorStatus',
        'Get-NcentralDeviceTasks',
        'Get-NcentralJobStatuses',
        'Get-NcentralMaintenanceWindows',
        'Get-NcentralOrganizationUnitCustomProperty',
        'Get-NcentralOrganizationUnitCustomPropertyDefault',
        'Get-NcentralOrganizationUnit',
        'Get-NcentralOrganizationUnitChildren',
        'Get-NcentralOrganizationUnits',
        'Get-NcentralPatchComparisonReport',
        'Get-NcentralPsaCompanies',
        'Get-NcentralPsaContacts',
        'Get-NcentralPsaCustomerMappingDeprecated',
        'Get-NcentralPsaCustomerMappings',
        'Get-NcentralPsaSites',
        'Get-NcentralRegistrationToken',
        'Get-NcentralScheduledTask',
        'Get-NcentralScheduledTaskStatus',
        'Get-NcentralScheduledTaskStatusDetails',
        'Get-NcentralServerTime',
        'Get-NcentralServiceOrganization',
        'Get-NcentralServiceOrganizations',
        'Get-NcentralServiceOrganizationsCustomers',
        'Get-NcentralSite',
        'Get-NcentralSites',
        'Get-NcentralSoftwareInstallers',
        'Get-NcentralUserSelf',
        'Get-NcentralUserRoles',
        'Get-NcentralUsers',
        'Invoke-NcentralAuthenticationLogout',
        'New-NcentralAccessGroup',
        'New-NcentralCustomer',
        'New-NcentralCustomPsaTicket',
        'New-NcentralDevice',
        'New-NcentralDeviceAccessGroup',
        'New-NcentralDeviceNote',
        'New-NcentralDeviceNoteBatch',
        'New-NcentralDirectScheduledTask',
        #'New-NcentralMaintenanceWindow',
        'New-NcentralPatchComparisonReport',
        'New-NcentralServiceOrganization',
        'New-NcentralSite',
        'New-NcentralSoftwareInstallerDownloadLink',
        'New-NcentralUserRole',
        'Remove-NcentralDevice',
        'Remove-NcentralDeviceNote',
        'Remove-NcentralDeviceNoteBatch',
        'Remove-NcentralMaintenanceWindows',
        'Reopen-NcentralCustomPsaTicket',
        'Resolve-NcentralCustomPsaTicket',
        'Set-NcentralCustomerLimits',
        'Set-NcentralDeviceAssetsLifecycleInfo',
        'Set-NcentralDeviceCustomProperty',
        'Set-NcentralDeviceNote',
        'Set-NcentralMaintenanceWindows',
        'Set-NcentralOrganizationUnitCustomProperty',
        'Set-NcentralOrganizationUnitCustomPropertyDefault',
        'Set-NcentralPsaCustomerMappings',
        'Test-NcentralPsaCredentials',
        'Update-NcentralDeviceAssetsLifecycleInfo'
    )
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            ProjectUri = 'https://github.com/eagle00789/PS-NCentral-RESTAPI'
            LicenseUri = 'https://github.com/eagle00789/PS-NCentral-RESTAPI/blob/main/LICENSE'
            IconUri = 'https://raw.githubusercontent.com/eagle00789/PS-NCentral-RESTAPI/refs/heads/main/.github/icon-n-central-128x128-fullcolor.png'
            RequireLicenseAcceptance = $true
        }
    }
}
