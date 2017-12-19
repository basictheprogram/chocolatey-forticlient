$ErrorActionPreference = 'Stop'; 

$clientRelease = "5.6.3"
$clientBuild   = "1130"
$pkg32         = 'FortiClientSetup_' + $clientRelease + '.' + $clientBuild + '.zip'
$pkg64         = 'FortiClientSetup_' + $clientRelease + '.' + $clientBuild + '_x64.zip'
$toolsDir      = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$file          = Join-Path $toolsDir $pkg32
$checksum      = '11d9a6456fc34c8e0a239474ef9ea7b08fd7a1b1a89f766175285a892f3e1e65'
$file64        = Join-Path $toolsDir $pkg64
$checksum64    = '28cb6d4298ce9f37bfb542bcc7a61d9cc3d43676206ac059cf51c146f7a3f0a3'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  file           = $file
  unzipLocation  = $toolsDir
  file64         = $file64
  checksum       = $checksum
  checksumType   = 'sha256' 
  checksum64     = $checksum64
  checksumType64 = 'sha256'
}

# https://chocolatey.org/docs/helpers-install-chocolatey-zip-package
#
Install-ChocolateyZipPackage @packageArgs 

# https://forum.fortinet.com/tm.aspx?m=150054

$installArgs = @{
  packageName    = $env:ChocolateyPackageName
  file           = Join-Path $toolsDir 'FortiClient.msi'
  fileType       = 'msi'
  silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`"" 
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @installArgs
Remove-Item -Force $packageArgs.file