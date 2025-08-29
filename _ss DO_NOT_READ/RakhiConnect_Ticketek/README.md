# RakhiConnect (V1 – Local) with Ticketek Digital Gift Option

- Watch: pick **Cash** or **Ticketek**, choose amount, send request.
- iPhone: Apple Pay sheet. If Ticketek, server fulfills voucher after charge (or deep link fallback).
- Backend endpoints (placeholders): `/payments/applepay/capture`, `/ticketek/voucher/create`.

## Setup
1. Replace `merchant.com.yourcompany.rakhiconnect` with your Merchant ID.
2. Set `Constants.apiBaseURL` to your backend.
3. Entitlements: Apple Pay (iOS), WatchConnectivity (iOS + watchOS).
4. Implement backend fulfillment for Ticketek.
