# bootstrap.ps1 - Windows setup entry point

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
  Write-Host "winget is not installed. Please install winget and run this script again." -ForegroundColor Red
  exit 1
}

winget install --id Microsoft.PowerShell -e --source winget

$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
& "$dir/install-and-configure-git.ps1"
& "$dir/install-go.ps1"
& "$dir/symlink-folder-configs.ps1"
