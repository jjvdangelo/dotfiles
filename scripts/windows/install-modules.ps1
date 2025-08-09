$modules = @('PSReadLine', 'posh-git', 'PSFzf', 'VCVars')
foreach ($m in $modules) {
    if (-not (Get-Module -ListAvailable -Name $m)) {
        Write-Host "Installing module '$m'..."
        Install-Module -Name $m -Scope CurrentUser -Force -AllowClobber
    }
}
