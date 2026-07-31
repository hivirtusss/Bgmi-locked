#!/system/bin/sh
MODDIR=${0%/*}
. "$MODDIR/common/apply.sh"

apply_freecharge_core
apply_universal_upi_hide
ACTIVE=$(load_selected_profile "$MODDIR")
hide_emulator_and_root_files "$MODDIR"

/system/bin/log -t universal_root_hide -p i "Loaded profile=$ACTIVE all UPI apps" 2>/dev/null
