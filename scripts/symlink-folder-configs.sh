#!/bin/sh
# symlink-folder-configs.sh - create a symlink for config folders
if [ -z "${SCRIPT_DIR+x}" ]; then
    SCRIPT_DIR=$(CDPATH="" cd -- "$(dirname -- "${0}")" && pwd)
fi
# shellcheck disable=SC1091 # SCRIPT_DIR is resolved at runtime.
. "${SCRIPT_DIR}/lib/common.sh"

link_config "" ".config"
