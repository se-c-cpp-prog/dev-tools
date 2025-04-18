#!/usr/bin/env pwsh

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

$googletestVersion = $args[0]

$googletestUrl = 'https://github.com/google/googletest.git'

$googletestSources = 'googletest-src'
$googletestBuild = 'googletest-build'
$googletestInstall = 'googletest-install'

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
