$ErrorActionPreference = 'Stop'; 

# Download client zip files from https://support.fortinet.com/Download/FirmwareImages.aspx
#
$clientRelease = "6.0.5"
$clientBuild   = "0209"
$pkg32         = 'FortiClientSetup_' + $clientRelease + '.' + $clientBuild + '.zip'
$pkg64         = 'FortiClientSetup_' + $clientRelease + '.' + $clientBuild + '_x64.zip'
$toolsDir      = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$file          = Join-Path $toolsDir $pkg32
$checksum      = 'a0ebdf38275693f592ca257079c076b1e07d49c702ffcd62f33536856ab189f7'
$file64        = Join-Path $toolsDir $pkg64
$checksum64    = '2e9259431724cfad01641f6548c2a178b4cb577f4e7130118df93e4b31b6a96b'

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