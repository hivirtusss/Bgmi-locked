#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
MODULE_DIR="$ROOT/module"
OUT_DIR="$ROOT/dist"
ZIP_NAME="UniversalRootHide-KernelSU-v3.0.0.zip"

mkdir -p "$OUT_DIR"
rm -f "$OUT_DIR"/UniversalRootHide-KernelSU-*.zip

(
  cd "$MODULE_DIR"
  zip -r9 "$OUT_DIR/$ZIP_NAME" . \
    -x "*.DS_Store" \
    -x "hide/*"
)

echo "Built: $OUT_DIR/$ZIP_NAME"
unzip -l "$OUT_DIR/$ZIP_NAME"
