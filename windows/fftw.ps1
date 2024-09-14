#!/usr/bin/env pwsh

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

$fftwVersion = '3.3.10'

$fftwUrl = 'https://www.fftw.org'

$fftwSources = "fftw-${fftwVersion}"
$fftwDownloadedArchive = "${fftwSources}.tar.gz"
$fftwBuild = 'fftw-build'
$fftwInstall = 'fftw'

$fftwZip = "windows-${fftwInstall}-${fftwVersion}.zip"

# Download and extract FFTW sources.
Invoke-WebRequest -Uri "${fftwUrl}/${fftwDownloadedArchive}" -OutFile "${fftwDownloadedArchive}"
tar xzvf "${fftwDownloadedArchive}"
Remove-Item "${fftwDownloadedArchive}"

# Set working directory to FFTW build.
mkdir "${fftwBuild}"
Push-Location "${fftwBuild}"

# Build and install FFTW (Single precision).
cmake ../"${fftwSources}"/ -D CMAKE_INSTALL_PREFIX=../"${fftwInstall}"/ -D ENABLE_FLOAT=ON -D BUILD_SHARED_LIBS=ON
cmake --build . --target install --config Release

# Go back
Pop-Location

# Remove build.
Remove-Item -Recurse -Force "${fftwBuild}"

# Set working directory to FFTW build.
mkdir "${fftwBuild}"
Push-Location "${fftwBuild}"

# Build and install FFTW (Double precision).
cmake ../"${fftwSources}"/ -D CMAKE_INSTALL_PREFIX=../"${fftwInstall}"/ -D ENABLE_DOUBLE=ON -D BUILD_SHARED_LIBS=ON
cmake --build . --target install --config Release

# Go back.
Pop-Location

# Remove sources, build.
Remove-Item -Recurse -Force "${fftwSources}"
Remove-Item -Recurse -Force "${fftwBuild}"

# Compress installed.
Compress-Archive -CompressionLevel Optimal -Path "${fftwInstall}" -DestinationPath "${fftwZip}"
