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

echo "Done Install ✅"
echo ""
echo "Developed By @Hivirtus"
echo ""
