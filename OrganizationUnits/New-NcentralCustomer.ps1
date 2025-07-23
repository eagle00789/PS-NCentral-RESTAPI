function New-NcentralCustomer {
<#
.SYNOPSIS
Creates a new customer record via an API call.

.DESCRIPTION
This function submits customer information to a specified API endpoint. 
The only required field is customerName. All other fields are optional.

.PARAMETER SoId
Optional. The Service Organization ID. Defaults to 50 if not specified.

.PARAMETER customerName
Required. The name of the customer.

.PARAMETER contactFirstName
Optional. First name of the contact person.

.PARAMETER contactLastName
Optional. Last name of the contact person.

.PARAMETER externalId
Optional. External identifier for the customer.

.PARAMETER phone
Optional. Phone number for the customer.

.PARAMETER contactTitle
Optional. Title of the contact person.

.PARAMETER contactEmail
Optional. Email address of the contact person.

.PARAMETER contactPhone
Optional. Phone number of the contact person.

.PARAMETER contactPhoneExt
Optional. Phone extension for the contact person.

.PARAMETER contactDepartment
Optional. Department of the contact person.

.PARAMETER street1
Optional. Street address line 1.

.PARAMETER street2
Optional. Street address line 2.

.PARAMETER city
Optional. City of the customer.

.PARAMETER stateProv
Optional. State or province of the customer.

.PARAMETER country
Optional. Country of the customer.

.PARAMETER postalCode
Optional. Postal code or ZIP of the customer.

.PARAMETER licenseType
Optional. License type assigned to the customer.

.EXAMPLE
New-NcentralCustomer -customerName "Acme Corp" -contactEmail "contact@acme.com"

This example creates a new customer record for Acme Corp with a contact email address.

#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $false)]
        [int]$SoId = 50,

        [Parameter(Mandatory = $true)]
        [string]$customerName,

        [Parameter(Mandatory = $false)]
        [string]$contactFirstName,

        [Parameter(Mandatory = $false)]
        [string]$contactLastName,

        [Parameter(Mandatory = $false)]
        [string]$externalId,

        [Parameter(Mandatory = $false)]
        [string]$phone,

        [Parameter(Mandatory = $false)]
        [string]$contactTitle,

        [Parameter(Mandatory = $false)]
        [string]$contactEmail,

        [Parameter(Mandatory = $false)]
        [string]$contactPhone,

        [Parameter(Mandatory = $false)]
        [string]$contactPhoneExt,

        [Parameter(Mandatory = $false)]
        [string]$contactDepartment,

        [Parameter(Mandatory = $false)]
        [string]$street1,

        [Parameter(Mandatory = $false)]
        [string]$street2,

        [Parameter(Mandatory = $false)]
        [string]$city,

        [Parameter(Mandatory = $false)]
        [string]$stateProv,

        [Parameter(Mandatory = $false)]
        [string]$country,

        [Parameter(Mandatory = $false)]
        [string]$postalCode,

        [Parameter(Mandatory = $false)]
        [string]$licenseType
    )

    Show-Warning

    $body = @{
        customerName      = $customerName
        contactFirstName  = $contactFirstName
        contactLastName   = $contactLastName
        externalId        = $externalId
        phone             = $phone
        contactTitle      = $contactTitle
        contactEmail      = $contactEmail
        contactPhone      = $contactPhone
        contactPhoneExt   = $contactPhoneExt
        contactDepartment = $contactDepartment
        street1           = $street1
        street2           = $street2
        city              = $city
        stateProv         = $stateProv
        country           = $country
        postalCode        = $postalCode
        licenseType       = $licenseType
    }

    # Remove null or empty values from the body
    foreach ($key in $body.Keys.Clone()) {
        if ($null -eq $body[$key] -or $body[$key] -eq "") {
            $body.Remove($key)
        }
    }
    $uri = "$script:BaseUrl/api/service-orgs/$SoId/customers"
    return Invoke-NcentralApi -Uri $uri -Method "POST" -Body $Body
}