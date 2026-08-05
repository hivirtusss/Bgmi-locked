# Virtus Fix & Emulator Hide — Licensed

**Developed By @Hivirtus**

## Download

`dist/VirtusFix-EmulatorHide-KernelSU.zip`

## License flow

| Step | User | Admin (@Hivirtus) |
|------|------|-------------------|
| 1 | Get TG ID from @userinfobot | — |
| 2 | Message @Hivirtus | Receive request |
| 3 | Get OTP | Add user to `licenses/approved.json` |
| 4 | WebUI → enter ID + OTP | Push to GitHub |
| 5 | Reboot → Action 🎯 | — |

## User verify

1. KernelSU → Virtus Fix → **WebUI**
2. Enter Telegram ID + OTP
3. **Save & Verify**
4. Reboot → tap **Action**

Or edit manually:
```
/data/adb/modules/virtus_fix_emulator_hide/license.conf
```

## Admin approve (YOU)

See **`licenses/ADMIN.md`** — full guide.

Quick: edit `licenses/approved.json`:

```json
{
  "tg_id": "USER_ID",
  "username": "@name",
  "status": "approved",
  "otp": "482910"
}
```

Push to GitHub → user verifies.

Generate OTP:
```bash
chmod +x tools/generate_otp.sh
./tools/generate_otp.sh
```

## Without license

- Module shows **❌ Detection Fail**
- Root/emulator hide **won't apply**
- Action button asks for license

## Build

```bash
./build.sh
```
