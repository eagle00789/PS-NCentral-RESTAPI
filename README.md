# PS-NCentral-RESTAPI

![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/eagle00789/PS-NCentral-RESTAPI/publish.yml)
![GitHub contributors](https://img.shields.io/github/contributors-anon/eagle00789/PS-NCentral-RESTAPI)
![PowerShell Gallery Downloads](https://img.shields.io/powershellgallery/dt/PS-NCentral-RESTAPI?label=PS%20Gallery%20downloads)

This module will be expanded to allow for the full range of N-Central Rest API functions to be included.

## PREVIEW API Endpoints

All endpoints that are currently marked as preview in the API of N-Central, will always output a warning on the console stating that the endpoint is still a preview.

## Remaining Categories

The list below is based on the NFR unit running N-Central 2025.3.1.1 provider by N-Able.

API Endpoints that only list other links will not be included

Behind each category is a number defining how many API endpoints are remaining of the total number of API endpoints are in that category
- Access Groups (4/4)
- Active Issues (0/1)
- API-Service (0/4)
- Authentication (0/3)
- Custom Properties (8/9)
- Device Filters (1/1)
- Device Tasks (1/1)
- Devices (10/10)
- Job Statuses (1/1)
- Maintenance Windows (4/4)
- Organisation Units (13/14)
- PSA (2/2)
- Registration Tokens (3/3)
- Scheduled Tasks (4/4)
- User Roles (3/3)
- Users (1/1)

Total Endpoints: 65

Finished Endpoints: 10

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
