# Load helpers
. "$PSScriptRoot/Internal/Helpers.ps1"

# Auto-import all endpoint functions
Get-ChildItem -Path $PSScriptRoot -Recurse -Filter *.ps1 |
    Where-Object { $_.FullName -notmatch "Helpers.ps1" } |
    ForEach-Object { . $_.FullName }

Write-Warning "This module contains several functions that are still in preview by N-Able. These functions are subject to change and may not work. Please take caution when using these functions."