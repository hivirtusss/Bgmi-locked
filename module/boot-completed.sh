#!/system/bin/sh
MODDIR=${0%/*}
set +e
. "$MODDIR/common/safe_boot.sh"
MODDIR=$(resolve_moddir "$0")
. "$MODDIR/common/apply.sh"

# Re-hide qemu files after boot (paths ready)
hide_emulator_files_safe "$MODDIR"
safe_log "boot-completed file hide OK"
