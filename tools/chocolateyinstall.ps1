$ErrorActionPreference = 'Stop'; 

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'C:\dropbox\Fortigate\FortiClientSetup_5.6.2.1117.zip'
$checksum   = '86f2c9531b1a5471a2d6542e7c9097139d2951cf88c36535883ee89953fd68e1'
$url64      = 'C:\dropbox\Fortigate\FortiClientSetup_5.6.2.1117_x64.zip'
$checksum64 = '1833ae0bf8ce3267a2a5c3d976fd6a04cd467a9bcd95f08352c2f616d7c04125'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  file           = $url
  unzipLocation  = $toolsDir
  url64bit       = $url64
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

