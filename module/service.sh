#!/system/bin/sh
MODDIR=${0%/*}

set +e
. "$MODDIR/common/safe_boot.sh"
. "$MODDIR/common/apply.sh"

read_config "$MODDIR/profile.conf"

sleep 5
apply_all_props "$MODDIR"

if [ "$URH_FILE_HIDE" = "1" ]; then
  hide_emulator_files_safe "$MODDIR"
fi

safe_log "service OK"
