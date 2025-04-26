#!/bin/sh

set -eu

base_url="https://go.dev"
local="/usr/local"
go_root="${local}/go"

printf "Installing Go from %s.\n" "${base_url}"

latest=$(curl -s https://go.dev/VERSION?m=text | head -n 1)
printf "  Latest published version of Go:\n   - %s\n" "${latest}"

if command -v go >/dev/null 2>&1; then
    current=$(go version | awk '{ print $3 }')
    printf "  Currently install version of Go:\n   - %s\n" "${current}"

    if [ "${current}" = "${latest}" ]; then
        printf "Go is already up to date. Exiting.\n"
        exit 0
    fi

    printf "  Updating Go from %s to %s.\n" "${current}" "${latest}"
else
    printf "  Go is not installed. Installing %s.\n" "${latest}"
fi

tar_file="${latest}.linux-amd64.tar.gz"
go_tar_url="https://go.dev/dl/${tar_file}"
printf "  Downloading %s from %s.\n" "${latest}" "${go_tar_url}"

curl -fsSLO "${go_tar_url}"
if [ -d "${go_root}" ]; then
    printf "  Removing the current Go installation.\n"
    sudo rm -rf "${go_root}"
fi

printf "  Extracting tar.\n"
sudo tar -C "${local}" -xzf "${tar_file}"
sudo rm "${tar_file}"

go version
