$ErrorActionPreference = 'Stop';

# Download client zip files from https://support.fortinet.com/Download/FirmwareImages.aspx
#
$clientRelease = "6.4.1"
$clientBuild = "1519"
$pkg32 = 'FortiClientSSOSetup_' + $clientRelease + '.' + $clientBuild + '.zip'
$pkg64 = 'FortiClientSSOSetup_' + $clientRelease + '.' + $clientBuild + '_x64.zip'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$file = Join-Path $toolsDir $pkg32
$checksum = '05565b06a799d76a383bcfb4f20befd062392a95f21c3d1189f7b20b40e94960'
$file64 = Join-Path $toolsDir $pkg64
$checksum64 = 'bd9f238f34b1db9ffc7ca89747d2ed9d24eea2b982048915493da19cf9bbe2c2'

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
#
# Installing FortiClient using the CLI
# http://bit.ly/2Myohec
#
$installArgs = @{
  packageName    = $env:ChocolateyPackageName
  file           = Join-Path $toolsDir 'FortiClientSSO.msi'
  fileType       = 'msi'
  silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes = @(0, 3010, 1641)
  softwareName   = 'FortiClient*'
}

Install-ChocolateyInstallPackage @installArgs
Remove-Item -Force $packageArgs.file