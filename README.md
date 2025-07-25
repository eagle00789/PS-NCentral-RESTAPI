# PS-NCentral-RESTAPI

![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/eagle00789/PS-NCentral-RESTAPI/publish.yml)
![GitHub contributors](https://img.shields.io/github/contributors-anon/eagle00789/PS-NCentral-RESTAPI)
![PowerShell Gallery Downloads](https://img.shields.io/powershellgallery/dt/PS-NCentral-RESTAPI?label=PS%20Gallery%20downloads)

This module will be expanded to allow for the full range of N-Central Rest API functions to be included.

## Powershell Gallery

This module is published on the powershell gallery, however the version on Powershell Gallery my nopt be the same as the version on GitHub

## PREVIEW API Endpoints

All endpoints that are currently marked as preview in the API of N-Central, will always output a warning on the console stating that the endpoint is still a preview.

## Remaining Categories

The list below is based on the NFR unit running N-Central 2025.3.1.1 provided by N-Able.

Behind each category is a number defining how many API endpoints are remaining of the total number of API endpoints are in that category
- Access Groups (4/5)
  - POST /api/org-units/{orgUnitId}/device-access-groups
  - GET /api/org-units/{orgUnitId}/access-groups
  - POST /api/org-units/{orgUnitId}/access-groups
  - ~~GET /api/access-groups > won't be implemented as it only returns a list of available endpoints~~
  - GET /api/access-groups/{accessGroupId}
- Active Issues (0/1)
  - GET /api/org-units/{orgUnitId}/active-issues > Get-NcentralActiveIssues
- API-Service (0/5)
  - ~~POST /api/server-info/extra/authenticated > Won't be implemented as it's a duplicate of the API Endpoint /api/server-info/extra with extra steps.~~
  - ~~GET /api > won't be implemented as it only returns a list of available endpoints~~
  - GET /api/server-info > Get-NcentralApiServerInfo
  - GET /api/server-info/extra > Get-NCentralApiServerInfoExtra
  - GET /api/health > Get-NcentralApiServerHealth
- Authentication (0/4)
  - POST /api/auth/refresh > Get-NcentralAuthenticationRefresh
  - POST /api/auth/authenticate > Connect-Ncentral
  - ~~GET /api/auth > won't be implemented as it only returns a list of available endpoints~~
  - GET /api/auth/validate > Get-NcentralAuthenticationValidation
- Custom Properties (8/9)
  - PUT /api/org-units/{orgUnitId}/org-custom-property-defaults
  - GET /api/org-units/{orgUnitId}/custom-properties/{propertyId}
  - PUT /api/org-units/{orgUnitId}/custom-properties/{propertyId}
  - GET /api/devices/{deviceId}/custom-properties/{propertyId}
  - PUT /api/devices/{deviceId}/custom-properties/{propertyId}
  - GET /api/org-units/{orgUnitId}/org-custom-property-defaults/{propertyId}
  - GET /api/org-units/{orgUnitId}/custom-properties > Get-NcentralCustomProperties
  - GET /api/org-units/{orgUnitId}/custom-properties/device-custom-property-defaults/{propertyId}
  - GET /api/devices/{deviceId}/custom-properties
- Device Filters (1/1)
  - GET /api/device-filters
- Device Tasks (1/1)
  - GET /api/devices/{deviceId}/scheduled-tasks
- Devices (11/11)
  - GET /api/devices/{deviceId}/assets/lifecycle-info
  - PUT /api/devices/{deviceId}/assets/lifecycle-info
  - PATCH /api/devices/{deviceId}/assets/lifecycle-info
  - POST /api/device
  - GET /api/org-units/{orgUnitId}/devices
  - GET /api/devices
  - GET /api/devices/{deviceId}
  - GET /api/devices/{deviceId}/service-monitor-status
  - GET /api/devices/{deviceId}/assets
  - GET /api/devices/{deviceId}/activation-key
  - GET /api/appliance-tasks/{taskId}
- Job Statuses (1/1)
  - GET /api/org-units/{orgUnitId}/job-statuses
- Maintenance Windows (4/4)
  - PUT /api/devices/maintenance-windows
  - POST /api/devices/maintenance-windows
  - DELETE /api/devices/maintenance-windows
  - GET /api/devices/{deviceId}/maintenance-windows
- Organisation Units (13/14)
  - GET /api/service-orgs
  - POST /api/service-orgs
  - GET /api/service-orgs/{soId}/customers
  - POST /api/service-orgs/{soId}/customers > New-NcentralCustomer
  - GET /api/customers/{customerId}/sites
  - POST /api/customers/{customerId}/sites
  - GET /api/sites
  - GET /api/sites/{siteId}
  - GET /api/service-orgs/{soId}
  - GET /api/org-units
  - GET /api/org-units/{orgUnitId}
  - GET /api/org-units/{orgUnitId}/children
  - GET /api/customers
  - GET /api/customers/{customerId}
- PSA (2/5)
  - POST /api/standard-psa/{psaType}/credential
  - POST /api/custom-psa/tickets/{customPsaTicketId}
  - ~~GET /api/standard-psa > won't be implemented as it only returns a list of available endpoints~~
  - ~~GET /api/custom-psa > won't be implemented as it only returns a list of available endpoints~~
  - ~~GET /api/custom-psa/tickets > won't be implemented as it only returns a list of available endpoints~~
- Registration Tokens (0/3)
  - GET /api/sites/{siteId}/registration-token > Get-NcentralRegistrationToken
  - GET /api/org-units/{orgUnitId}/registration-token > Get-NcentralRegistrationToken
  - GET /api/customers/{customerId}/registration-token > Get-NcentralRegistrationToken
- Scheduled Tasks (4/5)
  - POST /api/scheduled-tasks/direct
  - ~~GET /api/scheduled-tasks > won't be implemented as it only returns a list of available endpoints~~
  - GET /api/scheduled-tasks/{taskId}
  - GET /api/scheduled-tasks/{taskId}/status
  - GET /api/scheduled-tasks/{taskId}/status/details
- User Roles (1/3)
  - GET /api/org-units/{orgUnitId}/user-roles > Get-NcentralUserRoles
  - POST /api/org-units/{orgUnitId}/user-roles
  - GET /api/org-units/{orgUnitId}/user-roles/{userRoleId} > Get-NcentralUserRoles
- Users (0/2)
  - ~~GET /api/users > won't be implemented as it only returns a list of available endpoints~~
  - GET /api/org-units/{orgUnitId}/users > Get-NcentralUsers

Total Endpoints: 74

Finished Endpoints (including the endpoints that won't be implemented): 24

## Contribute

If you would like to contribute, then please follow the below guide.

1. Fork this repository
2. If needed, create a new folder with the API Category as name.
3. Inside the folder, create a new file PER api endpoint. We are aware that this will create many files, but it makes managing the API structure much easier.
4. Inside your file, always create a proper header so that the Get-Help command lists usefull information
5. ALWAYS include [cmdletbinding()] in your new API Endpoint function
6. If a API Endpoint you are including still has been marked as PREVIEW in the API, the include the line Show-Warning below your parameter section if present, or after [cmdletbinding()] if no parameters are present.
7. Update the PS-NCentral-RESTAPI.psd1 to include your new function in the FunctionsToExport
8. Add your name to the authors list below in this README.md file
9. Create a pull request and include a clear description of which API you added to this module

## Authors

- [eagle00789](https://github.com/eagle00789)
- [CasperStekelenburg](https://github.com/CasperStekelenburg)
