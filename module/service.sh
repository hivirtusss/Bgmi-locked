#!/system/bin/sh
MODDIR=${0%/*}
set +e
. "$MODDIR/common/safe_boot.sh"
MODDIR=$(resolve_moddir "$0")
. "$MODDIR/common/apply.sh"

(
  sleep 20
  hide_emulator_files_safe "$MODDIR"
  safe_log "service file hide OK"
) &
