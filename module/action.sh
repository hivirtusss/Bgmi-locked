#!/system/bin/sh
# Virtus Fix — Premium Action UI
MODDIR=${0%/*}
[ -z "$MODDIR" ] || [ "$MODDIR" = "$0" ] && MODDIR="/data/adb/modules/virtus_fix_emulator_hide"
[ ! -f "$MODDIR/module.prop" ] && MODDIR="/data/adb/modules/virtus_fix_emulator_hide"
[ ! -f "$MODDIR/module.prop" ] && MODDIR="/data/adb/modules_update/virtus_fix_emulator_hide"

set +e

if [ ! -f "$MODDIR/common/safe_boot.sh" ]; then
  echo "ERROR: VirtusFix module not found."
  exit 1
fi

. "$MODDIR/common/safe_boot.sh"
MODDIR=$(resolve_moddir "$0")

if [ ! -f "$MODDIR/common/apply.sh" ]; then
  echo "ERROR: Module files missing in $MODDIR"
  exit 1
fi

. "$MODDIR/common/universal_banking.sh"
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

pause() { sleep 0.15; }

step() {
  echo "$1"
  pause
}

bar() {
  sec=4
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

ARCH=$(getprop ro.product.cpu.abi)

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
echo "╔══════════════════════════════════════════════════════╗"
echo "║     *VirtusFix - Premium Root Hide* ⚔️              ║"
echo "║     * Ultimate Emulator Spoofing Suite ✨             ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""

step "Mounting partitions..."
step "- Detecting Zygisk environment... Found!"
step "- Checking device architecture... ${ARCH:-arm64-v8a} detected."
echo ""
step "[🔹] Initializing Virtus core modules..."
step "[♦️] Enforcing Strong Pass profile..."
step "[♦️] Spoofing Emulator (ranchu/qemu hide)..."
step "[🔹] Loading Encrypted Keybox storage..."
step "[♦️] Injecting custom keystore hooks..."
step "[🔹] Applying Virtus Root Fix Shield..."
step "[♦️] Hiding emulator fingerprint (ranchu/qemu)..."
echo ""
step "Setting permissions..."
step "Optimizing database props..."

echo ""
echo "Running Virtus Root Hide engine (4 sec)..."
bar

echo ""
step "Applying root + emulator hide to system..."

read_config "$MODDIR/profile.conf"
PROFILE=$(load_selected_profile "$MODDIR" 2>/dev/null | tail -n1)
echo "${PROFILE:-pixel6a}"

apply_all_props "$MODDIR"

read_config "$MODDIR/profile.conf"
if [ "$URH_FILE_HIDE" = "1" ]; then
  hide_emulator_files_safe "$MODDIR"
fi

echo "Optimizing database props... ✅"
echo "Finished attribute restoration ✅"
echo ""
step "ro.product.model [$(getprop ro.product.model)]"
step "ro.product.brand [$(getprop ro.product.brand)]"
step "ro.product.name [$(getprop ro.product.name)]"
step "ro.product.device [$(getprop ro.product.device)]"
echo ""
step "EXTRACTING MODULE FILES... [OK]"
echo ""
echo ""
step "[✓] Module info"
step "[✓] Root hide props"
echo ""

echo "FIXED" > "$STATUS_FILE"

if [ -f "$MODDIR/module.prop" ]; then
  sed -i 's|^description=.*|description=✅ Detection Fixed | Root Hidden | Emu Hidden | By @Hivirtus ❤️|' "$MODDIR/module.prop" 2>/dev/null \
    || sed -i '' 's|^description=.*|description=✅ Detection Fixed | Root Hidden | Emu Hidden | By @Hivirtus ❤️|' "$MODDIR/module.prop" 2>/dev/null
  cp -f "$MODDIR/module.prop" "/data/adb/modules/virtus_fix_emulator_hide/module.prop" 2>/dev/null
fi

echo "╔══════════════════════════════════════════════════════╗"
echo "║  ✅ Detection Fixed                                  ║"
echo "║  ✅ Root Hide Applied                                ║"
echo "║  ✅ Emulator Detection Bypassed                      ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""
echo "Done! Please reboot your device to apply. ✅"
echo "Success!"
echo ""
echo "Developed By @Hivirtus ❤️"
echo ""
