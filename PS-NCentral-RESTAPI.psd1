@{
    RootModule = 'PS-NCentral-RESTAPI.psm1'
    ModuleVersion = '0.2.4'
    GUID = 'b3f4c223-5dd6-4de4-a6c1-5f6e7d71c505'
    Author = 'eagle00789'
    Description = 'PowerShell module for the N-central REST-API'
	PowerShellVersion = '5.1'
    FunctionsToExport = @('Connect-Ncentral', 'Get-NcentralApiServerInfo', 'New-NcentralCustomer', 'Get-NcentralCustomProperties', 'Get-NcentralApiServerHealth', 'Get-NcentralApiServerInfoExtra')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{}
}
