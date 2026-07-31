#!/system/bin/sh
MODDIR=${0%/*}

echo "=== Universal Root & Emulator Hide ==="
echo "Scope: ALL apps (system-wide props + file hide)"
echo
echo "Pixel 9 Pro XL props:"
for key in ro.product.model ro.product.device ro.hardware ro.build.fingerprint ro.build.type ro.build.tags; do
  echo "  $key=$(getprop "$key")"
done
echo
echo "Emulator hide:"
for key in ro.kernel.qemu ro.boot.qemu ro.debuggable ro.secure ro.dalvik.vm.native.bridge; do
  echo "  $key=$(getprop "$key")"
done
echo
echo "Root / boot state:"
for key in ro.boot.verifiedbootstate ro.boot.flash.locked ro.boot.vbmeta.device_state; do
  echo "  $key=$(getprop "$key")"
done
echo
echo "Hidden mounts:"
mount | grep "$MODDIR/hide" || echo "  (reboot if just installed)"
echo
echo "KernelSU tip: enable Unmount modules + Hide root per app for max hide."
