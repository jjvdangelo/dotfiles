# symlink-folder-configs.ps1 - create symlinks for config folders

. "$PSScriptRoot/common.ps1"

Link-ConfigFolder '.config' @('nvim')
Link-ConfigFolder '' @('.ssh')
