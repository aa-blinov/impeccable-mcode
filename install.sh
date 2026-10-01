#!/bin/sh
# Install the Impeccable design skill for MiniMax Code.
#
#   curl -fsSL <repo>/install.sh | sh
#   # or, from a clone:
#   ./install.sh
#
# Copies this directory to the MiniMax Code user-scope skills directory
# (~/.minimax/skills/impeccable by default) and writes the runtime's
# _meta.json. The engine binary is NOT shipped in this repo — the bundled
# scripts/impeccable launcher downloads the correct platform build from the
# pinned upstream release on first run and caches it under ~/.impeccable/bin.

set -eu

SKILL_NAME="impeccable"
SRC_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
DATA_DIR=${IMPECCABLE_SKILL_HOME:-${HOME:-/nonexistent}/.minimax}
DEST_DIR="$DATA_DIR/skills/$SKILL_NAME"

# Resolve version from the bundled launcher metadata, if present.
VERSION="unknown"
[ -f "$SRC_DIR/scripts/VERSION" ] && VERSION=$(tr -d '[:space:]' < "$SRC_DIR/scripts/VERSION")

echo "Impeccable $VERSION → $DEST_DIR"

if [ -e "$DEST_DIR" ] && [ ! "${IMPECCABLE_FORCE:-0}" = "1" ]; then
  echo "Error: $DEST_DIR already exists." >&2
  echo "Re-run with IMPECCABLE_FORCE=1 to replace it, or run ./uninstall.sh first." >&2
  exit 1
fi

mkdir -p "$DEST_DIR"

# Copy everything except VCS metadata and any locally cached engine binary.
# The engine is refetched by the launcher, so it is deliberately excluded.
if command -v rsync >/dev/null 2>&1; then
  rsync -a --delete \
    --exclude '.git' --exclude '.github' --exclude 'install.sh' --exclude 'uninstall.sh' \
    --exclude 'scripts/bin' \
    "$SRC_DIR/" "$DEST_DIR/"
else
  find "$SRC_DIR" -mindepth 1 -maxdepth 1 \
    ! -name '.git' ! -name '.github' ! -name 'install.sh' ! -name 'uninstall.sh' \
    -exec cp -R {} "$DEST_DIR/" \;
fi

# MiniMax Code reads skill metadata from _meta.json.
cat > "$DEST_DIR/_meta.json" <<EOF
{
  "name": "$SKILL_NAME",
  "version": "$VERSION",
  "platform": "minimax",
  "license": "Apache-2.0",
  "source": "https://github.com/aa-blinov/impeccable-mcode",
  "upstream": "https://github.com/pbakaus/impeccable",
  "engine": "scripts/bin/<os>-<arch>/impeccable",
  "updated_at": $(date +%s000)
}
EOF

chmod +x "$DEST_DIR/scripts/impeccable" 2>/dev/null || true

cat <<EOF

Installed.

  1. Start a new MiniMax Code session (skills load at session start).
  2. Ask for design work in plain language, e.g. "audit the study screen"
     or "polish the landing page". There is no /impeccable slash command on
     this harness.
  3. The engine binary downloads itself on first use. To warm it up now:
       cd <your project> && $DEST_DIR/scripts/impeccable --version
EOF
