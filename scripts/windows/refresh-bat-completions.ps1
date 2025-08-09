# refresh-bat-completions.ps1
# Regenerate cached PowerShell completions for bat

$cacheDir = Join-Path $HOME ".cache"
$completionFile = Join-Path $cacheDir "bat-completions.ps1"

if (-not (Get-Command bat -ErrorAction SilentlyContinue)) {
    Write-Error "bat is not installed."
    exit 1
}

if (-not (Test-Path $cacheDir)) {
    New-Item -Path $cacheDir -ItemType Directory | Out-Null
}

bat --completion ps1 | Out-File -FilePath $completionFile -Encoding UTF8
Write-Host "bat completions cached to $completionFile"
