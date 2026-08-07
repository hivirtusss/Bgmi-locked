#!/system/bin/sh
MODDIR=${0%/*}
set +e
. "$MODDIR/common/safe_boot.sh"
MODDIR=$(resolve_moddir "$0")
. "$MODDIR/common/apply.sh"

read_boot_config "$MODDIR"

# Default: apply at boot before apps start (crash-safe)
if [ "$BOOT_APPLY" = "0" ]; then
  safe_log "boot skip — Action only"
  exit 0
fi

virtus_apply_all "$MODDIR"
safe_log "post-fs-data emu-hide OK"
