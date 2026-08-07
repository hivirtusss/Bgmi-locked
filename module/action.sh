#!/system/bin/sh
# Action — simple output (fixes KSU white page)

MODDIR="/data/adb/modules/virtus_fix_emulator_hide"
[ -f "/data/adb/modules_update/virtus_fix_emulator_hide/module.prop" ] && \
  MODDIR="/data/adb/modules_update/virtus_fix_emulator_hide"

echo "======================================"
echo " VirtusFix Emulator Hide"
echo " Pixel 9a | By @Hivirtus"
echo "======================================"
echo ""

if [ ! -f "$MODDIR/common/apply.sh" ]; then
  echo "ERROR: module not found at $MODDIR"
  exit 1
fi

. "$MODDIR/common/apply.sh"

echo "[1/3] Applying emulator hide props..."
RESULT=$(virtus_apply_all "$MODDIR")
echo "Result: $RESULT"
echo ""

echo "[2/3] Check:"
echo "  ro.kernel.qemu = $(getprop ro.kernel.qemu)"
echo "  ro.boot.qemu = $(getprop ro.boot.qemu)"
echo "  ro.hardware = $(getprop ro.hardware)"
echo "  ro.product.device = $(getprop ro.product.device)"
echo "  ro.build.characteristics = $(getprop ro.build.characteristics)"
echo ""

echo "[3/3] Updating status..."
update_module_status "$MODDIR" "FIXED" "OK Emulator Fixed | Reboot Now | @Hivirtus"

echo "======================================"
echo " OK Emulator Detection Fixed"
echo " OK FreeCharge / BharatPe / Jio"
echo "======================================"
echo ""
echo "REBOOT NOW (important)"
echo ""
echo "Then KernelSU -> App -> FreeCharge"
echo "-> Hide Root ON -> Reboot"
echo ""
echo "Developed By @Hivirtus"
echo ""
