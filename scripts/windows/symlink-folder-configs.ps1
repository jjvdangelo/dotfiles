# symlink-folder-configs.ps1 - create symlinks for config folders

. "$PSScriptRoot/common.ps1"

Link-ConfigFolder '' @('.config')

# link the PowerShell profile
$profileSrc = Join-Path $DotfilesRoot 'Microsoft.PowerShell_profile.ps1'
New-Symlink -Source $profileSrc -Destination $PROFILE
