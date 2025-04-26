#!/bin/sh
# install-and-configure-git.sh
# Installs Git and configures user settings.
if [ -z "${SCRIPT_DIR+x}" ]; then
    SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "${0}")" && pwd)
fi
. "${SCRIPT_DIR}/lib/common.sh"

install_packages git
printf '\n *** Configure global Git settings ***\n'

git_config_global="git config --global"
name=$($git_config_global --get user.name 2>/dev/null || true)
email=$($git_config_global --get user.email 2>/dev/null || true)
branch=$($git_config_global --get init.defaultBranch 2>/dev/null || true)
[ -z "${branch}" ] && branch="master"

name_regex='.+'
email_regex='^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$' 
branch_regex='^[A-Za-z0-9._/-]+$' 

prompt_and_validate name   " - Full name:"           "${name_regex}"   ${name}
prompt_and_validate email  " - Email address:"       "${email_regex}"  ${email}
prompt_and_validate branch " - Default branch name:" "${branch_regex}" ${branch}

git config --global user.name          "${name}" 
git config --global user.email         "${email}"
git config --global init.defaultBranch "${branch}"

printf '\nGit configured successfully!\n'
