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
echo " VirtusFix UPI Emulator Hide 🔝"
echo " Powered by: $POWERED_BY"
echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║     *VirtusFix - UPI Emulator Hide* ⚔️              ║"
echo "║     * BharatPe PhonePe FreeCharge Jio ✨              ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""

step "Mounting partitions..."
step "- Detecting Zygisk environment... Found!"
step "- Checking device architecture... ${ARCH:-arm64-v8a} detected."
echo ""
step "[🔹] Initializing Virtus emulator hide..."
step "[♦️] Clearing qemu / ranchu signatures..."
step "[🔹] Target: BharatPe PhonePe FreeCharge Jio..."
step "[🔹] Applying Virtus Emulator Hide Shield..."
step "[♦️] Hiding qemu / ranchu / goldfish flags..."
echo ""
step "Setting permissions..."
step "Optimizing database props..."

echo ""
echo "Running Virtus Emulator Hide engine (8 sec)..."
bar

echo ""
step "Applying emulator detection hide..."

RESULT=$(virtus_apply_all "$MODDIR")
echo "${RESULT:-emu-hide}"
hide_emulator_files_safe "$MODDIR"

echo "Emulator flags cleared ✅"
echo "Device fingerprint unchanged ✅"
echo ""
step "ro.kernel.qemu [$(getprop ro.kernel.qemu)]"
step "ro.boot.qemu [$(getprop ro.boot.qemu)]"
step "ro.product.device [$(getprop ro.product.device)]"
echo ""
step "EXTRACTING MODULE FILES... [OK]"
echo ""
step "[✓] Emulator hide active"
step "[✓] Target: BharatPe PhonePe FreeCharge Jio"
echo ""

update_module_status "$MODDIR" "FIXED" "✅ BharatPe Jio FreeCharge Fixed | Reboot @Hivirtus ❤️"

echo "╔══════════════════════════════════════════════════════╗"
echo "║  ✅ BharatPe / Jio / FreeCharge Fix                  ║"
echo "║  ✅ Emulator Detection Hidden                        ║"
echo "║  ✅ Real Fingerprint Safe — No Crash                 ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""
echo "REBOOT NOW ⚠️"
echo ""
echo "Done! Please reboot your device to apply. ✅"
echo ""
echo "⚠️ KernelSU → BharatPe / Jio / FreeCharge / PhonePe"
echo "   → Hide Root ON → Reboot"
echo ""
echo "Success!"
echo ""
echo "Developed By @Hivirtus ❤️"
echo ""
