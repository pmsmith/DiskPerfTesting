
$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

if((Test-Path "$rootDir\disk-perf-tool"))
{
  $null = Remove-Item "$rootDir\disk-perf-tool" -Recurse -Force -ErrorAction 'SilentlyContinue'
}