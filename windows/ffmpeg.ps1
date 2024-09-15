#!/usr/bin/env pwsh

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

$ffmpegVersion = '6.1'

$ffmpegUrl = 'https://git.ffmpeg.org/ffmpeg.git'

$ffmpegSources = 'ffmpeg-src'
$ffmpegBuild = 'ffmpeg-build'
$ffmpegInstall = 'ffmpeg'

$ffmpegZip = "windows-${ffmpegInstall}-${ffmpegVersion}.zip"

# Download FFmpeg sources.
git clone "${ffmpegUrl}" -b "release/${ffmpegVersion}" "${ffmpegSources}"

# Create all needed directories.
mkdir "${ffmpegInstall}"

# Set working directory to FFmpeg build.
mkdir "${ffmpegBuild}"
Set-Location "${ffmpegBuild}" # Should be Push-Location, but MSYS2 at start grabs actual working directory.

# Turn on MSYS2 terminal.
$msys2 = New-Object System.Diagnostics.Process

$msys2.StartInfo.FileName = 'C:\msys64\msys2_shell.cmd' # windows-2022 image runner
$msys2.StartInfo.Arguments = '-here -no-start -defterm'
$msys2.StartInfo.UseShellExecute = $false
$msys2.StartInfo.RedirectStandardInput = $true

$msys2.Start()
$msys2In = $msys2.StandardInput

# Build and install FFmpeg.
$commandInstallMake = 'pacman -S --noconfirm make'
$commandConfigure = "../${ffmpegSources}/configure --prefix=../${ffmpegInstall}/ --toolchain=msvc --disable-x86asm --enable-shared --disable-static --enable-gpl"
$commandBuild = 'make -j"(nproc --all)"'
$commandInstall = 'make install'
$commandExit = 'exit'

$msys2In.WriteLine('') # This looks very dirty, but it's only way to prevent encoding error...

$msys2In.WriteLine("${commandInstallMake}")
$msys2In.WriteLine("${commandConfigure}")
$msys2In.WriteLine("${commandBuild}")
$msys2In.WriteLine("${commandInstall}")

# Turn off MSYS2 terminal.
$msys2In.WriteLine("${commandExit}")
$msys2.WaitForExit()

# Go back.
Set-Location .. # See above.

# Remove sources, build.
Remove-Item -Recurse -Force "${ffmpegSources}"
Remove-Item -Recurse -Force "${ffmpegBuild}"

# Compress installed.
Compress-Archive -CompressionLevel Optimal -Path "${ffmpegInstall}" -DestinationPath "${ffmpegZip}"

# Remove installation.
Remove-Item -Recurse -Force "${ffmpegInstall}"
