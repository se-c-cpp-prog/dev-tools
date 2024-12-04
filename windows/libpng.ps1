#!/usr/bin/env pwsh

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

$libpngVersion = '1.6.43'

$libpngUrl = 'https://download.sourceforge.net/libpng'

$libpngSources = "libpng-${libpngVersion}"
$libpngDownloadedArchive = "${libpngSources}.tar.gz"
$libpngInstall = 'libpng-install'

# Create all necessary directories.
mkdir "${libpngInstall}"
$libpngInstallFullPath = Resolve-Path -Path "${libpngInstall}"
mkdir "${libpngInstallFullPath}/include/"
mkdir "${libpngInstallFullPath}/include/libpng16/"
mkdir "${libpngInstallFullPath}/lib/"

# Download and extract libpng sources.
Invoke-WebRequest -UserAgent 'Wget' -Uri "${libpngUrl}/${libpngDownloadedArchive}" -OutFile "${libpngDownloadedArchive}"
tar xf "${libpngDownloadedArchive}"
Remove-Item "${libpngDownloadedArchive}"

# Download latest ZLIB version.
$zlibVersion = '1.3.1'
$zlibUrl = 'https://github.com/madler/zlib.git'
$zlibSources = 'zlib'

git clone "${zlibUrl}" -b "v${zlibVersion}" "${zlibSources}"

# Set working directory to Visual Studio project.
Push-Location "${libpngSources}"
Push-Location projects
Push-Location vstudio

# Set TreatWarningAsError = false.
$file = 'zlib.props'
$find = '   <TreatWarningAsError>true</TreatWarningAsError>'
$replace = '   <TreatWarningAsError>false</TreatWarningAsError>'

(Get-Content "${file}").Replace("${find}", "${replace}") | Set-Content "${file}"

# Build Visual Studio project.
$configuration = 'Release'
$platform = 'x64'
# $platformToolset = 'v143' # MSVC 2022

msbuild vstudio.sln /p:Configuration=$configuration /p:Platform=$platform # /p:PlatformToolset=$platformToolset

# Set working directory to Release's.
Push-Location "${configuration}"

# Copy library files to installation.
Copy-Item -Path libpng16.dll -Destination "${libpngInstallFullPath}\lib\libpng16.dll"
Copy-Item -Path libpng16.lib -Destination "${libpngInstallFullPath}\lib\libpng16.lib"
Copy-Item -Path zlib.lib -Destination "${libpngInstallFullPath}\lib\zlib.lib"

# Go back.
Pop-Location
Pop-Location
Pop-Location

# Copy headers to installation.
Copy-Item -Path png.h -Destination "${libpngInstallFullPath}\include\png.h"
Copy-Item -Path pngconf.h -Destination "${libpngInstallFullPath}\include\pngconf.h"
Copy-Item -Path pngdebug.h -Destination "${libpngInstallFullPath}\include\pngdebug.h"
Copy-Item -Path pnginfo.h -Destination "${libpngInstallFullPath}\include\pnginfo.h"
Copy-Item -Path pnglibconf.h -Destination "${libpngInstallFullPath}\include\pnglibconf.h"
Copy-Item -Path pngpriv.h -Destination "${libpngInstallFullPath}\include\pngpriv.h"
Copy-Item -Path pngstruct.h -Destination "${libpngInstallFullPath}\include\pngstruct.h"

Copy-Item -Path png.h -Destination "${libpngInstallFullPath}\include\libpng16\png.h"
Copy-Item -Path pngconf.h -Destination "${libpngInstallFullPath}\include\libpng16\pngconf.h"
Copy-Item -Path pngdebug.h -Destination "${libpngInstallFullPath}\include\libpng16\pngdebug.h"
Copy-Item -Path pnginfo.h -Destination "${libpngInstallFullPath}\include\libpng16\pnginfo.h"
Copy-Item -Path pnglibconf.h -Destination "${libpngInstallFullPath}\include\libpng16\pnglibconf.h"
Copy-Item -Path pngpriv.h -Destination "${libpngInstallFullPath}\include\libpng16\pngpriv.h"
Copy-Item -Path pngstruct.h -Destination "${libpngInstallFullPath}\include\libpng16\pngstruct.h"

# Go back.
Pop-Location

# Remove sources, build.
Remove-Item -Recurse -Force "${libpngSources}"
Remove-Item -Recurse -Force "${zlibSources}"
