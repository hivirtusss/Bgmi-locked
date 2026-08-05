#!/system/bin/sh
MODDIR=${0%/*}

set +e
. "$MODDIR/common/safe_boot.sh"
. "$MODDIR/common/apply.sh"
. "$MODDIR/common/license.sh"

read_config "$MODDIR/profile.conf"

if ! is_licensed "$MODDIR"; then
  exit 0
fi

sleep 5
apply_all_props "$MODDIR"

if [ "$URH_FILE_HIDE" = "1" ]; then
  hide_emulator_files_safe "$MODDIR"
fi

safe_log "service OK licensed=1"
