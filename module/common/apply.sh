#!/system/bin/sh
# VirtusFix — deep root + emulator hide (all Pixel profiles, bootloop-safe)

if [ -x /data/adb/ksu/bin/resetprop ]; then
  RESETPROP=/data/adb/ksu/bin/resetprop
elif [ -x /data/adb/magisk/magisk ]; then
  RESETPROP="/data/adb/magisk/magisk resetprop"
else
  RESETPROP=resetprop
fi

reset_ro() {
  $RESETPROP -n "$1" "$2" 2>/dev/null || $RESETPROP "$1" "$2" 2>/dev/null || true
}

delete_prop() {
  $RESETPROP --delete "$1" 2>/dev/null || true
}

set_product_partition() {
  prefix="$1"
  codename="$2"
  model="$3"
  reset_ro "${prefix}.device" "$codename"
  reset_ro "${prefix}.name" "$codename"
  reset_ro "${prefix}.brand" "google"
  reset_ro "${prefix}.manufacturer" "Google"
  reset_ro "${prefix}.model" "$model"
}

apply_device_profile() {
  codename="$1"
  model="$2"
  fingerprint="$3"
  hardware="$4"
  platform="$5"

  for prefix in \
    ro.product \
    ro.product.system \
    ro.product.vendor \
    ro.product.odm \
    ro.product.system_ext \
    ro.product.product \
    ro.product.vendor_dlkm \
    ro.product.odm_dlkm; do
    set_product_partition "$prefix" "$codename" "$model"
  done

  reset_ro ro.build.product "$codename"
  reset_ro ro.product.board "$codename"
  reset_ro ro.product.hardware "$hardware"
  reset_ro ro.hardware "$hardware"
  reset_ro ro.boot.hardware "$hardware"
  reset_ro ro.board.platform "$platform"
  reset_ro ro.soc.model "$platform"
  reset_ro ro.bootloader "$hardware"-1.2-${platform}-9816218

  for fp in \
    ro.build.fingerprint \
    ro.bootimage.build.fingerprint \
    ro.vendor.build.fingerprint \
    ro.system.build.fingerprint \
    ro.odm.build.fingerprint \
    ro.system_ext.build.fingerprint \
    ro.vendor_dlkm.build.fingerprint \
    ro.odm_dlkm.build.fingerprint; do
    reset_ro "$fp" "$fingerprint"
  done

  reset_ro ro.build.flavor "${codename}-user"
  reset_ro ro.build.user android-build
  reset_ro ro.build.host android-build
}

apply_freecharge_core() {
  reset_ro ro.kernel.qemu 0
  reset_ro ro.boot.qemu 0
  reset_ro ro.kernel.qemu.gles 0
  reset_ro ro.kernel.qemu.dalvik 0
  reset_ro qemu.hw.mainkeys 0
  reset_ro init.svc.qemud stopped
  reset_ro ro.build.characteristics nosdcard
  reset_ro ro.boot.mode normal
  reset_ro ro.bootmode unknown
  reset_ro ro.build.tags release-keys
  reset_ro ro.build.type user
}

apply_emulator_deep_hide() {
  hardware="${1:-bluejay}"
  model="${2:-Pixel 6a}"

  delete_prop ro.boot.qemu.avd_name
  delete_prop ro.boot.qemu.settings.android.avd_name
  delete_prop ro.boot.qemu.virt_model
  delete_prop ro.boot.qemu.camera_protocol_ver
  delete_prop ro.boot.qemu.adb.pubkey
  delete_prop ro.boot.qemu.settings.systemdisk.data
  delete_prop ro.kernel.android.qemud
  delete_prop init.svc.qemu-props
  delete_prop init.svc.goldfish-logcat
  delete_prop init.svc.goldfish-setup
  delete_prop init.svc.qemud
  delete_prop persist.sys.qemu.vsync
  delete_prop qemu.sf.lcd_density

  reset_ro ro.kernel.qemu 0
  reset_ro ro.boot.qemu 0
  reset_ro ro.kernel.qemu.gles 0
  reset_ro ro.kernel.qemu.dalvik 0
  reset_ro qemu.hw.mainkeys 0
  reset_ro init.svc.qemud stopped
  reset_ro init.svc.qemu-props stopped
  reset_ro init.svc.goldfish-logcat stopped
  reset_ro init.svc.goldfish-setup stopped

  reset_ro ro.product.cpu.abi arm64-v8a
  reset_ro ro.product.cpu.abi2 armeabi-v7a
  reset_ro ro.product.cpu.abilist "arm64-v8a,armeabi-v7a,armeabi"
  reset_ro ro.product.cpu.abilist64 "arm64-v8a"
  reset_ro ro.product.cpu.abilist32 "armeabi-v7a,armeabi"

  reset_ro ro.hardware.egl mali
  reset_ro ro.hardware.vulkan mali
  reset_ro ro.hardware.gralloc mali
  reset_ro ro.setupwizard.mode DISABLED
  reset_ro ro.boot.selinux enforcing
  reset_ro ro.crypto.state encrypted
  reset_ro ro.crypto.type file
  reset_ro ro.test_harness 0
  reset_ro ro.monkey 0

  reset_ro gsm.sim.state READY
  reset_ro gsm.operator.alpha "Jio 4G"
  reset_ro gsm.operator.iso-country in
  reset_ro gsm.operator.isroam false
  reset_ro gsm.operator.numeric "405864"
  reset_ro gsm.sim.operator.alpha "Jio"
  reset_ro gsm.sim.operator.iso-country in
  reset_ro gsm.sim.operator.numeric "405864"
  reset_ro gsm.current.phone-type 1
  reset_ro ro.telephony.default_network 9,9

  reset_ro persist.sys.usb.config mtp
  reset_ro ro.adb.secure 1
  reset_ro service.adb.root 0

  reset_ro ro.hardware "$hardware"
  reset_ro ro.boot.hardware "$hardware"
  reset_ro ro.product.hardware "$hardware"
  reset_ro ro.product.device "$hardware"
  reset_ro ro.product.name "$hardware"
  reset_ro ro.product.model "$model"
  reset_ro ro.product.brand google
  reset_ro ro.product.manufacturer Google
  reset_ro ro.build.product "$hardware"

  reset_ro ro.vendor.build.type user
  reset_ro ro.system.build.type user
  reset_ro ro.system_ext.build.type user
  reset_ro ro.odm.build.type user
  reset_ro ro.bootimage.build.type user
  reset_ro ro.vendor.build.tags release-keys
  reset_ro ro.system.build.tags release-keys
  reset_ro ro.bootimage.build.tags release-keys
}

