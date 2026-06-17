function Get-NcentralSoftwareInstallers {
<#
.SYNOPSIS
Get software installers for a specific customer

.DESCRIPTION
This function retrieves the available software installers for a given customer

.PARAMETER CustomerID
Required. The customer id.

.PARAMETER SoftwareType
Optional. Filter by software type.

.PARAMETER InstallerType
Optional. Filter by installer type.

.EXAMPLE
Get-NcentralSoftwareInstallers -CustomerID 50 -SoftwareType Agent

This example retrieves software installers for customer 50

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$CustomerID,

        [Parameter(Mandatory = $false)]
        [string]$SoftwareType,

        [Parameter(Mandatory = $false)]
        [string]$InstallerType
    )

    $uri = "$script:BaseUrl/api/customers/$CustomerID/software/installers"
    $query = @{}
    if ($PSBoundParameters.ContainsKey('SoftwareType')) {
        $query.softwareType = $SoftwareType
    }
    if ($PSBoundParameters.ContainsKey('InstallerType')) {
        $query.installerType = $InstallerType
    }
    return Invoke-NcentralApi -Uri $uri -Method "GET" -Query $query
}
