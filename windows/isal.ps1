#!/usr/bin/env pwsh

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

$isalVersion = $args[0]

$isalUrl = 'https://github.com/intel/isa-l.git'

$isalSources = 'isal-src'
$isalInstall = 'isal-install'

# Download isa-l sources.
git clone "${isalUrl}" -b "v${isalVersion}" "${isalSources}"

# Create all necessary directories.
mkdir "${isalInstall}"
mkdir "${isalInstall}/lib/"
mkdir "${isalInstall}/include/"
mkdir "${isalInstall}/include/isa-l/"

# Set working directory to isa-l sources.
Push-Location "${isalSources}"

# Build isa-l.
nmake -f Makefile.nmake

# Copy all files.
Copy-Item -Path isa-l.dll -Destination ..\${isalInstall}\lib\
Copy-Item -Path isa-l.lib -Destination ..\${isalInstall}\lib\
Copy-Item -Path isa-l.h -Destination ..\${isalInstall}\include\
Copy-Item -Path .\include\ -Filter *.h -Destination ..\${isalInstall}\include\isa-l\ -Recurse

# Go back.
Pop-Location

# Remove sources, build.
Remove-Item -Recurse -Force "${isalSources}"
