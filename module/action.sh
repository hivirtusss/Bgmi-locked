#!/system/bin/sh
MODDIR=${0%/*}
[ -z "$MODDIR" ] || [ "$MODDIR" = "$0" ] && MODDIR="/data/adb/modules/virtus_fix_emulator_hide"
[ ! -f "$MODDIR/module.prop" ] && MODDIR="/data/adb/modules/virtus_fix_emulator_hide"

set +e
. "$MODDIR/common/safe_boot.sh"
MODDIR=$(resolve_moddir "$0")
. "$MODDIR/common/apply.sh"

if [ "$KSU" = "true" ]; then
  POWERED_BY="KernelSU"
else
  POWERED_BY="KernelSU"
fi

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
echo "Applying root + emulator hide..."
echo ""

PROFILE=$(virtus_apply_all "$MODDIR")
echo "Profile: ${PROFILE:-pixel9proxl}"
echo ""
echo "ro.product.model [$(getprop ro.product.model)]"
echo "ro.product.device [$(getprop ro.product.device)]"
echo "ro.kernel.qemu [$(getprop ro.kernel.qemu)]"
echo "ro.debuggable [$(getprop ro.debuggable)]"
echo ""

update_module_status "$MODDIR" "FIXED" "✅ Detection Fixed | Root Hidden | Emu Hidden | @Hivirtus ❤️"

echo "╔══════════════════════════════════════════════════════╗"
echo "║  ✅ Detection Fixed                                  ║"
echo "║  ✅ Root Hide Applied                                ║"
echo "║  ✅ Emulator Detection Bypassed                      ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""
echo "Done! Reboot now. ✅"
echo ""
echo "⚠️ KernelSU → App → BharatPe/Freo → Hide Root ON"
echo ""
echo "Developed By @Hivirtus ❤️"
echo ""
