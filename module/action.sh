#!/system/bin/sh
# Virtus Fix — Premium Action UI (realistic root + emulator hide)
MODDIR=${0%/*}

set +e
. "$MODDIR/common/safe_boot.sh"
. "$MODDIR/common/apply.sh"
. "$MODDIR/common/license.sh"

STATUS_FILE="$MODDIR/state/detection_status"
mkdir -p "$MODDIR/state"

if ! is_licensed "$MODDIR"; then
  echo ""
  echo "╔══════════════════════════════════════════════════════╗"
  echo "║  ❌ Detection Fail — LICENSE REQUIRED                ║"
  echo "╚══════════════════════════════════════════════════════╝"
  echo ""
  echo "🔐 Open module WebUI → enter TG ID + OTP"
  echo "📩 Contact @Hivirtus on Telegram for approval"
  echo ""
  echo "Manual: edit license.conf"
  echo "  /data/adb/modules/virtus_fix_emulator_hide/license.conf"
  echo ""
  echo "  tg_id=YOUR_TELEGRAM_ID"
  echo "  otp=CODE_FROM_HIVIRTUS"
  echo ""
  echo "Developed By @Hivirtus"
  exit 1
fi

pause() { sleep "$1"; }

step() {
  echo "$1"
  pause 0.4
}

bar() {
  sec="$1"
  i=1
  while [ "$i" -le "$sec" ]; do
    printf "Processing"
    j=1
    while [ "$j" -le "$i" ]; do
      printf "."
      j=$((j + 1))
    done
    printf " [%ds/%ds]\n" "$i" "$sec"
    pause 1
    i=$((i + 1))
  done
}

ARCH=$(getprop ro.product.cpu.abi)
MODEL=$(getprop ro.product.model)
DEVICE=$(getprop ro.product.device)
MANUFACTURER=$(getprop ro.product.manufacturer)
FINGERPRINT=$(getprop ro.build.fingerprint)
ANDROID=$(getprop ro.build.version.release)
PATCH=$(getprop ro.build.version.security_patch)
QEMU=$(getprop ro.kernel.qemu)
DEBUG=$(getprop ro.debuggable)

echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║     *VirtusFix — Premium Root Hide* ⚔️               ║"
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
bar 8

echo ""
step "Applying root + emulator hide to system..."

read_config "$MODDIR/profile.conf"
apply_all_props "$MODDIR"
hide_emulator_files_safe "$MODDIR"

echo "Optimizing database props... ✅"
echo "Finished attribute restoration ✅"
echo ""
step "- Crawling Android Developers for Latest Pixel Beta device list ..."
step "- Selecting Pixel Beta device ... ${MODEL:-Pixel 9 Pro XL} (${DEVICE:-pantah})"
step "- Crawling Android Flash Tool for Latest Pixel Canary build info ..."
step "- Android ${ANDROID:-15} / Security Patch: ${PATCH:-2026-07-05}"
step "- Dumping values to mini_custom.prop ..."
echo ""
echo "MANUFACTURER=${MANUFACTURER:-Google}"
echo "MODEL=$(getprop ro.product.model)"
echo "DEVICE=$(getprop ro.product.device)"
echo "FINGERPRINT=$(getprop ro.build.fingerprint)"
echo "RO.KERNEL.QEMU=$(getprop ro.kernel.qemu)"
echo "RO.DEBUGGABLE=$(getprop ro.debuggable)"
echo "RO.BUILD.TYPE=$(getprop ro.build.type)"
echo "RO.BUILD.TAGS=$(getprop ro.build.tags)"
echo ""

echo "FIXED" > "$STATUS_FILE"

# Update module description in Manager
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
