#!/usr/bin/env pwsh

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

$criterionVersion = '2.4.2'

$criterionUrl = 'https://github.com/Snaipe/Criterion.git'

$criterionSources = 'criterion-src'
$criterionBuild = 'criterion-build'
$criterionInstall = 'criterion'

# Create all necessary directories.
mkdir "${criterionBuild}"
mkdir "${criterionInstall}"

$criterionBuildFullPath = Resolve-Path -Path "${criterionBuild}"
$criterionInstallFullPath = Resolve-Path -Path "${criterionInstall}"

$criterionZip = "windows-${criterionInstall}-${criterionVersion}.zip"

# Download Criterion sources.
git clone "${criterionUrl}" -b "v${criterionVersion}" "${criterionSources}"

$criterionSourcesFullPath = Resolve-Path -Path "${criterionSources}"

# Set working directory to Criterion sources.
Push-Location "${criterionSources}"

# Setup meson.
py -m venv venv
.\venv\Scripts\pip.exe install meson

# Configure meson.
.\venv\Scripts\meson.exe "${criterionSourcesFullPath}" "${criterionBuildFullPath}" --prefix "${criterionInstallFullPath}" --buildtype release --default-library shared

# Go back.
Pop-Location

# Set working directory to Criterion builds.
Push-Location "${criterionBuild}"

# Build and install Criterion.
ninja
ninja install

# Go back.
Pop-Location

# Remove sources, build.
Remove-Item -Recurse -Force "${criterionSources}"
Remove-Item -Recurse -Force "${criterionBuild}"

# Compress installed.
Compress-Archive -CompressionLevel Optimal -Path "${criterionInstall}" -DestinationPath "${criterionZip}"
