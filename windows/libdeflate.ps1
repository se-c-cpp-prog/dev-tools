#!/usr/bin/env pwsh

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

$libdeflateVersion = '1.21'

$libdeflateUrl = 'https://github.com/ebiggers/libdeflate.git'

$libdeflateSources = 'libdeflate-src'
$libdeflateBuild = 'libdeflate-build'
$libdeflateInstall = 'libdeflate'

$libdeflateZip = "windows-${libdeflateInstall}-${libdeflateVersion}.zip"

# Download libdeflate sources.
git clone "${libdeflateUrl}" -b "v${libdeflateVersion}" "${libdeflateSources}"

# Set working directory to libdeflate build.
mkdir "${libdeflateBuild}"
Push-Location "${libdeflateBuild}"

# Build and install libdeflate.
cmake ../"${libdeflateSources}"/ -D CMAKE_INSTALL_PREFIX=../"${libdeflateInstall}"/ -D BUILD_SHARED_LIBS=ON
cmake --build . --target install --config Release

# Go back.
Pop-Location

# Remove sources, build.
Remove-Item -Recurse -Force "${libdeflateSources}"
Remove-Item -Recurse -Force "${libdeflateBuild}"

# Compress installed.
Compress-Archive -CompressionLevel Optimal -Path "${libdeflateInstall}" -DestinationPath "${libdeflateZip}"

# Remove installation.
Remove-Item -Recurse -Force "${libdeflateInstall}"
