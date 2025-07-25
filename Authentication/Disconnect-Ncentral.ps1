function Disconnect-Ncentral {
<#
.SYNOPSIS
Disconnect from N-Central

.DESCRIPTION
This function will disconnect from the REST API of N-Central 

.EXAMPLE
Disconnect-Ncentral 

This will disconnect from the NCentral server you previously connected to

#>
    [cmdletbinding()]
	param ()
    $script:AccessToken = $null
    $script:RefreshToken = $null
}