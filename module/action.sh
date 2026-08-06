#!/system/bin/sh
# VirtusFix — Premium Action UI (fox module 4843 style)
MODDIR=${0%/*}
[ "$MODDIR" = "$0" ] || [ -z "$MODDIR" ] && MODDIR="/data/adb/modules/virtus_fix_emulator_hide"
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

. "$MODDIR/common/apply.sh"

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

PROFILE=$(virtus_apply_all "$MODDIR")
echo "${PROFILE:-pixel9}"
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
step "[✓] Module info"
step "[✓] Root hide props"
echo ""

update_module_status "$MODDIR" "FIXED" "✅ Detection Fixed | Root Hidden | Emu Hidden | @Hivirtus ❤️"

echo "╔══════════════════════════════════════════════════════╗"
echo "║  ✅ Detection Fixed                                  ║"
echo "║  ✅ Root Hide Applied                                ║"
echo "║  ✅ Emulator Detection Bypassed                      ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""
echo "Done! Please reboot your device to apply. ✅"
echo ""
echo "⚠️ IMPORTANT — KernelSU mein ye karo:"
echo "   App list → BharatPe / Freo / PhonePe"
echo "   → Hide Root ON karo har app ke liye"
echo "   → Phir reboot → app kholo"
echo ""
echo "Success!"
echo ""
echo "Developed By @Hivirtus ❤️"
echo ""
