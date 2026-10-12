[CmdletBinding()]
param([string]$Destination)
$ErrorActionPreference = 'Stop'
if (-not $Destination) {
    $petCodexRoot = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $env:USERPROFILE '.codex' }
    $Destination = Join-Path $petCodexRoot 'pets'
}
$petSourceRoot = Join-Path (Split-Path $PSScriptRoot -Parent) 'pets'
$petNames = @('aili', 'yushao')
foreach ($petName in $petNames) {
    $petTarget = Join-Path $Destination $petName
    if (Test-Path -LiteralPath $petTarget) { throw "Pet already exists: $petTarget. Choose a different -Destination or back up the existing folder." }
    $petSource = Join-Path $petSourceRoot $petName
    if (-not (Test-Path -LiteralPath (Join-Path $petSource 'pet.json')) -or -not (Test-Path -LiteralPath (Join-Path $petSource 'spritesheet.png'))) { throw "Incomplete pet package: $petName" }
}
New-Item -ItemType Directory -Path $Destination -Force | Out-Null
foreach ($petName in $petNames) {
    Copy-Item -LiteralPath (Join-Path $petSourceRoot $petName) -Destination $Destination -Recurse
    Write-Host "Installed: $petName"
}
Write-Host "Pets installed to: $Destination"

