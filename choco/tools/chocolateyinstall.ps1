
$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$rootDir = 'C:\automation' 
if(!(Test-Path $rootDir))
{
  $null = New-Item -ItemType 'Directory' -Path $rootDir
}

if(!(Test-Path "$rootDir\disk-perf-tool"))
{
  $null = New-Item -ItemType 'Directory' -Path "$rootDir\disk-perf-tool"
}

$exclude = 'chocolateyInstall.ps1','chocolateyUninstall.ps1'

ForEach($oldFile in (Get-ChildItem "$rootDir\disk-perf-tool"))
{
  Remove-Item $oldFile.FullName -ErrorAction 'SilentlyContinue'
}

ForEach($newFile in (Get-ChildItem $toolsDir))
{
  if($newFile.Name -notin $exclude)
  {
    Copy-Item $newFile.FullName "$rootDir\disk-perf-tool" -Force
  }
}
