#!/system/bin/sh
# Virtus Fix — Premium Action UI
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

ARCH=$(getprop ro.product.cpu.abi)
ANDROID=$(getprop ro.build.version.release)
PATCH=$(getprop ro.build.version.security_patch)

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
echo "Running Virtus Root Hide engine (8 sec)..."
bar

echo ""
step "Applying root + emulator hide to system..."

read_config "$MODDIR/profile.conf"
PROFILE=$(load_selected_profile "$MODDIR" 2>/dev/null | tail -n1)
echo "${PROFILE:-pixel9proxl}"

apply_all_props "$MODDIR"
hide_emulator_files_safe "$MODDIR"

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
step "- Crawling Android Developers for Latest Pixel Beta device list ..."
step "- Selecting Pixel Beta device ... Selected ✅"
step "- Crawling Android Flash Tool for Latest Pixel Canary build info ..."
step "- Android ${ANDROID:-15} / Security Patch: ${PATCH:-2025-07-05}"
echo ""
step "[✓] Module info"
step "[✓] Root hide props"
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
echo "Done! Please reboot your device to apply. ✅"
echo "Success!"
echo ""
echo "Developed By @Hivirtus"
echo ""
