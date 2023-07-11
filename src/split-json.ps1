param (
    [Parameter(Mandatory = $false, HelpMessage = "Display help message")]
    [switch]$h,

    [Parameter(Mandatory = $false, Position = 0, HelpMessage = "Specify the input file")]
    [string]$in,

    [Parameter(Mandatory = $false, Position = 1, HelpMessage = "Specify the number of lines per file")]
    [int]$li
)

if ($h -or (!$in -or !$li)) {
    Write-Host "Split-Json.ps1"
    Write-Host "Description: This script splits a JSON file into smaller chunks based on the number of lines per file."
    Write-Host "Usage: .\split-json.ps1 [-h] -in <inputFile> -li <linesPerFile>"
    Write-Host "Arguments:"
    Write-Host "  -in         : Specifies the input file path"
    Write-Host "  -li         : Specifies the number of lines per file"
    exit
}

# Get the directory path of the input file
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path

# Concatenate the input file with the script directory
$inputFile = Join-Path -Path $scriptDirectory -ChildPath $in

if (!(Test-Path -Path $inputFile)) {
    Write-Host "Input file not found: $inputFile"
    exit
}

# Read the input file content as an array of lines
$fileContent = Get-Content -Path $inputFile -Encoding UTF8

# Define the output directory path relative to the script directory
$outputDirectory = Join-Path -Path $scriptDirectory -ChildPath "split"

# Create the output directory if it doesn't exist
if (!(Test-Path -Path $outputDirectory)) {
    New-Item -ItemType Directory -Path $outputDirectory | Out-Null
}

# Split the file content into smaller chunks and save each chunk to a separate file
$fileCount = 1
$chunk = @()
foreach ($line in $fileContent) {
    $chunk += $line

    if ($chunk.Count -eq $li) {
        $paddedCount = $fileCount.ToString("0000")
        $outputFile = Join-Path -Path $outputDirectory -ChildPath "split_$paddedCount.json"

        # Remove the BOM from the output file
        $utf8NoBom = New-Object System.Text.UTF8Encoding($false)

        $streamWriter = [System.IO.StreamWriter]::new($outputFile, $false, $utf8NoBom)
        foreach ($lineToWrite in $chunk) {
            $streamWriter.WriteLine($lineToWrite)
        }
        $streamWriter.Close()
        Write-Host "Created file: $outputFile"

        $fileCount++
        $chunk = @()
    }
}

# Save the remaining lines as the last chunk if it's not empty
if ($chunk.Count -gt 0) {
    $paddedCount = $fileCount.ToString("0000")
    $outputFile = Join-Path -Path $outputDirectory -ChildPath "split_$paddedCount.json"

    # Remove the BOM from the output file
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)

    $streamWriter = [System.IO.StreamWriter]::new($outputFile, $false, $utf8NoBom)
    foreach ($lineToWrite in $chunk) {
        $streamWriter.WriteLine($lineToWrite)
    }
    $streamWriter.Close()
    Write-Host "Created file: $outputFile"
}

Write-Host "Splitting file complete."
