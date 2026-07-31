# Emulator Root & Detection Fix (KernelSU Module)

KernelSU flashable module for **Android emulators** (LDPlayer, BlueStacks, Android Studio AVD, etc.) where apps crash on launch due to **root** or **emulator detection**.

## Download

After building, the zip is at:

`dist/EmulatorRootFix-KernelSU-v1.0.0.zip`

Build locally:

```bash
chmod +x build.sh
./build.sh
```

## Install

1. Copy the zip to your emulator/device storage.
2. Open **KernelSU Manager** → **Modules** → **Install from storage**.
3. Select `EmulatorRootFix-KernelSU-v1.0.0.zip`.
4. **Reboot** the emulator.

## Required: KernelSU app profile (important)

This module alone is not enough for all apps. For each app that crashes:

1. KernelSU Manager → **Superuser** / **Apps**
2. Open the app → **App profile**
3. Enable:
   - **Unmount modules** (or **Exclude modules**)
   - **Non-root / Hide root** for that app (wording varies by KernelSU version)
4. Reboot again

Without this, KernelSU may still expose root to the app even with props spoofed.

## What this module does

- Spoofs common **Pixel 7 Pro** retail props via `system.prop` + early `resetprop`
- Clears/hides **qemu / goldfish / ranchu** style indicators
- Sets **user / release-keys / secure** flags apps often check
- Bind-mounts empty stubs over common emulator files:
  - `/dev/qemu_pipe`
  - `/dev/goldfish_pipe`
  - `/dev/socket/qemud`
  - `/sys/qemu_trace`
- Re-applies props on late boot via `service.sh`

## If apps still crash

Some apps (banking, BGMI-level anti-cheat, Play Integrity) need more layers:

| Layer | Purpose |
|-------|---------|
| **KernelSU app hide** | Hide root from target app |
| **meta-overlayfs** | Systemless `/system` changes (KernelSU) |
| **SUSFS + patched kernel** | Kernel-level root hiding |
| **ZygiskNext + Shamiko** | Zygisk hide (if your KSU build supports it) |
| **LSPosed hooks** | Runtime `SystemProperties` / file checks |

This module is the **first baseline fix** for emulators, not a guaranteed bypass for every app.

## Verify

After reboot, in adb shell or terminal:

```bash
getprop ro.kernel.qemu      # should be 0
getprop ro.product.model    # should be Pixel 7 Pro
getprop ro.debuggable       # should be 0
```

In KernelSU Manager, tap the module **Action** button to print status.

## Uninstall

KernelSU Manager → Modules → Remove → Reboot.

## Disclaimer

Use only on devices/emulators you own. Bypassing app security may violate app terms of service. This project is for education and personal testing.
