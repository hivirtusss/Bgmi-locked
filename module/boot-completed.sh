#!/system/bin/sh
# Optional: light prop refresh after UI is ready
MODDIR=${0%/*}

set +e
. "$MODDIR/common/safe_boot.sh"
. "$MODDIR/common/apply.sh"

read_config "$MODDIR/profile.conf"
safe_run_sync apply_freecharge_core
safe_run_sync apply_universal_upi_hide

safe_log "boot-completed refresh OK"
