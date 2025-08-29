# RakhiConnect — Xcode Loading & Run Guide (Local‑Only, Cash + Digital Gift)

This guide helps you load and run the **RakhiConnect** project (iOS + watchOS) in **Xcode**.  
Version: **Local‑only gifting** with **Cash** and **Digital Gift** flows.

---

## 1. Prerequisites
- **macOS** (latest stable).
- **Xcode 15+** installed from the Mac App Store.
- An **Apple Developer Program** account (needed for Apple Pay & watchOS deployment).
- An **iPhone** (with Apple Pay set up) and an **Apple Watch** paired to the iPhone.

---

## 2. Download the Pre‑Wired Workspace
1. Download the file: `RakhiConnect_PreWired_Workspace.zip`.
2. Unzip it to a convenient location.
3. The folder contains:
   - `RakhiConnect.xcworkspace` — open this in Xcode.
   - `RakhiConnectApp` — iOS app target.
   - `RakhiConnectWatch` — watchOS app target.
   - `Shared` — shared Swift models, constants, formatting.

---

## 3. Open in Xcode
1. Double‑click `RakhiConnect.xcworkspace`.
2. In Xcode, ensure you **select a Team** for both the iOS and watchOS targets:
   - `RakhiConnectApp` (iOS app)
   - `RakhiConnectWatch` (watchOS app)

---

## 4. Configure Apple Pay
1. Go to **Signing & Capabilities** for the **iOS target**.
2. Ensure **Apple Pay** is added as a capability.
3. Replace the placeholder merchant ID in `ApplePayConfig.swift`:
   ```swift
   static let merchantIdentifier = "merchant.com.yourcompany.rakhiconnect"
   ```
4. Use your registered **Merchant ID** from the Apple Developer portal.

---

## 5. Configure WatchConnectivity
The **WatchConnectivity** framework is already added.  
Ensure that:
- The **watch app target** has `WatchConnectivity.framework` linked.
- The **iOS target** also links `WatchConnectivity.framework`.

---

## 6. Running the App
1. In Xcode’s toolbar, select the **Scheme** dropdown.
2. Choose **RakhiConnectApp** > **My iPhone** as the run destination.
3. Pair your **watch app** via Xcode:
   - In the **RakhiConnectWatch** scheme, choose **My Apple Watch**.
4. **Run** the iOS app — Xcode will install the watch app automatically.

---

## 7. Testing the Flows
### Cash Gift
1. On the Apple Watch app, load a sample rakhi.
2. Choose **Cash** and a preset amount.
3. Tap **Tap to Gift**.
4. The iOS app will present Apple Pay — complete the payment.

### Digital Gift
1. On the Apple Watch app, load a sample rakhi.
2. Choose **Digital Gift**.
3. Select an amount.
4. The iOS app will call the backend to create a voucher.

---

## 8. Backend Integration Notes
- `APIClient.swift` contains placeholder endpoints:
  - `/payments/applepay/capture` — for Apple Pay captures.
  - `/digitalgift/voucher/create` — for voucher issuance.
- Replace `Constants.apiBaseURL` with your server’s base URL.

---

## 9. Next Steps
- Add animations for the rakhi in the watch app.
- Integrate a **voucher provider** for Digital Gifts.
- Add UI for ceremonial receipts.

---

## 10. Troubleshooting
- **Apple Pay button not appearing:** Check merchant ID and capabilities.
- **Watch not syncing:** Ensure the watch is paired and unlocked.
- **Digital Gift errors:** Check backend endpoint logs.

---

© 2025 RakhiConnect. All rights reserved.
