# Dotfiles

This repository contains personal configuration files and setup scripts for Linux, macOS and Windows environments.

## Overview

The repo is meant to be cloned into `~/.dotfiles` and provides scripts that install dependencies and create symlinks to the files in this repo.

## Getting Started

Before running any scripts, ensure Git is installed. The setup commands below configure your Git user settings, install ZSH when necessary, and create symlinks to the configuration files in this repository.

### Windows

1. Open an elevated **PowerShell** prompt (Run as Administrator).
2. Clone the repository:
   ```powershell
   git clone https://github.com/OWNER/dotfiles.git $HOME\.dotfiles
   cd $HOME\.dotfiles
   ```
3. Run the bootstrap script (requires [winget](https://learn.microsoft.com/en-us/windows/package-manager/winget/)):
   ```powershell
   pwsh -ExecutionPolicy Bypass -File scripts\windows\bootstrap.ps1
   ```

### WSL (Ubuntu/Debian)

1. Clone the repository:
   ```bash
   git clone https://github.com/OWNER/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```
2. Run the setup scripts:
   ```bash
   scripts/install-and-configure-git.sh
   scripts/install_and_configure_zsh.sh
   scripts/link_zsh_dotfiles.sh
   scripts/symlink-folder-configs.sh
   ```

### macOS

1. Ensure [Homebrew](https://brew.sh) is installed.
2. Clone and enter the repository as above.
3. Run the same setup scripts used for WSL:
   ```bash
   scripts/install-and-configure-git.sh
   scripts/install_and_configure_zsh.sh
   scripts/link_zsh_dotfiles.sh
   scripts/symlink-folder-configs.sh
   ```

### Linux (apt based)

For other apt-based distributions, follow the same steps as for WSL.

## Structure

- `scripts/` contains cross-platform setup helpers.
- `nvim/` and `.config/` hold editor and application configurations.
- `.zshrc`, `.zshenv`, `.bashrc` etc. are typical shell dotfiles linked to the home directory.

## Development

Run `shellcheck scripts/*.sh scripts/lib/*.sh` and address any warnings before committing changes.

## Notes

Running the setup scripts may move any existing files to `*.bak` before creating symlinks.

