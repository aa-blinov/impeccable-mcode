#!/bin/sh
# Remove the Impeccable design skill from MiniMax Code.
#
#   ./uninstall.sh
#
# Removes the skill directory only. The shared engine cache
# (~/.impeccable/bin) is left alone — other harness installs of Impeccable
# may depend on it. Pass --purge-cache to remove that too.

set -eu

SKILL_NAME="impeccable"
DATA_DIR=${IMPECCABLE_SKILL_HOME:-${HOME:-/nonexistent}/.minimax}
DEST_DIR="$DATA_DIR/skills/$SKILL_NAME"

if [ ! -d "$DEST_DIR" ]; then
  echo "Nothing to remove: $DEST_DIR does not exist."
  exit 0
fi

rm -rf "$DEST_DIR"
echo "Removed $DEST_DIR"

if [ "${1:-}" = "--purge-cache" ]; then
  CACHE="${IMPECCABLE_HOME:-${HOME:-/nonexistent}/.impeccable}"
  if [ -d "$CACHE" ]; then
    rm -rf "$CACHE"
    echo "Removed engine cache $CACHE"
  fi
else
  echo "Engine cache left in place. Pass --purge-cache to remove it as well."
fi
