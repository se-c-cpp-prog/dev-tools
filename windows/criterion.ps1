#!/usr/bin/env pwsh

$criterionVersion = '2.4.2'

$criterionUrl = 'https://github.com/Snaipe/Criterion.git'

$criterionSources = 'criterion-src'
$criterionBuild = 'criterion-build'
$criterionInstall = 'criterion'

$criterionZip = "windows-${criterionInstall}-${criterionVersion}.zip"

# Download Criterion sources.
git clone "${criterionUrl}" -b "v${criterionVersion}" "${criterionSources}"

# Create all necessary directories.
mkdir "${criterionBuild}"
mkdir "${criterionInstall}"

# Set working directory to Criterion sources.
Push-Location "${criterionSources}"

# Setup meson.
py -m venv venv
./venv/bin/ install meson

# Go back.
Pop-Location

# Configure meson.
./"${criterionSources}"/venv/bin/meson ./"${criterionSources}" "${criterionBuild}" --prefix "${criterionInstall}" --buildtype release --default-library shared -Dc_std=gnu11

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
