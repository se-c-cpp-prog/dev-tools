#!/usr/bin/env pwsh

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

$googletestVersion = '1.15.2'

$googletestUrl = 'https://github.com/google/googletest.git'

$googletestSources = 'googletest-src'
$googletestBuild = 'googletest-build'
$googletestInstall = 'googletest'

$googletestZip = "windows-${googletestInstall}-${googletestVersion}.zip"

# Download GoogleTest sources.
git clone "${googletestUrl}" -b "v${googletestVersion}" "${googletestSources}"

# Set working directory to GoogleTest build.
mkdir "${googletestBuild}"
Push-Location "${googletestBuild}"

# Build and install GoogleTest.
cmake ../"${googletestSources}"/ -D CMAKE_INSTALL_PREFIX=../"${googletestInstall}"/ -D BUILD_SHARED_LIBS=ON
cmake --build . --target install --config Release

# Go back.
Pop-Location

# Remove sources, build.
Remove-Item -Recurse -Force "${googletestSources}"
Remove-Item -Recurse -Force "${googletestBuild}"

# Compress installed.
Compress-Archive -CompressionLevel Optimal -Path "${googletestInstall}" -DestinationPath "${googletestZip}"
