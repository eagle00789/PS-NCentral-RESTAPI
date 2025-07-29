# PS-NCentral-RESTAPI

![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/eagle00789/PS-NCentral-RESTAPI/publish.yml)
![GitHub contributors](https://img.shields.io/github/contributors-anon/eagle00789/PS-NCentral-RESTAPI)
![PowerShell Gallery Downloads](https://img.shields.io/powershellgallery/dt/PS-NCentral-RESTAPI?label=PS%20Gallery%20downloads)

This module will be expanded to allow for the full range of N-Central Rest API functions to be included.

## Powershell Gallery

This module is published on the powershell gallery, however the version on Powershell Gallery my not be the same as the version on GitHub.
The Powershell Gallery version can be found at [Powershell Gallery](https://www.powershellgallery.com/packages/PS-NCentral-RESTAPI)

## PREVIEW API Endpoints

All endpoints that are currently marked as preview in the API of N-Central, will always output a warning on the console stating that the endpoint is still a preview.

## Remaining Categories

The list below is based on the NFR unit running N-Central 2025.3.1.1 provided by N-Able.

Behind each category is a number defining how many API endpoints are remaining of the total number of API endpoints are in that category
- [ ] Access Groups (2/5)
  - [ ] POST /api/org-units/{orgUnitId}/device-access-groups
  - [x] GET /api/org-units/{orgUnitId}/access-groups > Get-NcentralAccessGroups
  - [ ] POST /api/org-units/{orgUnitId}/access-groups
  - [x] ~~GET /api/access-groups > won't be implemented as it only returns a list of available endpoints~~
  - [x] GET /api/access-groups/{accessGroupId} > Get-NcentralAccessGroup
- [x] Active Issues (0/1)
  - [x] GET /api/org-units/{orgUnitId}/active-issues > Get-NcentralActiveIssues
- [x] API-Service (0/5)
  - [x] ~~POST /api/server-info/extra/authenticated > Won't be implemented as it's a duplicate of the API Endpoint /api/server-info/extra with extra steps.~~
  - [x] ~~GET /api > won't be implemented as it only returns a list of available endpoints~~
  - [x] GET /api/server-info > Get-NcentralApiServerInfo
  - [x] GET /api/server-info/extra > Get-NCentralApiServerInfoExtra
  - [x] GET /api/health > Get-NcentralApiServerHealth
- [x] Authentication (0/4)
  - [x] POST /api/auth/refresh > Get-NcentralAuthenticationRefresh
  - [x] POST /api/auth/authenticate > Connect-Ncentral
  - [x] ~~GET /api/auth > won't be implemented as it only returns a list of available endpoints~~
  - [x] GET /api/auth/validate > Get-NcentralAuthenticationValidation
- Custom Properties (8/9)
  - [ ] PUT /api/org-units/{orgUnitId}/org-custom-property-defaults
  - [ ] GET /api/org-units/{orgUnitId}/custom-properties/{propertyId}
  - [ ] PUT /api/org-units/{orgUnitId}/custom-properties/{propertyId}
  - [ ] GET /api/devices/{deviceId}/custom-properties/{propertyId}
  - [ ] PUT /api/devices/{deviceId}/custom-properties/{propertyId}
  - [ ] GET /api/org-units/{orgUnitId}/org-custom-property-defaults/{propertyId}
  - [x] GET /api/org-units/{orgUnitId}/custom-properties > Get-NcentralCustomProperties
  - [ ] GET /api/org-units/{orgUnitId}/custom-properties/device-custom-property-defaults/{propertyId}
  - [ ] GET /api/devices/{deviceId}/custom-properties
- [x] Device Filters (0/1)
  - [x] GET /api/device-filters > Get-NcentralDeviceFilters
- [x] Device Tasks (0/1)
  - [x] GET /api/devices/{deviceId}/scheduled-tasks > Get-NcentralDeviceTasks
- [ ] Devices (8/11)
  - [ ] GET /api/devices/{deviceId}/assets/lifecycle-info
  - [ ] PUT /api/devices/{deviceId}/assets/lifecycle-info
  - [ ] PATCH /api/devices/{deviceId}/assets/lifecycle-info
  - [ ] POST /api/device
  - [x] GET /api/org-units/{orgUnitId}/devices > Get-NcentralDevices
  - [x] GET /api/devices > Get-NcentralDevices
  - [ ] GET /api/devices/{deviceId}
  - [x] GET /api/devices/{deviceId}/service-monitor-status > Get-NcentralDeviceServiceMonitorStatus
  - [x] GET /api/devices/{deviceId}/assets > Get-NcentralDeviceAssets
  - [ ] GET /api/devices/{deviceId}/activation-key
  - [ ] GET /api/appliance-tasks/{taskId}
- [ ] Job Statuses (1/1)
  - [ ] GET /api/org-units/{orgUnitId}/job-statuses
- [ ] Maintenance Windows (3/4)
  - [ ] PUT /api/devices/maintenance-windows
  - [ ] POST /api/devices/maintenance-windows
  - [ ] DELETE /api/devices/maintenance-windows
  - [x] GET /api/devices/{deviceId}/maintenance-windows > Get-NcentralMaintenanceWindows
- [ ] Organisation Units (13/14)
  - [ ] GET /api/service-orgs
  - [ ] POST /api/service-orgs
  - [ ] GET /api/service-orgs/{soId}/customers
  - [x] POST /api/service-orgs/{soId}/customers > New-NcentralCustomer
  - [ ] GET /api/customers/{customerId}/sites
  - [ ] POST /api/customers/{customerId}/sites
  - [ ] GET /api/sites
  - [ ] GET /api/sites/{siteId}
  - [ ] GET /api/service-orgs/{soId}
  - [ ] GET /api/org-units
  - [ ] GET /api/org-units/{orgUnitId}
  - [ ] GET /api/org-units/{orgUnitId}/children
  - [ ] GET /api/customers
  - [ ] GET /api/customers/{customerId}
- [ ] PSA (2/5)
  - [ ] POST /api/standard-psa/{psaType}/credential
  - [ ] POST /api/custom-psa/tickets/{customPsaTicketId}
  - [x] ~~GET /api/standard-psa > won't be implemented as it only returns a list of available endpoints~~
  - [x] ~~GET /api/custom-psa > won't be implemented as it only returns a list of available endpoints~~
  - [x] ~~GET /api/custom-psa/tickets > won't be implemented as it only returns a list of available endpoints~~
- [x] Registration Tokens (0/3)
  - [x] GET /api/sites/{siteId}/registration-token > Get-NcentralRegistrationToken
  - [x] GET /api/org-units/{orgUnitId}/registration-token > Get-NcentralRegistrationToken
  - [x] GET /api/customers/{customerId}/registration-token > Get-NcentralRegistrationToken
- [ ] Scheduled Tasks (1/5)
  - [ ] POST /api/scheduled-tasks/direct
  - [x] ~~GET /api/scheduled-tasks > won't be implemented as it only returns a list of available endpoints~~
  - [x] GET /api/scheduled-tasks/{taskId} > Get-NcentralScheduledTask
  - [x] GET /api/scheduled-tasks/{taskId}/status > Get-NcentralScheduledTaskStatus
  - [x] GET /api/scheduled-tasks/{taskId}/status/details > Get-NcentralScheduledTaskStatusDetails
- [ ] User Roles (1/3)
  - [x] GET /api/org-units/{orgUnitId}/user-roles > Get-NcentralUserRoles
  - [ ] POST /api/org-units/{orgUnitId}/user-roles
  - [x] GET /api/org-units/{orgUnitId}/user-roles/{userRoleId} > Get-NcentralUserRoles
- [x] Users (0/2)
  - [x] ~~GET /api/users > won't be implemented as it only returns a list of available endpoints~~
  - [x] GET /api/org-units/{orgUnitId}/users > Get-NcentralUsers

Total Endpoints: 74

Finished Endpoints (including the endpoints that won't be implemented): 36

## Future enhancements

Currently not all API endpoints are built into this module. The missing endpoints are still being added to this module.
None of the endpoints that have paging, have the sortby and select parameter implemented. This still has to be implemented.

## Contribute

If you would like to contribute, then please read our [CONTRIBUTING](./.github/CONTRIBUTING.md) document

## Authors

- [eagle00789](https://github.com/eagle00789)
- [CasperStekelenburg](https://github.com/CasperStekelenburg)
