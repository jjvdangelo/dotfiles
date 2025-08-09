# scripts/windows/common.ps1
# Common helpers for Windows setup scripts

Set-StrictMode -Version Latest

# repository root is assumed to be ~/.dotfiles
$Script:DotfilesRoot = Join-Path $HOME '.dotfiles'
$Script:ConfigRoot = Join-Path $HOME '.config'

function Test-WingetPackage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)][string]$Id
    )
    winget list --id $Id --source winget > $null 2>&1
    return $LASTEXITCODE -eq 0
}

function Install-WingetPackage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)][string]$Id
    )
    if (Test-WingetPackage -Id $Id) {
        Write-Host "$Id is already installed." -ForegroundColor Yellow
    } else {
        Write-Host "Installing $Id via winget" -ForegroundColor Cyan
        winget install --id $Id -e --source winget
    }
}

function New-Symlink {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)][string]$Source,
        [Parameter(Mandatory=$true)][string]$Destination
    )
    if (Test-Path $Destination) {
        Move-Item $Destination "$Destination.bak" -Force
        Write-Host "Moved existing $Destination to $Destination.bak" -ForegroundColor Yellow
    }
    $destDir = Split-Path -Parent $Destination
    if (-not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Path $destDir | Out-Null
    }
    New-Item -ItemType SymbolicLink -Path $Destination -Target $Source | Out-Null
    Write-Host "Linked $Destination -> $Source" -ForegroundColor Green
}

function Link-ConfigFolder {
    [CmdletBinding()]
    param(
        [string]$DestDir = '',
        [Parameter(Mandatory=$true)][string[]]$Names
    )
    foreach ($name in $Names) {
        $src = Join-Path $DotfilesRoot $name
        $destRoot = if ($DestDir) { Join-Path $HOME $DestDir } else { $HOME }
        $dest = Join-Path $destRoot $name
        Write-Host "Creating symlink $dest -> $src" -ForegroundColor Cyan
        New-Symlink -Source $src -Destination $dest
    }
}
