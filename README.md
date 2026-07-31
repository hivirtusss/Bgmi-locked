# Universal Root & Emulator Hide (KernelSU)

Universal KernelSU module — **sab apps** aur **sab emulators** ke liye root + emulator detection hide.

FreeRecharge-only module ke logic ko base banaya hai aur **system-wide universal** bana diya — koi single app filter nahi. Sab APK ko same spoofed Pixel 9 Pro XL environment dikhega.

## Supported apps (system-wide — sab pe apply)

Module kisi ek app ko target nahi karta. Boot pe **pure system** ke props/files hide hote hain, isliye yeh apps (aur baaki sab) pe kaam karta hai:

- FreeCharge
- BharatPe
- Paytm
- PhonePe
- Google Pay
- Yes Pay / YesPayNext
- LXME
- IND Money
- Amazon Pay, Mobikwik, CRED, Slice, Jupiter
- Koi bhi UPI / banking / wallet app

## Supported devices / emulators

- LDPlayer, BlueStacks, Nox, MEmu
- Android Studio AVD (x86 / x86_64 / arm64)
- Physical phone (KernelSU rooted)
- **Single device nahi** — kisi bhi emulator ya device pe flash karo

## Download / Build

Ready zip:

**`dist/UniversalRootHide-KernelSU-v2.0.0.zip`**

Rebuild:

```bash
chmod +x build.sh
./build.sh
```

## Install

1. Zip emulator/phone storage mein copy karo
2. **KernelSU Manager** → **Modules** → Install from storage
3. **Reboot**

## KernelSU app profile (recommended)

Module universal props set karta hai, par **max hide** ke liye har sensitive app mein:

1. KernelSU Manager → App → **App profile**
2. Enable **Unmount modules** + **Hide root / Non-root**
3. Reboot

## Kya hide hota hai (A to Z)

### FreeRecharge module logic (base)

Reference zip se liya gaya core:

```sh
resetprop ro.kernel.qemu 0
resetprop ro.boot.qemu 0
resetprop ro.hardware pixel
resetprop ro.product.model "Pixel 9 Pro XL"
resetprop ro.product.device pantah
resetprop ro.build.fingerprint "google/pantah/pantah:15/..."
resetprop ro.build.type user
resetprop ro.build.tags release-keys
# ... etc
```

### Extra universal hide

| Category | Examples |
|----------|----------|
| Emulator props | `ro.kernel.qemu`, `goldfish`, `ranchu`, `qemu-props` |
| Root props | `ro.debuggable=0`, `ro.secure=1`, `ro.adb.secure=1` |
| Boot integrity | `verifiedbootstate=green`, `flash.locked=1` |
| Native bridge | `ro.dalvik.vm.native.bridge=0` (x86 emulator hide) |
| Magisk traces | `ro.magisk.version` cleared |
| Files bind-hide | `/dev/qemu_pipe`, `/su`, `/system/xbin/su`, etc. |

### Pixel profile

**Pixel 9 Pro XL (pantah)** — Android 15 retail fingerprint

## Verify

```bash
getprop ro.product.model      # Pixel 9 Pro XL
getprop ro.kernel.qemu        # 0
getprop ro.debuggable         # 0
getprop ro.dalvik.vm.native.bridge  # 0
```

Module **Action** button se full status print hota hai.

## Agar koi app ab bhi crash kare

Kuch apps extra kernel-level hide maangti hain:

- KernelSU app profile: Unmount + Hide root
- **SUSFS** (patched kernel)
- **ZygiskNext + Shamiko**
- **meta-overlayfs** (system file overlay)

## Reference

Original FreeRecharge module sirf `post-fs-data.sh` + basic props tha. Yeh v2 module usi logic ko **universal + extended** banata hai — `system.prop`, `service.sh`, file hiding, aur zyada banking/UPI checks.

## Uninstall

KernelSU Manager → Modules → Remove → Reboot