apply_kill_emulator_signatures() {
  hardware="$1"
  model="$2"
  codename="$3"

  live_hw=$(getprop ro.hardware 2>/dev/null)
  case "$live_hw" in
    ranchu|goldfish|generic*|vbox*|nox*|ttVM*|android_x86*)
      reset_ro ro.hardware "$hardware"
      reset_ro ro.boot.hardware "$hardware"
      reset_ro ro.product.hardware "$hardware"
      reset_ro ro.hardware.egl mali
      reset_ro ro.hardware.gralloc mali
      ;;
  esac

  live_dev=$(getprop ro.product.device 2>/dev/null)
  case "$live_dev" in
    generic*|sdk_gphone*|emulator*|vbox*|goldfish*|ranchu*)
      reset_ro ro.product.device "$codename"
      reset_ro ro.product.name "$codename"
      reset_ro ro.product.model "$model"
      reset_ro ro.product.brand google
      reset_ro ro.product.manufacturer Google
      reset_ro ro.build.product "$codename"
      ;;
  esac

  live_model=$(getprop ro.product.model 2>/dev/null)
  case "$live_model" in
    *sdk*|*Emulator*|*Android SDK*|*google_sdk*|*AOSP*)
      reset_ro ro.product.model "$model"
      ;;
  esac

  live_fp=$(getprop ro.build.fingerprint 2>/dev/null)
  case "$live_fp" in
    generic*|unknown*|sdk_gphone*)
      reset_ro ro.build.fingerprint "google/${codename}/${codename}:14/AP2A.240805.005/12345678:user/release-keys"
      ;;
  esac
}

apply_universal_upi_hide() {
  reset_ro ro.debuggable 0
  reset_ro ro.secure 1
  reset_ro ro.adb.secure 1
  reset_ro ro.allow.mock.location 0
  reset_ro service.adb.root 0
  reset_ro ro.build.selinux 1
  reset_ro ro.boot.verifiedbootstate green
  reset_ro ro.boot.veritymode enforcing
  reset_ro ro.boot.flash.locked 1
  reset_ro ro.boot.vbmeta.device_state locked
  reset_ro ro.boot.warranty_bit 0
  reset_ro ro.warranty_bit 0
  reset_ro ro.is_ever_orange 0
  reset_ro ro.crypto.state encrypted
  reset_ro ro.magisk.version ""
  reset_ro ro.magisk.versioncode 0
  reset_ro ro.dalvik.vm.native.bridge 0
  reset_ro ro.enable.native.bridge.exec 0
  reset_ro persist.sys.nativebridge 0

  delete_prop ro.kernel.su
}

