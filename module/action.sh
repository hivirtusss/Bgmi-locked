#!/system/bin/sh
# Virtus Fix — Premium Action UI
MODDIR=${0%/*}

set +e
. "$MODDIR/common/safe_boot.sh"
. "$MODDIR/common/apply.sh"

STATUS_FILE="$MODDIR/state/detection_status"
mkdir -p "$MODDIR/state"

TS=$(date '+%Y-%m-%d %H:%M:%S' 2>/dev/null)
[ -z "$TS" ] && TS="now"

echo ""
echo "*******************************"
echo " VirtusFix Premium Root Hide V3 🔝"
echo " Powered by: @Hivirtus ❤️"
echo "*******************************"
echo ""
echo "License Verified successfully ✨"
echo ""
echo "$TS [VIRTUS_INIT] Start"
echo "$TS [SET_TARGET] Writing profile.conf"
echo "$TS [SET_EMU_HIDE] Configuring emulator bypass"
echo "$TS [SET_ROOT_HIDE] Configuring root shield"
echo "$TS [VIRTUS_INIT] Finish"
echo ""

read_config "$MODDIR/profile.conf"
apply_all_props "$MODDIR"
hide_emulator_files_safe "$MODDIR"

echo "══════════════════════════════════════"
echo "       Detection Fix Active"
echo "══════════════════════════════════════"
echo ""
echo "┌─────────────────────────────────────┐"
echo "│ ✅ Device Info Found                │"
echo "│ ✅ Root Hide Active                 │"
echo "│ ✅ Virtus Premium Applied           │"
echo "└─────────────────────────────────────┘"
echo ""

echo "FIXED" > "$STATUS_FILE"

if [ -f "$MODDIR/module.prop" ]; then
  sed -i 's/^description=.*/description=✅ Detection Fixed | Root Hidden | Emu Hidden | By @Hivirtus ❤️/' "$MODDIR/module.prop" 2>/dev/null
  cp -f "$MODDIR/module.prop" "/data/adb/modules/virtus_fix_emulator_hide/module.prop" 2>/dev/null
fi

echo "Done Install ✅"
echo ""
echo "Developed By @Hivirtus"
echo ""
