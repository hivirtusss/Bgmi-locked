#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
MODULE_DIR="$ROOT/module"
OUT_DIR="$ROOT/dist"
ZIP_NAME="UniversalRootHide-KernelSU-v3.1.0-safe.zip"

mkdir -p "$OUT_DIR"
rm -f "$OUT_DIR"/UniversalRootHide-KernelSU-*.zip

(
  cd "$MODULE_DIR"
  zip -r9 "$OUT_DIR/$ZIP_NAME" . \
    -x "*.DS_Store" \
    -x "hide/*" \
    -x "boot.log"
)

echo "Built: $OUT_DIR/$ZIP_NAME"
unzip -l "$OUT_DIR/$ZIP_NAME"
