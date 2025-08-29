# Forava — Xcode Loading & Run Guide (Local‑Only, Cash + Digital Gift)

This guide helps you load and run **Forava** (iOS + watchOS) in **Xcode**.

---

## 1. Prerequisites
- macOS (latest stable)
- Xcode 15+
- Apple Developer Program account
- iPhone with Apple Pay setup, and a paired Apple Watch

---

## 2. Download the Pre‑Wired Workspace
1. Download `Forava_PreWired_Workspace.zip` and unzip.
2. Contents:
   - `Forava.xcworkspace`
   - `ForavaApp` (iOS)
   - `ForavaWatch` (watchOS)
   - `Shared` (models/utilities)

---

## 3. Open & Configure
1. Open **Forava.xcworkspace** in Xcode.
2. Select a **Team** for both targets:
   - **ForavaApp** (iOS app)
   - **ForavaWatch** (watchOS app)
3. Update `Shared/Constants.swift` with your backend base URL.

---

## 4. Apple Pay Setup
- Capability is pre‑added. In `ForavaApp/ApplePayConfig.swift`, set:
```swift
static let merchantIdentifier = "merchant.com.yourcompany.forava"
```
Use a Merchant ID registered in your Apple Developer account.

---

## 5. WatchConnectivity
Already linked in both iOS and watchOS targets. No extra steps required.

---

## 6. Run
- Scheme: **ForavaApp** → run on your iPhone (paired Apple Watch installs the watch app).
- To test the watch UI separately, select **ForavaWatch** and run on your Watch.

---

## 7. Test Flows
**Cash Gift**
1. On the Watch, load a sample token.
2. Pick **Cash** + amount → Tap **Send**.
3. Complete Apple Pay on iPhone.

**Digital Gift**
1. On the Watch, choose **Digital Gift** + amount.
2. iPhone calls backend to issue a voucher (code/URL).
3. Confirmation appears on both devices.

---

## 8. Backend
Replace `Constants.apiBaseURL` with your server. Implement:
- `POST /payments/applepay/capture`
- `POST /digitalgift/voucher/create`

---

## 9. Troubleshooting
- Apple Pay missing → check Merchant ID and capabilities.
- Watch not reachable → ensure pairing, unlock devices.
- Voucher errors → verify backend logs and responses.

© 2025 Forava.
