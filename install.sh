#!/usr/bin/env sh
set -eu

SOURCE_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ITP_BIN="$SOURCE_DIR/bin/itp"
SKILLS_DIR="$SOURCE_DIR/skills"
DOCS_DIR="$SOURCE_DIR/docs"
NODE_MODULES="$SOURCE_DIR/node_modules"
PREFIX="${ITP_PREFIX:-$HOME/.local}"
TARGET_DIR="$PREFIX/bin"
TARGET="$TARGET_DIR/itp"
SHARE_TARGET_DIR="$PREFIX/share/itpay_cli"
MODULE_TARGET="$TARGET_DIR/node_modules"

if [ ! -f "$ITP_BIN" ]; then
  echo "itp binary not found at $ITP_BIN" >&2
  exit 1
fi

mkdir -p "$TARGET_DIR"
chmod +x "$ITP_BIN"
cp "$ITP_BIN" "$TARGET"
chmod +x "$TARGET"

if [ -d "$NODE_MODULES" ]; then
  rm -rf "$MODULE_TARGET"
  cp -R "$NODE_MODULES" "$MODULE_TARGET"
fi

if [ -d "$SKILLS_DIR" ]; then
  rm -rf "$SHARE_TARGET_DIR/skills"
  mkdir -p "$SHARE_TARGET_DIR"
  cp -R "$SKILLS_DIR" "$SHARE_TARGET_DIR/skills"
  find "$SHARE_TARGET_DIR/skills" -type f -exec chmod 0644 {} \;
fi

if [ -d "$DOCS_DIR" ]; then
  rm -rf "$SHARE_TARGET_DIR/docs"
  mkdir -p "$SHARE_TARGET_DIR"
  cp -R "$DOCS_DIR" "$SHARE_TARGET_DIR/docs"
  find "$SHARE_TARGET_DIR/docs" -type f -exec chmod 0644 {} \;
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
