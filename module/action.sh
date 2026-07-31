#!/system/bin/sh
MODDIR=${0%/*}

echo "=== Emulator Root & Detection Fix ==="
echo
echo "Module path: $MODDIR"
echo
echo "Current critical props:"
for key in ro.kernel.qemu ro.boot.qemu ro.hardware ro.product.model ro.build.type ro.debuggable ro.secure; do
  echo "  $key=$(getprop "$key")"
done
echo
echo "Hidden targets:"
mount | grep "$MODDIR/hide" || echo "  (none mounted yet - reboot if module was just installed)"
echo
echo "Required manual steps in KernelSU Manager:"
echo "  1. Modules -> ensure this module is enabled"
echo "  2. For each crashing app -> App profile:"
echo "     - Enable 'Unmount modules' (or 'Exclude modules')"
echo "     - Enable root hiding / non-root mode for that app"
echo "  3. Reboot after changing profiles"
echo
echo "If apps still crash, install meta-overlayfs + SUSFS/ZygiskNext as needed."
