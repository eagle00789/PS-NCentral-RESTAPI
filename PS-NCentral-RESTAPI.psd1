@{
    RootModule = 'PS-NCentral-RESTAPI.psm1'
    ModuleVersion = '0.4.0'
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
        'Get-NcentralCustomProperties',
        'Get-NcentralDeviceFilters',
        'Get-NcentralDeviceTasks',
        'Get-NcentralMaintenanceWindows',
        'Get-NcentralRegistrationToken',
        'Get-NcentralScheduledTask',
        'Get-NcentralScheduledTaskStatus',
        'Get-NcentralScheduledTaskStatusDetails',
        'Get-NcentralUserRoles',
        'Get-NcentralUsers',
        'New-NcentralCustomer'
    )
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{}
}
