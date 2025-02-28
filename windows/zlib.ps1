#!/usr/bin/env pwsh

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

$zlibVersion = $args[0]

$zlibUrl = 'https://github.com/madler/zlib.git'

$zlibSources = 'zlib-src'
$zlibBuild = 'zlib-build'
$zlibInstall = 'zlib-install'

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
