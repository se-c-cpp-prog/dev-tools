#!/usr/bin/env pwsh

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

$zlibVersion = '1.3.1'

$zlibUrl = 'https://github.com/madler/zlib.git'

$zlibSources = 'zlib-src'
$zlibBuild = 'zlib-build'
$zlibInstall = 'zlib'

$zlibZip = "windows-${zlibInstall}-${zlibVersion}.zip"

# Download ZLIB sources.
git clone "${zlibUrl}" -b "v${zlibVersion}" "${zlibSources}"

# Set working directory to ZLIB sources.
mkdir "${zlibBuild}"
Push-Location "${zlibBuild}"

# Build and install ZLIB.
cmake ../"${zlibSources}"/ -D CMAKE_INSTALL_PREFIX=../"${zlibInstall}"/ -D BUILD_SHARED_LIBS=ON
cmake --build . --target install --config Release

# Go back.
Pop-Location

# Remove sources, build.
Remove-Item -Recurse -Force "${zlibSources}"
Remove-Item -Recurse -Force "${zlibBuild}"

# Compress installed.
Compress-Archive -CompressionLevel Optimal -Path "${zlibInstall}" -DestinationPath "${zlibZip}"

# Remove installation.
Remove-Item -Recurse -Force "${zlibInstall}"
