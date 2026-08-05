# How to Approve Users (@Hivirtus Admin)

## User side (get license)

1. Open Telegram → message **@userinfobot** → copy your **numeric ID**
2. Send to **@Hivirtus**:
   ```
   Virtus Fix License Request
   TG ID: 123456789
   Username: @yourname
   ```
3. Wait for OTP code from admin
4. On phone edit file:
   ```
   /data/adb/modules/virtus_fix_emulator_hide/license.conf
   ```
   ```
   tg_id=123456789
   otp=482910
   username=@yourname
   ```
5. Reboot OR open module **WebUI** → Verify
6. Tap **Action** button to run fix

## Admin side (YOU approve)

### Method A — Permanent approve (no OTP each time)

Edit `licenses/approved.json` in GitHub repo:

```json
{
  "tg_id": "987654321",
  "username": "@realuser",
  "status": "approved",
  "otp": "",
  "note": "Paid user"
}
```

Push to branch → user sets `tg_id` in license.conf → reboot.

### Method B — OTP one-time code

1. Generate 6 digit OTP (example: `482910`)
2. Add to approved.json:

```json
{
  "tg_id": "987654321",
  "username": "@realuser",
  "status": "pending",
  "otp": "482910"
}
```

3. Send OTP to user on Telegram
4. User enters in license.conf → verifies

### Generate OTP (terminal)

```bash
./tools/generate_otp.sh
```

## Remove / ban user

Delete their entry from `approved.json` and push.

User cache expires in 7 days or delete:
```
/data/adb/modules/virtus_fix_emulator_hide/state/license_ok
```

## Your own device (admin test)

Add your TG ID with `"status": "approved"` in approved.json.
