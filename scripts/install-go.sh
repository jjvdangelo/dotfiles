#!/bin/sh

set -eu

base_url="https://go.dev"
local="/usr/local"
go_root="${local}/go"

printf "Installing Go from %s.\n" "${base_url}"

latest=$(curl -s https://go.dev/VERSION?m=text | head -n 1)
printf "  Latest published version of Go:\n   - %s\n" "${latest}"

current=""
if command -v go >/dev/null 2>&1; then
    current=$(go version | awk '{ print $3 }')
    printf "  Currently installed version of Go:\n   - %s\n" "${current}"
else
    printf "  Go is not installed.\n"
fi

if [ -n "${current}" ]; then
    if [ "${current}" = "${latest}" ]; then
        printf "Go is already up to date. Exiting.\n"
        exit 0
    fi

    newest=$(printf '%s\n%s\n' "${current#go}" "${latest#go}" | sort -V | tail -n1)
    if [ "${newest}" != "${latest#go}" ]; then
        printf "Installed Go (%s) is newer than latest available (%s). Exiting.\n" "${current}" "${latest}"
        exit 0
    fi

    printf "  Updating Go from %s to %s.\n" "${current}" "${latest}"
else
    printf "  Installing Go %s.\n" "${latest}"
fi

detected_os=$(uname -s)
detected_arch=$(uname -m)
printf "  Detected platform:\n   - %s/%s\n" "${detected_os}" "${detected_arch}"

case $(printf "%s" "${detected_os}" | tr '[:upper:]' '[:lower:]') in
    linux) go_os="linux" ;;
    darwin) go_os="darwin" ;;
    mingw*|msys*|cygwin*|windows_nt) go_os="windows" ;;
    *)
        printf "Unsupported operating system: %s\n" "${detected_os}" >&2
        exit 1
        ;;
esac

case "${detected_arch}" in
    x86_64|amd64) go_arch="amd64" ;;
    aarch64|arm64) go_arch="arm64" ;;
    i386|i686) go_arch="386" ;;
    *)
        printf "Unsupported architecture: %s\n" "${detected_arch}" >&2
        exit 1
        ;;
esac

case "${go_os}" in
    windows)
        if command -v msiexec >/dev/null 2>&1; then
            archive_ext="msi"
        else
            archive_ext="zip"
        fi
        ;;
    *)
        archive_ext="tar.gz"
        ;;
esac

file="${latest}.${go_os}-${go_arch}.${archive_ext}"
download_url="${base_url}/dl/${file}"
printf "  Downloading %s from %s.\n" "${latest}" "${download_url}"

curl -fsSLO "${download_url}"
if [ -d "${go_root}" ]; then
    printf "  Removing the current Go installation.\n"
    sudo rm -rf "${go_root}"
fi

case "${archive_ext}" in
    tar.gz)
        printf "  Extracting tar.\n"
        sudo tar -C "${local}" -xzf "${file}"
        ;;
    zip)
        printf "  Extracting zip.\n"
        sudo unzip -q "${file}" -d "${local}"
        ;;
    msi)
        printf "  Running MSI installer.\n"
        sudo msiexec /i "${file}" /qn || {
            printf "msiexec failed\n" >&2
            exit 1
        }
        ;;
esac

sudo rm "${file}" 2>/dev/null || true

go version
