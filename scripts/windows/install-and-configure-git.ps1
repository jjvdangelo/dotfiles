# install-and-configure-git.ps1
# Installs Git via winget and configures global settings

. "$PSScriptRoot/common.ps1"

Install-WingetPackage -Id 'Git.Git'

Write-Host "`n *** Configure global Git settings ***"

function Prompt-Validated {
    param(
        [string]$Prompt,
        [string]$Pattern,
        [string]$Default
    )
    while ($true) {
        if ($Default) {
            $input = Read-Host "$Prompt [$Default]"
            if (-not $input) { $input = $Default }
        } else {
            $input = Read-Host $Prompt
        }
        if ($input -match $Pattern) { return $input }
        Write-Host "Invalid input." -ForegroundColor Red
    }
}

$name   = git config --global --get user.name 2>$null
$email  = git config --global --get user.email 2>$null
$branch = git config --global --get init.defaultBranch 2>$null
if (-not $branch) { $branch = 'master' }

$name   = Prompt-Validated " - Full name:" '.+' $name
$email  = Prompt-Validated " - Email address:" '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$' $email
$branch = Prompt-Validated " - Default branch name:" '^[A-Za-z0-9._/-]+$' $branch

git config --global user.name $name
git config --global user.email $email
git config --global init.defaultBranch $branch

Write-Host "`nGit configured successfully!"
