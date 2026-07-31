# Universal Root & Emulator Hide v3 (KernelSU)

**FreeRecharge zip ka logic** + **sab UPI apps** + **6 Pixel device profiles** — ek hi zip, sab emulators/devices.

## Download

`dist/UniversalRootHide-KernelSU-v3.0.0.zip`

```bash
./build.sh
```

## Kya karta hai

1. **FreeRecharge module logic** (exact `resetprop` chain) — ab sirf FreeCharge nahi, **sare apps** pe
2. **Universal UPI/banking root hide** — debuggable, secure, native bridge, boot state, magisk traces
3. **Emulator + su file hide** — qemu_pipe, goldfish, /su paths
4. **Multi Pixel profile** — device choose karo

## Supported Pixel profiles

| profile.conf value | Device |
|--------------------|--------|
| `pixel7` | Pixel 7 |
| `pixel7pro` | Pixel 7 Pro |
| `pixel8pro` | Pixel 8 Pro |
| `pixel9` | Pixel 9 |
| `pixel9a` | Pixel 9a |
| `pixel9proxl` | Pixel 9 Pro XL (**default — FreeCharge wala pantah**) |

## Profile change kaise kare

1. Flash module + reboot
2. File edit karo: `/data/adb/modules/universal_root_hide/profile.conf`
3. Example: `profile=pixel7pro`
4. Reboot

Ya KernelSU Manager → Module → **Action** se current profile dekho.

## Supported UPI / wallet apps (system-wide)

Sab pe apply — koi app filter nahi:

FreeCharge, BharatPe, Paytm, PhonePe, Google Pay, Amazon Pay, Mobikwik, CRED, Slice, Jupiter, YesPay / YesPayNext, LXME, IND Money, aur **koi bhi UPI app**.

## Install

1. KernelSU Manager → Modules → Install `UniversalRootHide-KernelSU-v3.0.0.zip`
2. Reboot
3. (Optional) `profile.conf` edit karke device badlo
4. Har sensitive app mein KernelSU → **Unmount modules** + **Hide root** ON

## FreeRecharge reference logic (built-in)

```sh
resetprop ro.kernel.qemu 0
resetprop ro.boot.qemu 0
resetprop ro.hardware pixel
resetprop ro.product.model "Pixel 9 Pro XL"   # profile ke hisaab se badlega
resetprop ro.build.type user
resetprop ro.build.tags release-keys
# + universal UPI root hide
```

## Verify

```bash
getprop ro.product.model
getprop ro.kernel.qemu    # 0
getprop ro.debuggable     # 0
```

## Note

Hard Play Integrity / kernel-level checks ke liye extra: SUSFS, ZygiskNext + Shamiko.
