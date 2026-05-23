#!/usr/bin/env sh
set -eu

SOURCE_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ITP_BIN="$SOURCE_DIR/bin/itp"
SKILL_FILE="$SOURCE_DIR/skills/voltagent/SKILL.md"
PREFIX="${ITP_PREFIX:-$HOME/.local}"
TARGET_DIR="$PREFIX/bin"
TARGET="$TARGET_DIR/itp"
SKILL_TARGET_DIR="$PREFIX/share/itpay_cli/skills/voltagent"
SKILL_TARGET="$SKILL_TARGET_DIR/SKILL.md"

if [ ! -f "$ITP_BIN" ]; then
  echo "itp binary not found at $ITP_BIN" >&2
  exit 1
fi

mkdir -p "$TARGET_DIR"
chmod +x "$ITP_BIN"
cp "$ITP_BIN" "$TARGET"
chmod +x "$TARGET"

if [ -f "$SKILL_FILE" ]; then
  mkdir -p "$SKILL_TARGET_DIR"
  cp "$SKILL_FILE" "$SKILL_TARGET"
  chmod 0644 "$SKILL_TARGET"
fi

case ":$PATH:" in
  *":$TARGET_DIR:"*) ;;
  *)
    echo "Installed itp to $TARGET"
    echo "Add $TARGET_DIR to PATH before running itp."
    exit 0
    ;;
esac

"$TARGET" --version
