@{
    RootModule = 'PS-NCentral-RESTAPI.psm1'
    ModuleVersion = '0.3.8'
    GUID = 'b3f4c223-5dd6-4de4-a6c1-5f6e7d71c505'
    Author = 'eagle00789'
    Description = 'PowerShell module for the N-central REST-API'
	PowerShellVersion = '5.1'
    FunctionsToExport = @(
        'Connect-Ncentral',
        'Disconnect-Ncentral',
        'Get-NcentralApiServerInfo',
        'New-NcentralCustomer',
        'Get-NcentralCustomProperties',
        'Get-NcentralApiServerHealth',
        'Get-NcentralApiServerInfoExtra',
        'Get-NcentralAuthenticationValidation',
        'Get-NcentralAuthenticationRefresh',
        'Get-NcentralActiveIssues',
        'Get-NcentralRegistrationToken',
        'Get-NcentralUsers',
        'Get-NcentralUserRoles',
        'Get-NcentralMaintenanceWindows',
        'Get-NcentralAccessGroups',
        'Get-NcentralAccessGroup',
        'Get-NcentralDeviceFilters',
        'Get-NcentralDeviceTasks',
        'Get-NcentralScheduledTask',
        'Get-NcentralScheduledTaskStatus',
        'Get-NcentralScheduledTaskStatusDetails'
    )
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{}
}
