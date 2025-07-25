# How to contribute

I'm really glad you're reading this, because we need volunteer developers to help this project come to fruition.

## Quick guide
1. Fork this repository
2. If needed, create a new folder with the API Category as name.
3. Inside the folder, create a new file PER api endpoint. We are aware that this will create many files, but it makes managing the API structure much easier.
4. Inside your file, always create a proper header so that the Get-Help command lists usefull information
5. ALWAYS include [cmdletbinding()] in your new API Endpoint function
6. If a API Endpoint you are including still has been marked as PREVIEW in the API, the include the line Show-Warning below your parameter section if present, or after [cmdletbinding()] if no parameters are present.
7. Update the PS-NCentral-RESTAPI.psd1 to include your new function in the FunctionsToExport
8. Add your name to the authors list below in this README.md file
9. Create a pull request and include a clear description of which API you added to this module

## Coding conventions

Start reading our code and you'll get the hang of it. We optimize for readability:

* We indent using tabs
* We ALWAYS put spaces after list items and method parameters (`[1, 2, 3]`, not `[1,2,3]`), around operators (`x += 1`, not `x+=1`), and around hash arrows.
* This is open source software. Consider the people who will read your code, and make it look nice for them. It's sort of like driving a car: Perhaps you love doing donuts when you're alone, but with passengers the goal is to make the ride as smooth as possible.
