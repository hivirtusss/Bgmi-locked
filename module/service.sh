#!/system/bin/sh
# Late boot: re-apply props + safe file hide (system already up = smooth boot)
MODDIR=${0%/*}

set +e
. "$MODDIR/common/safe_boot.sh"
. "$MODDIR/common/apply.sh"

read_config "$MODDIR/profile.conf"

# Wait for emulator services to settle — prevents stack/freeze on boot
sleep 5

safe_run_sync apply_all_props "$MODDIR"

if [ "$URH_FILE_HIDE" = "1" ]; then
  hide_emulator_files_safe "$MODDIR"
fi

safe_log "service OK late hide done"
