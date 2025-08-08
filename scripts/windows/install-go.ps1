# install-go.ps1
# Installs Go using winget

. "$PSScriptRoot/common.ps1"

Install-WingetPackage -Id 'Go.Go'

go version