load_selected_profile() {
  moddir="$1"
  conf="$moddir/profile.conf"
  profile=""

  if [ -n "$URH_PROFILE" ]; then
    profile="$URH_PROFILE"
  elif [ -f "$conf" ]; then
    profile=$(grep -E '^profile=' "$conf" 2>/dev/null | head -n1 | cut -d= -f2 | tr -d ' "\r')
  fi

  [ -z "$profile" ] && profile=pixel6a

  case "$profile" in
    pixel6a|bluejay)
      apply_device_profile bluejay "Pixel 6a" \
        "google/bluejay/bluejay:14/AP2A.240805.005/12345678:user/release-keys" \
        bluejay gs101
      apply_emulator_deep_hide bluejay "Pixel 6a"
      apply_kill_emulator_signatures bluejay "Pixel 6a" bluejay
      echo "pixel6a"
      ;;
    pixel6|oriole)
      apply_device_profile oriole "Pixel 6" \
        "google/oriole/oriole:14/AP2A.240805.005/12345678:user/release-keys" \
        oriole gs101
      apply_emulator_deep_hide oriole "Pixel 6"
      apply_kill_emulator_signatures oriole "Pixel 6" oriole
      echo "pixel6"
      ;;
    pixel7|panther)
      apply_device_profile panther "Pixel 7" \
        "google/panther/panther:14/AP2A.240805.005/12025142:user/release-keys" \
        panther gs201
      apply_emulator_deep_hide panther "Pixel 7"
      apply_kill_emulator_signatures panther "Pixel 7" panther
      echo "pixel7"
      ;;
    pixel7pro|cheetah)
      apply_device_profile cheetah "Pixel 7 Pro" \
        "google/cheetah/cheetah:14/AP2A.240805.005/12025142:user/release-keys" \
        cheetah gs201
      apply_emulator_deep_hide cheetah "Pixel 7 Pro"
      apply_kill_emulator_signatures cheetah "Pixel 7 Pro" cheetah
      echo "pixel7pro"
      ;;
    pixel8|shiba)
      apply_device_profile shiba "Pixel 8" \
        "google/shiba/shiba:14/AP2A.240905.003/12345678:user/release-keys" \
        shiba zuma
      apply_emulator_deep_hide shiba "Pixel 8"
      apply_kill_emulator_signatures shiba "Pixel 8" shiba
      echo "pixel8"
      ;;
    pixel8pro|husky)
      apply_device_profile husky "Pixel 8 Pro" \
        "google/husky/husky:14/AP2A.240905.003/12345678:user/release-keys" \
        husky zuma
      apply_emulator_deep_hide husky "Pixel 8 Pro"
      apply_kill_emulator_signatures husky "Pixel 8 Pro" husky
      echo "pixel8pro"
      ;;
    pixel9|tokay)
      apply_device_profile tokay "Pixel 9" \
        "google/tokay/tokay:15/AP3A.241005.015/1234567:user/release-keys" \
        tokay zuma
      apply_emulator_deep_hide tokay "Pixel 9"
      apply_kill_emulator_signatures tokay "Pixel 9" tokay
      echo "pixel9"
      ;;
    pixel9a|akita)
      apply_device_profile akita "Pixel 9a" \
        "google/akita/akita:15/AP3A.241005.015/1234567:user/release-keys" \
        akita zuma
      apply_emulator_deep_hide akita "Pixel 9a"
      apply_kill_emulator_signatures akita "Pixel 9a" akita
      echo "pixel9a"
      ;;
    pixel9proxl|pantah)
      apply_device_profile pantah "Pixel 9 Pro XL" \
        "google/pantah/pantah:15/AP3A.241005.015/1234567:user/release-keys" \
        pantah zuma
      apply_emulator_deep_hide pantah "Pixel 9 Pro XL"
      apply_kill_emulator_signatures pantah "Pixel 9 Pro XL" pantah
      echo "pixel9proxl"
      ;;
    *)
      apply_device_profile bluejay "Pixel 6a" \
        "google/bluejay/bluejay:14/AP2A.240805.005/12345678:user/release-keys" \
        bluejay gs101
      apply_emulator_deep_hide bluejay "Pixel 6a"
      apply_kill_emulator_signatures bluejay "Pixel 6a" bluejay
      echo "pixel6a"
      ;;
  esac
}

bind_hide_file_safe() {
  moddir="$1"
  target="$2"

  [ -e "$target" ] || return 0
  case "$target" in
    /system/*|/vendor/*|/product/*|/system_ext/*)
      return 0
      ;;
  esac

  mount | grep -Fq " $target " && return 0

  hide="$moddir/hide/$(echo "$target" | tr '/' '_')"
  mkdir -p "$(dirname "$hide")" 2>/dev/null || return 0
  : > "$hide" 2>/dev/null || return 0
  chmod 000 "$hide" 2>/dev/null || true
  mount -o bind "$hide" "$target" 2>/dev/null || true
}

hide_emulator_files_safe() {
  moddir="$1"
  for path in \
    /dev/qemu_pipe \
    /dev/goldfish_pipe \
    /dev/goldfish_sync \
    /dev/goldfish_address_space \
    /dev/vhost-vsock \
    /dev/socket/qemud \
    /dev/socket/genyd \
    /dev/socket/baseband_genyd \
    /sys/qemu_trace \
    /sys/devices/virtual/misc/qemu_pipe \
    /sys/devices/virtual/misc/goldfish_pipe; do
    bind_hide_file_safe "$moddir" "$path"
  done

  for path in /su /sbin/su /cache/su /data/local/su /data/local/bin/su /data/local/xbin/su; do
    bind_hide_file_safe "$moddir" "$path"
  done
}

apply_all_props() {
  moddir="$1"
  apply_freecharge_core
  apply_universal_upi_hide
  load_selected_profile "$moddir"
}
