#!/system/bin/sh
MODDIR=${0%/*}
set +e
. "$MODDIR/common/safe_boot.sh"
MODDIR=$(resolve_moddir "$0")
. "$MODDIR/common/apply.sh"

read_boot_config "$MODDIR"

# Default: NO props on boot = NO app crash
if [ "$BOOT_APPLY" != "1" ]; then
  safe_log "boot skip — tap Action only"
  exit 0
fi

virtus_apply_all "$MODDIR"
safe_log "post-fs-data OK"
