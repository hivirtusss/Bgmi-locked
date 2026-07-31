#!/system/bin/sh
MODDIR=${0%/*}

echo "=== Universal Root Hide (ALL UPI Apps) ==="
echo
echo "Active profile:"
grep '^profile=' "$MODDIR/profile.conf" 2>/dev/null || echo "  profile=pixel9proxl (default)"
echo
echo "Available profiles (edit profile.conf + reboot):"
echo "  pixel7      -> Pixel 7 (panther)"
echo "  pixel7pro   -> Pixel 7 Pro (cheetah)"
echo "  pixel8pro   -> Pixel 8 Pro (husky)"
echo "  pixel9      -> Pixel 9 (tokay)"
echo "  pixel9a     -> Pixel 9a (akita)"
echo "  pixel9proxl -> Pixel 9 Pro XL (pantah) [FreeCharge default]"
echo
echo "Current spoofed device:"
for key in ro.product.model ro.product.device ro.build.fingerprint ro.build.type; do
  echo "  $key=$(getprop $key)"
done
echo
echo "Root / emulator hide (all apps):"
for key in ro.kernel.qemu ro.boot.qemu ro.debuggable ro.secure ro.dalvik.vm.native.bridge; do
  echo "  $key=$(getprop $key)"
done
echo
echo "UPI apps covered: FreeCharge BharatPe Paytm PhonePe GPay YesPay LXME IND + all"
echo "Tip: KernelSU -> app -> Unmount modules + Hide root"
