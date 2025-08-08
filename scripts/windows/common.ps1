# scripts/windows/common.ps1
# Common helpers for Windows setup scripts

Set-StrictMode -Version Latest

$Script:ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Script:DotfilesRoot = Split-Path -Parent $Script:ScriptDir
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
    New-Item -ItemType SymbolicLink -Path $Destination -Target $Source | Out-Null
    Write-Host "Linked $Destination -> $Source" -ForegroundColor Green
}

function Link-ConfigFolder {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)][string]$DestDir,
        [Parameter(Mandatory=$true)][string[]]$Names
    )
    foreach ($name in $Names) {
        $src = Join-Path $DotfilesRoot $name
        $dest = Join-Path (Join-Path $HOME $DestDir) $name
        Write-Host "Creating symlink $dest -> $src" -ForegroundColor Cyan
        New-Symlink -Source $src -Destination $dest
    }
}
