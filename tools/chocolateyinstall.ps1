$ErrorActionPreference = 'Stop'; 

# Download client zip files from https://support.fortinet.com/Download/FirmwareImages.aspx
#
$clientRelease = "6.0.9"
$clientBuild = "0277"
$pkg32 = 'FortiClientSetup_' + $clientRelease + '.' + $clientBuild + '.zip'
$pkg64 = 'FortiClientSetup_' + $clientRelease + '.' + $clientBuild + '_x64.zip'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$file = Join-Path $toolsDir $pkg32
$checksum = '8c2c98de14d0a80fb42b249e3a51340b431a769812bf60af4b5dc220b57a410e'
$file64 = Join-Path $toolsDir $pkg64
$checksum64 = 'a76bce60e9bc938f16a593474de34ba79c1ce50768419299b7b8c8d1cbf7af4a'

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
  file           = Join-Path $toolsDir 'FortiClient.msi'
  fileType       = 'msi'
  silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`"" 
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @installArgs
Remove-Item -Force $packageArgs.file