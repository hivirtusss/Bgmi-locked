#!/system/bin/sh
MODDIR=${0%/*}

echo "=== Universal Root Hide v3.1 SAFE ==="
echo
echo "Boot safety:"
echo "  skip_mount=$(test -f $MODDIR/skip_mount && echo YES || echo NO)"
echo "  late_file_hide=$(grep late_file_hide $MODDIR/profile.conf 2>/dev/null)"
echo "  boot.log=$(test -f $MODDIR/boot.log && echo present || echo none)"
echo
echo "Profile:"
grep '^profile=' "$MODDIR/profile.conf" 2>/dev/null || echo "  profile=pixel9proxl"
echo
echo "Spoofed device:"
for key in ro.product.model ro.product.device ro.build.fingerprint ro.kernel.qemu ro.debuggable; do
  echo "  $key=$(getprop $key)"
done
echo
echo "If bootloop: disable module in KernelSU safe mode"
echo "Or set file_hide=0 in profile.conf and reboot"
