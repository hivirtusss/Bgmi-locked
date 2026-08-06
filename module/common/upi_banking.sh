#!/system/bin/sh
# BharatPe / Freo / PhonePe / Paytm / all UPI — device secure + root hide props

apply_upi_banking_fix() {
  reset_ro ro.vendor.boot.verifiedbootstate green
  reset_ro ro.vendor.boot.vbmeta.device_state locked
  reset_ro ro.vendor.boot.flash.locked 1
  reset_ro ro.odm.build.type user
  reset_ro ro.odm.build.tags release-keys
  reset_ro ro.system.build.type user
  reset_ro ro.system.build.tags release-keys
  reset_ro ro.system_ext.build.type user
  reset_ro ro.system_ext.build.tags release-keys
  reset_ro ro.vendor.build.type user
  reset_ro ro.vendor.build.tags release-keys
  reset_ro ro.bootimage.build.type user
  reset_ro ro.bootimage.build.tags release-keys
  reset_ro ro.product.manufacturer Google
  reset_ro ro.product.brand google
  reset_ro ro.build.version.codename REL
  reset_ro ro.build.version.preview_sdk 0
  reset_ro ro.build.version.preview_sdk_fingerprint REL
  reset_ro ro.build.version.min_supported_target_sdk 28
  reset_ro ro.build.version.base_os ""
  reset_ro ro.build.ab_update true
  reset_ro ro.treble.enabled true
  reset_ro ro.vendor.perf.scroll_opt true
  reset_ro ro.com.android.datasaver.enable false
  reset_ro ro.com.google.clientidbase android-google
  reset_ro ro.com.google.clientidbase.ms android-google
  reset_ro ro.setupwizard.mode DISABLED
  reset_ro ro.setupwizard.enterprise_mode 0
  reset_ro persist.sys.timezone Asia/Kolkata
  reset_ro persist.sys.locale en-IN
  reset_ro persist.sys.usb.config mtp
  reset_ro sys.usb.config mtp
  reset_ro ro.config.low_ram false
  reset_ro ro.config.per_app_memcg false
  reset_ro ro.telephony.default_network 9
  reset_ro gsm.sim.state READY
  reset_ro gsm.operator.alpha "Jio 4G"
  reset_ro gsm.operator.numeric "405864"
  reset_ro gsm.sim.operator.alpha "Jio"
  reset_ro gsm.sim.operator.numeric "405864"
  reset_ro ro.kernel.qemu 0
  reset_ro ro.boot.qemu 0
  reset_ro ro.debuggable 0
  reset_ro ro.secure 1
  reset_ro ro.adb.secure 1
  reset_ro service.adb.root 0
  reset_ro ro.boot.verifiedbootstate green
  reset_ro ro.boot.flash.locked 1
  reset_ro ro.boot.vbmeta.device_state locked
  reset_ro ro.crypto.state encrypted
  reset_ro ro.dalvik.vm.native.bridge 0
  reset_ro persist.sys.nativebridge 0
  reset_ro ro.magisk.version ""
  reset_ro ro.magisk.versioncode 0

  delete_prop ro.boot.qemu.avd_name
  delete_prop ro.boot.qemu.settings.android.avd_name
  delete_prop ro.boot.qemu.virt_model
  delete_prop ro.kernel.su
  delete_prop init.svc.qemu-props
  delete_prop init.svc.goldfish-logcat
}
