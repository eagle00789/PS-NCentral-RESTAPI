# PS-NCentral-RESTAPI

![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/eagle00789/PS-NCentral-RESTAPI/publish.yml)
![GitHub contributors](https://img.shields.io/github/contributors-anon/eagle00789/PS-NCentral-RESTAPI)
![PowerShell Gallery Downloads](https://img.shields.io/powershellgallery/dt/PS-NCentral-RESTAPI?label=PS%20Gallery%20downloads)

This module will be expanded to allow for the full range of N-Central Rest API functions to be included.

## Powershell Gallery

This module is published on the powershell gallery, however the version on Powershell Gallery my not be the same as the version on GitHub.
The Powershell Gallery version can be found at [Powershell Gallery](https://www.powershellgallery.com/packages/PS-NCentral-RESTAPI)

## AI Usage

AI has been used to write all the corresponding pester tests that is done before uploading the package to the gallery.

## PREVIEW API Endpoints

> [!WARNING]
> All endpoints that are currently marked as preview in the API of N-Central, will always output a warning on the console stating that the endpoint is still a preview.

## Endpoint Coverage

The list below is based on the live NFR API Explorer for N-Central 2026.3.0.11.

The explorer currently exposes 101 operations in total.

- 8 operations are intentionally not implemented in this module because they only return a link collection of child endpoints:
  - `GET /api`
  - `GET /api/access-groups`
  - `GET /api/auth`
  - `GET /api/custom-psa`
  - `GET /api/custom-psa/tickets`
  - `GET /api/scheduled-tasks`
  - `GET /api/standard-psa`
  - `GET /api/users`
- 93 non-link operations remain after excluding those discovery endpoints.
- 92 of those non-link operations are currently exported by this module.
- `New-NcentralMaintenanceWindow` is intentionally not exported right now because `POST /api/devices/maintenance-windows` is not fully finished yet, based on clarification from N-able.

Category breakdown:

- [x] Access Groups (5/5, including 1 link-collection endpoint intentionally skipped)
- [x] Active Issues (1/1)
- [x] API-Service (6/6, including 1 link-collection endpoint intentionally skipped)
- [x] Authentication (6/6, including 1 link-collection endpoint intentionally skipped)
- [x] Custom Properties (9/9)
- [x] Device Filters (1/1)
- [x] Device Tasks (1/1)
- [x] Devices (18/18)
- [x] Job Statuses (1/1)
- [ ] Maintenance Windows (3/4)
- [x] Organisation Units (16/16)
- [x] Patch Reports (2/2)
- [x] PSA (15/15, including 3 link-collection endpoints intentionally skipped)
- [x] Registration Tokens (3/3)
- [x] Scheduled Tasks (5/5, including 1 link-collection endpoint intentionally skipped)
- [x] Software Installers (2/2)
- [x] User Roles (3/3)
- [x] Users (3/3, including 1 link-collection endpoint intentionally skipped)

## Future enhancements

Nearly all non-link endpoints currently exposed by the live API Explorer are now built into this module.
The current exception is `POST /api/devices/maintenance-windows`, which remains unfinished and is therefore not exported at this time.
Some paged endpoints still do not expose every optional explorer parameter such as `select`.

## Recently Added Endpoints

The module now also includes commands for additional endpoint groups that were previously missing:

- Authentication: SSO connect and API logout
- API-Service: authenticated extra server info and server time
- Access Groups: create organization and device access groups
- Custom Properties: device-level and default property retrieval and updates
- Devices: create/delete device, lifecycle updates, appliance task lookup, and device notes operations
- Job Statuses: organization unit job status retrieval
- Maintenance Windows: modify and delete maintenance windows
- Organization Units: customer/service organization/site/customer limits operations
- Patch Reports: create and retrieve patch comparison reports
- Scheduled Tasks: direct task creation
- Software Installers: list installers and generate download links
- Standard PSA: credential validation, mappings, companies, contacts and sites
- Custom PSA: create, retrieve, reopen and resolve custom PSA tickets
- Users: authenticated user profile
- User Roles: preview user role creation

Preview warnings are now only shown for endpoints that are still marked as preview in the live API Explorer.

## Contribute

If you would like to contribute, then please read our [CONTRIBUTING](./.github/CONTRIBUTING.md) document

## Authors

- [eagle00789](https://github.com/eagle00789)
- [CasperStekelenburg](https://github.com/CasperStekelenburg)
