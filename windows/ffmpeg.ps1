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
mkdir "${ffmpegBuild}"

# Turn on MSYS2 terminal.
$msys2 = New-Object System.Diagnostics.Process

$msys2.StartInfo.FileName = 'C:\msys64\msys2_shell.cmd' # windows-2022 image runner
$msys2.StartInfo.Arguments = '-use-full-path -no-start -defterm'
$msys2.StartInfo.UseShellExecute = $false
$msys2.StartInfo.RedirectStandardInput = $true

$msys2.Start()
$msys2In = $msys2.StandardInput

# Build and install FFmpeg.
$commandListFiles = 'ls -al'
$commandInstallMake = 'pacman -S --noconfirm make'
$commandChangeDirToBuild = "cd ${ffmpegBuild}" # Strange behavior from GitHub's MSYS2: it's start MSYS2 only in start position.
$commandConfigure = "../${ffmpegSources}/configure --prefix=../${ffmpegInstall}/ --toolchain=msvc --disable-x86asm --enable-shared --disable-static --enable-gpl"
$commandBuild = 'make' # Should use multithreaded, but `nproc` doesn't work in GitHub's MSYS2.
$commandInstall = 'make install'
$commandExit = 'exit'

$msys2In.WriteLine('') # This looks very dirty, but it's only way to prevent encoding error...

$msys2In.WriteLine("${commandListFiles}")

$msys2In.WriteLine("${commandInstallMake}")

$msys2In.WriteLine("${commandChangeDirToBuild}")

$msys2In.WriteLine("${commandListFiles}")

$msys2In.WriteLine("${commandConfigure}")
$msys2In.WriteLine("${commandBuild}")
$msys2In.WriteLine("${commandInstall}")

# Turn off MSYS2 terminal.
$msys2In.WriteLine("${commandExit}")
$msys2.WaitForExit()

# Remove sources, build.
Remove-Item -Recurse -Force "${ffmpegSources}"
Remove-Item -Recurse -Force "${ffmpegBuild}"

# Compress installed.
Compress-Archive -CompressionLevel Optimal -Path "${ffmpegInstall}" -DestinationPath "${ffmpegZip}"

# Remove installation.
Remove-Item -Recurse -Force "${ffmpegInstall}"
