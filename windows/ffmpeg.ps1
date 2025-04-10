#!/usr/bin/env pwsh

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

$ffmpegVersion = $args[0]

$ffmpegUrl = 'https://git.ffmpeg.org/ffmpeg.git'

$ffmpegSources = 'ffmpeg-src'
$ffmpegBuild = 'ffmpeg-build'
$ffmpegInstall = 'ffmpeg-install'

# Download FFmpeg sources.
git clone "${ffmpegUrl}" -b "release/${ffmpegVersion}" "${ffmpegSources}"

# Create all needed directories.
mkdir "${ffmpegInstall}"
mkdir "${ffmpegBuild}"

# Turn on MSYS2 terminal.
$msys2 = New-Object System.Diagnostics.Process

$msys2.StartInfo.FileName = 'C:\msys64\msys2_shell.cmd'
$msys2.StartInfo.Arguments = '-here -use-full-path -no-start -defterm'
$msys2.StartInfo.UseShellExecute = $false
$msys2.StartInfo.RedirectStandardInput = $true

$msys2.Start()
$msys2In = $msys2.StandardInput

# Build and install FFmpeg.
$commandInstallMake = 'pacman -S --noconfirm make'
$commandChangeDirToBuild = "cd ${ffmpegBuild}" # Strange behavior from GitHub's MSYS2: it's starts MSYS2 only in start position.
$commandConfigure = "../${ffmpegSources}/configure --prefix=../${ffmpegInstall}/ --toolchain=msvc --disable-x86asm --enable-shared --disable-static --enable-gpl"
$commandBuild = 'make -j4'
$commandInstall = 'make install'
$commandExit = 'exit'

$msys2In.WriteLine('') # This looks very dirty, but it's only way to prevent encoding error...

$msys2In.WriteLine("${commandInstallMake}")
$msys2In.WriteLine("${commandChangeDirToBuild}")
$msys2In.WriteLine("${commandConfigure}")
$msys2In.WriteLine("${commandBuild}")
$msys2In.WriteLine("${commandInstall}")

# Turn off MSYS2 terminal.
$msys2In.WriteLine("${commandExit}")
$msys2.WaitForExit()

# Remove sources, build.
Remove-Item -Recurse -Force "${ffmpegSources}"
Remove-Item -Recurse -Force "${ffmpegBuild}"
