@{
    RootModule = 'PS-NCentral-RESTAPI.psm1'
    ModuleVersion = '0.2.2'
    GUID = 'b3f4c223-5dd6-4de4-a6c1-5f6e7d71c505'
    Author = 'eagle00789'
    Description = 'PowerShell module for the N-central REST-API'
	PowerShellVersion = '5.1'
    FunctionsToExport = @('Connect-Ncentral', 'Get-NcentralApiServerInfo', 'New-NcentralCustomer', 'Get-NcentralCustomProperties', 'Get-NcentralApiServerHealth')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{}
    FileList = @(
        'LICENSE',
	'PS-NCentral-RESTAPI.psd1',
	'PS-NCentral-RESTAPI.psm1',
	'README.md',
 	'Internal\Helpers.ps1'
	'API-Service\Get-NcentralApiServerHealth.ps1',
	'API-Service\Get-NcentralApiServerInfo.ps1',
	'CustomProperties\Get-NcentralCustomProperties.ps1',
	'OrganizationUnits\New-NcentralCustomer.ps1'
    )
}
