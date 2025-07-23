![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/eagle00789/PS-NCentral-RESTAPI/publish.yml)

# PS-NCentral-RESTAPI
This module will be expanded to allow for the full range of N-Central Rest API functions to be included.

## PREVIEW API Endpoints
All endpoints that are currently marked as preview in the API of N-Central, will always output a warning on the console stating that the endpoint is still a preview.

## Remaining Categories
The list below is based on the NFR unit running N-Central 2025.3.1.1 provider by N-Able
Behind each category is a number defining how many API endpoints are remaining of the total number of API endpoints are in that category
- Access Groups (5/5)
- Active Issues (1/1)
- API-Service (3/5)
- Authentication (3/4)
- Custom Properties (8/9)
- Device Filters (1/1)
- Device Tasks (1/1)
- Devices (10/10)
- Job Statuses (1/1)
- Maintenance Windows (4/4)
- Organisation Units (13/14)
- PSA (5/5)
- Registration Tokens (3/3)
- Scheduled Tasks (5/5)
- User Roles (3/3)
- Users (2/2)

Total Endpoints: 73
Finished Endpoints: 5

## Contribute
If you would like to contribute, then please follow the below guide.
1. Fork this repository
2. If needed, create a new folder with the API Category as name.
3. Inside the folder, create a new file PER api endpoint. We are aware that this will create many files, but it makes managing the API structure much easier.
4. Inside your file, always create a proper header so that the Get-Help command lists usefull information
5. ALWAYS include [cmdletbinding()] in your new API Endpoint function
6. If a API Endpoint you are including still has been marked as PREVIEW in the API, the include the line Show-Warning below your parameter section if present, or after [cmdletbinding()] if no parameters are present.
7. Update the PS-NCentral-RESTAPI.psd1 to include your new folder\file in the FileList
8. Add your name to the authors list below in this README.md file
9. Create a pull request and include a clear description of which API you added to this module

## Authors
- [eagle00789](https://github.com/eagle00789)
- Add your clickable username here. It should point to your GitHub account. 