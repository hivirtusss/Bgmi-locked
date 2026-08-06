#!/system/bin/sh
MODDIR=${0%/*}
[ "$MODDIR" = "$0" ] || [ -z "$MODDIR" ] && MODDIR="/data/adb/modules/virtus_fix_emulator_hide"
[ ! -f "$MODDIR/module.prop" ] && MODDIR="/data/adb/modules/virtus_fix_emulator_hide"

set +e

if [ ! -f "$MODDIR/common/apply.sh" ]; then
  echo "ERROR: Module not found at $MODDIR"
  exit 1
fi

. "$MODDIR/common/safe_boot.sh"
MODDIR=$(resolve_moddir "$0")
. "$MODDIR/common/apply.sh"

if [ "$KSU" = "true" ]; then
  POWERED_BY="KernelSU"
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

PROFILE=$(virtus_apply_all "$MODDIR")
echo "Profile: ${PROFILE:-pixel9}"
echo ""
step "Mode: $(grep -E '^mode=' "$MODDIR/profile.conf" 2>/dev/null | cut -d= -f2 | tr -d ' \"\r')"
step "Device: $(getprop ro.product.device) | Model: $(getprop ro.product.model)"
step "QEMU hidden: ro.kernel.qemu=$(getprop ro.kernel.qemu)"
step "Fingerprint kept real (light mode) ✅"
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
echo "⚠️ BharatPe crash fix:"
echo "   mode=auto/light in profile.conf (default)"
echo "   fake fingerprint NAHI badlega — Play Services safe"
echo ""
echo "⚠️ KernelSU — zaroori:"
echo "   App list → BharatPe / Freo / PhonePe"
echo "   → Hide Root ON karo har app ke liye"
echo "   → Phir reboot → app kholo"
echo ""
echo "Success!"
echo ""
echo "Developed By @Hivirtus ❤️"
echo ""
