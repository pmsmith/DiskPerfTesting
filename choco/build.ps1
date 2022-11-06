
#- starting variables
$current = (Get-Location).Path
$exclude = 'build.ps1',
    'chocolateyinstall.ps1',
    'chocolateyuninstall.ps1'

#- validate required files
$required = '/tools','disk-perf-tool.nuspec'
ForEach($req in $required)
{
    if(!(Test-Path "$current\$req"))
    {
        throw "'$current\$req not found!"
    }
}

#- random job id
$jobid = "$(([Guid]::NewGuid().Guid).ToString().Split('-')[0])"

#- create and move to working directory 
$workingDir = Join-Path $current $jobid
if(!(Test-Path $workingDir))
{
    $null = New-Item -ItemType 'Directory' -Path $workingDir
}
Set-Location $workingDir

if(!(Test-Path "$workingDir\tools"))
{
    $null = New-Item -ItemType 'Directory' -Path "$workingDir\tools"
}

Copy-Item "$current\tools\chocolateyinstall.ps1" "$workingDir\tools"
Copy-Item "$current\tools\chocolateyuninstall.ps1" "$workingDir\tools"
Copy-Item "$current\*.nuspec" $workingDir

$gitrepo = Split-Path $current -Parent 
$requiredDeployFiles = 'results','diskspd.exe','DiskSpeed.ps1'

ForEach($req in $requiredDeployFiles)
{
    if(!(Test-Path "$gitrepo\$req"))
    {
        throw "Missing '$gitrepo\$req"
    }
    Copy-Item "$gitrepo\$req" "$workingDir\tools" -Recurse -Force
}

choco pack -r

$nupkg = Get-ChildItem $workingDir | Where-Object { $_.Extension -eq '.nupkg' }
if((Test-Path $nupkg.FullName))
{
    choco push $nupkg --source $env:artifactory_url --api-key "$env:choco_user`:$env:choco_pass"
}

Set-Location $current 
if((Test-Path "$workingDir"))
{
    Remove-Item $workingDir -Recurse -Force
}
