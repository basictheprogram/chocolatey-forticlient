$ErrorActionPreference = 'Stop';

$data = & (Join-Path -Path (Split-Path -Path $MyInvocation.MyCommand.Path) -ChildPath data.ps1)
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir

    url            = $data.url
    checksum       = $data.checksum
    checksumType   = $data.checksumType

    url64          = $data.url64
    checksum64     = $data.checksum64
    checksumType64 = $data.checksumType64
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
    softwareName   = "FortiClient"
    validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @installArgs
