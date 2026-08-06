#!/system/bin/sh
# Universal banking / UPI / wallet — normal Pixel phone build metadata sync

apply_banking_extras() {
  reset_ro ro.com.google.clientidbase android-google
  reset_ro ro.com.google.clientidbase.ms android-google
  reset_ro ro.url.legal http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html
  reset_ro ro.sf.lcd_density 420
  reset_ro ro.opengles.version 196610
  reset_ro ro.carrier unknown
  reset_ro ro.boot.serialno unknown
  reset_ro ro.serialno unknown
  reset_ro persist.sys.dalvik.vm.lib.2 libart.so
  reset_ro ro.product.first_api_level 32
  reset_ro ro.product.vndk.version "${VF_SDK:-34}"
  reset_ro ro.board.first_api_level 32
  reset_ro ro.build.version.release "${VF_ANDROID:-14}"
  reset_ro ro.build.version.release_or_codename "${VF_ANDROID:-14}"
  reset_ro ro.build.version.security_patch "${VF_PATCH:-2024-08-05}"
  reset_ro ro.build.id "${VF_BUILD_ID:-AP2A.240805.005}"
  reset_ro ro.build.display.id "${VF_BUILD_ID:-AP2A.240805.005}"
  reset_ro ro.build.version.incremental "${VF_INCREMENTAL:-12345678}"
  reset_ro ro.build.version.sdk "${VF_SDK:-34}"
  reset_ro ro.build.description "${VF_CODENAME:-bluejay}-user ${VF_ANDROID:-14} ${VF_BUILD_ID:-AP2A.240805.005} ${VF_INCREMENTAL:-12345678} release-keys"
  reset_ro ro.build.date.utc 1722816000
  reset_ro ro.build.date "Sun Aug  4 12:00:00 UTC 2024"
  reset_ro ro.product.locale en-IN
  reset_ro persist.sys.locale en-IN
  reset_ro persist.sys.timezone Asia/Kolkata
  reset_ro persist.sys.usb.config mtp
  reset_ro sys.usb.config mtp
  reset_ro sys.usb.state mtp
  reset_ro ro.config.low_ram false
  reset_ro ro.config.nfc_on true
  reset_ro ro.telephony.default_network 9
  reset_ro ro.soc.manufacturer Google
  reset_ro ro.soc.model "${VF_PLATFORM:-gs101}"
  reset_ro ro.zygote zygote64_32
  reset_ro ro.control_privapp_permissions enforce
  reset_ro ro.setupwizard.rotation_locked true
  reset_ro ro.frp.pst /dev/block/by-name/frp

  for part in vendor system odm system_ext bootimage; do
    reset_ro "ro.${part}.build.fingerprint" "${VF_FINGERPRINT}"
    reset_ro "ro.${part}.build.type" user
    reset_ro "ro.${part}.build.tags" release-keys
    reset_ro "ro.${part}.build.id" "${VF_BUILD_ID:-AP2A.240805.005}"
    reset_ro "ro.${part}.build.version.release" "${VF_ANDROID:-14}"
    reset_ro "ro.${part}.build.security_patch" "${VF_PATCH:-2024-08-05}"
    reset_ro "ro.${part}.build.date.utc" 1722816000
  done

  for hw in egl vulkan gralloc keystore gatekeeper fingerprint sensors camera power wifi gps vibrator light thermal health; do
    case "$hw" in
      egl|vulkan|gralloc) reset_ro "ro.hardware.$hw" mali ;;
      keystore|gatekeeper) reset_ro "ro.hardware.$hw" gatekeeper ;;
      fingerprint) reset_ro "ro.hardware.$hw" goodix ;;
      wifi|gps) reset_ro "ro.hardware.$hw" qcom ;;
      *) reset_ro "ro.hardware.$hw" "${VF_CODENAME:-bluejay}" ;;
    esac
  done
}
