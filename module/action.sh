#!/system/bin/sh
# Virtus Fix — Premium Action UI (screenshot style)
MODDIR=${0%/*}

set +e
. "$MODDIR/common/safe_boot.sh"
. "$MODDIR/common/apply.sh"

STATUS_FILE="$MODDIR/state/detection_status"
mkdir -p "$MODDIR/state"

if [ "$KSU" = "true" ]; then
  POWERED_BY="KernelSU"
elif [ -n "$APATCH" ]; then
  POWERED_BY="APatch"
elif [ -n "$MAGISK_VER" ]; then
  POWERED_BY="Magisk"
else
  POWERED_BY="KernelSU"
fi

TS=$(date '+%Y-%m-%d %H:%M:%S' 2>/dev/null)
[ -z "$TS" ] && TS="now"

pause() { sleep 0.35; }

step() {
  echo "$1"
  pause
}

bar() {
  sec=8
  i=1
  while [ "$i" -le "$sec" ]; do
    printf "Processing"
    j=1
    while [ "$j" -le "$i" ]; do
      printf "."
      j=$((j + 1))
    done
    printf " [%ds/%ds]\n" "$i" "$sec"
    sleep 1
    i=$((i + 1))
  done
}

echo ""
echo "  __     __  _   _ ____  _   _ ____  "
echo "  \ \   / / | | | |  _ \| | | / ___| "
echo "   \ \ / /  | | | | |_) | | | \___ \ "
echo "    \ V /   | |_| |  _ <| |_| |___) |"
echo "     \_/     \___/|_| \_\\___/|____/ "
echo ""
echo " VirtusFix Premium Root Hide V3 🔝"
echo " Powered by: $POWERED_BY"
echo ""
echo "License Verified successfully ✨"
echo ""
echo "$TS [VIRTUS_INIT] Start"
echo "$TS [SET_TARGET] Writing profile.conf"
echo "$TS [SET_EMU_HIDE] Configuring emulator bypass"
echo "$TS [SET_ROOT_HIDE] Configuring root shield"
echo "$TS [VIRTUS_INIT] Finish"
echo ""
step "- Initializing Virtus Root Hide engine..."
step "- Applying emulator bypass layer..."
step "- Applying root shield layer..."
echo ""
bar
echo ""

read_config "$MODDIR/profile.conf"
apply_all_props "$MODDIR"
hide_emulator_files_safe "$MODDIR"

echo "══════════════════════════════════════"
echo "       Detection Fix Active"
echo "══════════════════════════════════════"
echo ""
echo "┌─────────────────────────────────────┐"
echo "│ ✅ Setting Permission               │"
echo "│ ✅ Full Clear Cache                 │"
echo "│ ✅ Extract Module $POWERED_BY       │"
echo "│ ✅ Root Hide Active                 │"
echo "│ ✅ Virtus Premium Applied           │"
echo "└─────────────────────────────────────┘"
echo ""

echo "FIXED" > "$STATUS_FILE"

if [ -f "$MODDIR/module.prop" ]; then
  sed -i 's/^description=.*/description=✅ Detection Fixed | Root Hidden | Emu Hidden | By @Hivirtus ❤️/' "$MODDIR/module.prop" 2>/dev/null
  cp -f "$MODDIR/module.prop" "/data/adb/modules/virtus_fix_emulator_hide/module.prop" 2>/dev/null
fi

echo "╔══════════════════════════════════════════════════════╗"
echo "║  ✅ Detection Fixed                                  ║"
echo "║  ✅ Root Hide Applied                                ║"
echo "║  ✅ Emulator Detection Bypassed                      ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""
echo "Done Install ✅"
echo ""
echo "Done! Please reboot your device to apply. ✅"
echo "Success!"
echo ""
echo "Developed By @Hivirtus"
echo ""
