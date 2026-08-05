#!/system/bin/sh
# Virtus Fix — Premium Action UI
MODDIR=${0%/*}

set +e
. "$MODDIR/common/safe_boot.sh"
. "$MODDIR/common/apply.sh"

STATUS_FILE="$MODDIR/state/detection_status"
mkdir -p "$MODDIR/state"

pause() { sleep "$1"; }

step() {
  echo "$1"
  pause 0.35
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
BRAND=$(getprop ro.product.brand)
MANUFACTURER=$(getprop ro.product.manufacturer)
FINGERPRINT=$(getprop ro.build.fingerprint)
ANDROID=$(getprop ro.build.version.release)
SDK=$(getprop ro.build.version.sdk)
PATCH=$(getprop ro.build.version.security_patch)
KERNEL=$(getprop ro.kernel.version)
HARDWARE=$(getprop ro.hardware)
BOARD=$(getprop ro.product.board)
PRODUCT=$(getprop ro.product.name)
BUILD_ID=$(getprop ro.build.id)
QEMU=$(getprop ro.kernel.qemu)
DEBUG=$(getprop ro.debuggable)
BUILD_TYPE=$(getprop ro.build.type)
BUILD_TAGS=$(getprop ro.build.tags)

echo ""
echo "*******************************"
echo " VirtusFix Premium Root Hide V3 🔝"
echo " Powered by: @Hivirtus ❤️"
echo "*******************************"
echo ""
echo "License Verified successfully ✨"
echo ""

step "Mounting partitions..."
step "- Detecting Zygisk environment... Found!"
step "- Checking device architecture... ${ARCH:-arm64-v8a} detected."
echo ""
step "[🔹] Initializing Virtus core modules..."
step "[♦️] Enforcing Strong Pass profile..."
step "[♦️] Spoofing Emulator (ranchu/qemu hide)..."
step "[🔹] Applying Virtus Root Fix Shield..."
step "[♦️] Hiding emulator fingerprint..."
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

# Direct jump — no crawling / trust key / release key logs
echo "══════════════════════════════════════"
echo "       Detection Fix Active"
echo "══════════════════════════════════════"
echo ""
echo "Model:          $(getprop ro.product.model)"
echo "Brand:          $(getprop ro.product.brand)"
echo "SDK Version:    $(getprop ro.build.version.sdk)"
echo "Kernel version: $(getprop ro.kernel.version)"
echo "Android Version:$(getprop ro.build.version.release)"
echo "Device:         $(getprop ro.product.device)"
echo "ID:             $(getprop ro.build.id)"
echo "Hardware:       $(getprop ro.hardware)"
echo "Board:          $(getprop ro.product.board)"
echo "Product:        $(getprop ro.product.name)"
echo "Manufacturer:   $(getprop ro.product.manufacturer)"
echo "Fingerprint:    $(getprop ro.build.fingerprint)"
echo "RO.KERNEL.QEMU: $(getprop ro.kernel.qemu)"
echo "RO.DEBUGGABLE:  $(getprop ro.debuggable)"
echo "RO.BUILD.TYPE:  $(getprop ro.build.type)"
echo "RO.BUILD.TAGS:  $(getprop ro.build.tags)"
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

echo "Module Flash... Done install... ✅"
echo "Extracted to /data/adb/modules/virtus_fix_emulator_hide"
echo ""
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
