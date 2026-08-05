#!/usr/bin/env bash
# Generate 6-digit OTP for Virtus license approval
OTP=$(shuf -i 100000-999999 -n 1)
echo "New OTP: $OTP"
echo ""
echo "Add to licenses/approved.json:"
echo "{"
echo "  \"tg_id\": \"USER_TG_ID\","
echo "  \"username\": \"@user\","
echo "  \"status\": \"pending\","
echo "  \"otp\": \"$OTP\""
echo "}"
