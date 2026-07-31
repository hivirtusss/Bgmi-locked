#!/system/bin/sh
MODDIR=${0%/*}
. "$MODDIR/common/apply.sh"

apply_freecharge_core
apply_universal_upi_hide
load_selected_profile "$MODDIR" >/dev/null
hide_emulator_and_root_files "$MODDIR"
