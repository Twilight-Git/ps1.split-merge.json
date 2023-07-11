param (
    [Parameter(Mandatory = $false, HelpMessage = "Display help message")]
    [switch]$h
)

if ($h) {
    Write-Host "Merge-Json.ps1"
    Write-Host "Description: This script merges multiple JSON files into a single file."
    Write-Host "The script expects a directory named split containing JSON files, and it will merge the contents of all the files into a single output file."
    Write-Host "Usage: .\merge-json.ps1 [-h]"
    Write-Host "Arguments:"
    Write-Host "  -h          : Display this help message"
    exit
}

# Get the directory path of the currently executing script
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path

# Define the input directory path relative to the script directory
$inputDirectory = Join-Path -Path $scriptDirectory -ChildPath "split"

# Define the output directory path relative to the script directory
$outputDirectory = Join-Path -Path $scriptDirectory -ChildPath "merge"

# Check if the input directory exists
if (!(Test-Path -Path $inputDirectory)) {
    Write-Host "Input directory '$inputDirectory' does not exist."
    Write-Host "This script merges files only when the input directory exists and contains files."
    Write-Host "Please run Split-Json.ps1 first."
    exit
}

# Get all files in the input directory
$inputFiles = Get-ChildItem -Path $inputDirectory

# Check if the input directory is empty or contains no files
if ($inputFiles.Count -eq 0) {
    Write-Host "Input directory '$inputDirectory' is empty or contains no files."
    Write-Host "This script merges files only when the input directory exists and contains files."
    Write-Host "Please run Split-Json.ps1 first."
    exit
}

# Sort the files based on the numeric portion of the file names
$inputFiles = $inputFiles | Sort-Object { [int]($_.BaseName -replace '[^\d]+') }

# Create the output directory if it doesn't exist
if (!(Test-Path -Path $outputDirectory)) {
    New-Item -ItemType Directory -Path $outputDirectory | Out-Null
}

# Define the output file path
$outputFile = Join-Path -Path $outputDirectory -ChildPath "merged.json"

# Create the output file
$null = New-Item -ItemType File -Path $outputFile

# Merge the contents of each file into the output file
foreach ($file in $inputFiles) {
    $content = Get-Content -Path $file.FullName
    Add-Content -Path $outputFile -Value $content
}

Write-Host "Merging files complete. Output file: $outputFile"
