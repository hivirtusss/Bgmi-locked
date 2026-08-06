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

echo ""
echo "  __     __  _   _ ____  _   _ ____  "
echo "  \ \   / / | | | |  _ \| | | / ___| "
echo "   \ \ / /  | | | | |_) | | | \___ \ "
echo "    \ V /   | |_| |  _ <| |_| |___) |"
echo "     \_/     \___/|_| \_\\___/|____/ "
echo ""
echo " VirtusFix Premium Root Hide V3"
echo ""
echo "Applying hide props..."
echo ""

PROFILE=$(virtus_apply_all "$MODDIR")
echo "Profile: $PROFILE"
echo ""

if update_module_status "$MODDIR" "FIXED" "OK Detection Fixed | Reboot Now | By @Hivirtus"; then
  STATUS_MSG="OK Detection Fixed"
else
  STATUS_MSG="Props applied — reboot now (refresh module list if description unchanged)"
fi

echo "======================================"
echo "  $STATUS_MSG"
echo "  OK Root Hide Applied"
echo "  OK Emulator Hide Applied"
echo "======================================"
echo ""
echo "REBOOT NOW (mandatory — apps crash if you skip reboot)"
echo ""
echo "Then KernelSU -> App -> BharatPe/Freo"
echo "-> Hide Root ON"
echo ""
echo "Developed By @Hivirtus"
echo ""
