# check for interactive use
$cmdArgs = [Environment]::GetCommandLineArgs()
$isInteractive = -not ($cmdArgs -contains '-Command' -or $cmdArgs -contains '-File')

# command availability lookup
$cmd = @{}
foreach ($c in 'eza','zoxide','bat','dotnet','starship') {
    $cmd[$c] = [bool](Get-Command $c -ErrorAction SilentlyContinue)
}

Function Test-Elevated {
    $wid = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $prp = New-Object System.Security.Principal.WindowsPrincipal($wid)
    $adm = [System.Security.Principal.WindowsBuiltInRole]::Administrator
    $prp.IsInRole($adm)
}

Function new-link ($target, $link) {
    Write-Host "Creating new symlink:"
    Write-Host "  From: $target"
    Write-Host "  To:   $link"

    New-Item -Path $link -ItemType SymbolicLink -Value $target
}

Function new-tool-link ($link) {
    new-link("C:\tools\bin", $link)
}

Function new-link-folder ($folder) {
    Get-ChildItem -Path $folder |
    Where-Object Name -CLike "*.exe" |
    ForEach-Object -Process {
        $fname = $_.BaseName + $_.Extension
        $target = "C:\tools\bin\$fname"
        Write-Host "Creating symlink:   $target"
        new-link $_ $target
    }
}

# PsFzf config
Set-PsFzfOption -TabExpansion
Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+r'
$env:FZF_DEFAULT_OPTS = '--preview "eza -al --icons --color {}"'
$env:FZF_ALT_C_OPTS   = '--preview "eza -al --icons --color {}"'

# vstools
$vsToolsLoc = "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\Launch-VsDevShell.ps1"
if (Test-Path -path $vsToolsLoc) {
    function Enable-VSTools {
        & $vsToolsLoc
    }
} else {
    function Enable-VSTools {
        Write-Host "Launch-VsDevShell.ps1 not found."
    }
}

# dotnet
if ($cmd['dotnet']) {
    $env:DOTNET_CLI_TELEMETRY_OPTOUT = $true
}

# starship config
function Enable-Starship {
    if ($cmd['starship']) {
        function global:Invoke-Starship-PreCommand {
            $host.ui.RawUI.WindowTitle = "` $pwd `a"
        }

        Invoke-Expression (&starship init powershell)
    }
}

if (-not $isInteractive) {
    if ($env:USE_STARSHIP) {
        Enable-Starship
    }

    return
}

# module imports (installation handled by scripts/windows/install-modules.ps1)
$modules = @('PSReadLine', 'posh-git', 'PSFzf', 'VCVars')
foreach ($m in $modules) {
    if (Get-Module -ListAvailable -Name $m) {
        Import-Module $m -ErrorAction Stop
    }
}

# PSReadLine config
function OnViModeChange {
    if ($args[0] -eq 'Command') {
        Write-Host -NoNewline "`e[2 q"
    } else {
        Write-Host -NoNewline "`e[5 q"
    }
}

function HistoryHandler {
    param($line)
    $line.Length -gt 3 -and
    -not $line.StartsWith(' ') -and
    -not @('exit','dir','ls','pwd','cd ..').Contains($line.ToLowerInvariant())
}

$PSReadLineOptions = @{
    EditMode = "Vi"
    HistorySaveStyle = "SaveIncrementally"
    MaximumHistoryCount = 1000
    PredictionSource = "History"
    # PredictionViewStyle = "ListView"
    ViModeIndicator = "Script"
    ViModeChangeHandler = $Function:OnViModeChange
    AddToHistoryHandler = $Function:HistoryHandler
    HistoryNoDuplicates = $true
}
Set-PSReadLineOption @PSReadLineOptions

Set-PSReadLineKeyHandler -Key Ctrl+p -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key Ctrl+n -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Ctrl+y -Function AcceptLine
Set-PSReadLineKeyHandler -Key Ctrl+w -Function BackwardDeleteWord

# bat config
if ($cmd['bat']) {
    function BatFzf {
        & fzf @args --preview "bat --line-range :500 {}"
    }
    $batCompletion = Join-Path $HOME ".cache/bat-completions.ps1"
    if (Test-Path $batCompletion) {
        . $batCompletion
    }
    $refreshBatCompletionsScript = Join-Path $PSScriptRoot "scripts/windows/refresh-bat-completions.ps1"
    function Refresh-BatCompletions {
        & $refreshBatCompletionsScript
    }
}

# eza config
if ($cmd['eza']) {
    function l  { & eza      --icons @args }
    function ls { & eza -al  --icons --color @args }
    function ll { & eza -lg  --icons --color @args }
    function la { & eza -lag --icons --color @args }

    function lt  { & eza -lTg --icons --color @args }
    function lt1 { & eza -lTg --icons --color --level=1 @args }
    function lt2 { & eza -lTg --icons --color --level=2 @args }
    function lt3 { & eza -lTg --icons --color --level=3 @args }

    function lta  { & eza -lTag --icons --color @args }
    function lta1 { & eza -lTag --icons --color --level=1 @args }
    function lta2 { & eza -lTag --icons --color --level=2 @args }
    function lta3 { & eza -lTag --icons --color --level=3 @args }
}

# zoxide config
if ($cmd['zoxide']) {
    Invoke-Expression (& zoxide init powershell)
}

Enable-Starship
