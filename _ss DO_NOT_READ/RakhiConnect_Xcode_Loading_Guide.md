
# RakhiConnect – Xcode Setup & Run Guide (V1, Local-Only, Cash + Ticketek)

This guide shows you how to load the **RakhiConnectApp** (iOS companion) and **RakhiConnectWatch** (watchOS app) into Xcode, wire up Apple Pay (local-only), enable WatchConnectivity, and run on real devices.

> **What you have:** a folder structure (from the zip) containing Swift source for two targets:
> - `RakhiConnectApp` (iOS app that presents Apple Pay)
> - `RakhiConnectWatch` (watchOS app that triggers gifts)
> - `Shared` module code

---

## 0) Prerequisites

- **macOS** with latest **Xcode** (15.x or newer recommended).
- **Apple Developer account** (paid membership for Apple Pay + device provisioning).
- **iPhone** (with Apple Pay set up and a supported card) and an **Apple Watch** paired to that iPhone.
- **Apple Pay Sandbox testers** (optional but recommended for dev).

---

## 1) Create an Xcode Workspace with iOS + watchOS Targets

You can either **A)** create a brand-new Xcode project and paste files, or **B)** add the files to an existing workspace. Option A is simplest for a clean setup.

### Option A — Create a new iOS app with a Watch app target

1. Open **Xcode** → **File ▸ New ▸ Project…**  
2. Choose **iOS ▸ App** → **Next**  
   - **Product Name:** `RakhiConnectApp`
   - **Team:** your Apple Developer team
   - **Organization Identifier:** e.g., `com.yourcompany`
   - **Bundle ID (auto):** `com.yourcompany.RakhiConnectApp`
   - **Interface:** SwiftUI
   - **Language:** Swift
   - **Include Tests:** optional
   - Click **Next** and choose a folder (e.g., your project root).
3. With the iOS app open, add a Watch target:  
   **File ▸ New ▸ Target… ▸ watchOS ▸ Watch App** → **Next**  
   - **Product Name:** `RakhiConnectWatch`
   - **Embed in Companion Application:** **checked**
   - **Include Notification Scene/Complication:** optional (you can add later)
   - **Language:** Swift / SwiftUI
   - **Finish**

> Xcode will create two targets under one workspace:
> - `RakhiConnectApp` (iOS)
> - `RakhiConnectWatch` (watchOS, embedded in the iOS app)

---

## 2) Bring the Provided Source Files into the Project

From the zip you downloaded: `RakhiConnect_V1_SwiftSkeleton_Ticketek.zip`

1. Unzip it and locate the folders:
   - `RakhiConnectApp/`  
   - `RakhiConnectWatch/`  
   - `Shared/`
2. In **Xcode**, right-click the **project root** in the Project Navigator → **Add Files to “RakhiConnectApp”…**
3. Select the **`Shared`** folder → enable **“Copy items if needed”** → **Add to targets:** check **both** iOS and watchOS targets if prompted → **Add**.
4. Repeat for **`RakhiConnectApp` folder** (add to iOS target only).
5. Repeat for **`RakhiConnectWatch` folder** (add to watchOS target only).
6. Your navigator should now resemble:
   ```
   RakhiConnect (workspace)
   ├─ RakhiConnectApp (iOS target)
   │  ├─ App/
   │  ├─ Payments/
   │  ├─ Connectivity/
   │  ├─ Networking/
   │  └─ Utilities/
   ├─ RakhiConnectWatch (watchOS target)
   │  ├─ Views/
   │  ├─ ViewModels/
   │  ├─ Connectivity/
   │  └─ Complications/
   └─ Shared (both targets)
      ├─ SharedModels.swift
      ├─ SharedFormatting.swift
      └─ Constants.swift
   ```

> **Tip:** If Xcode asks to replace generated template files (e.g., `ContentView.swift`), you can keep yours or remove the template ones to avoid duplicates.

---

## 3) Update Bundle Identifiers & Signing

1. Click the **project** in the navigator → **Targets** tab.
2. For **RakhiConnectApp**:
   - **Bundle Identifier:** `com.yourcompany.rakhiconnect` (or similar)
   - **Team:** select your team
   - **Signing:** enable **Automatically manage signing**
3. For **RakhiConnectWatch**:
   - Xcode creates a watch bundle ID like: `com.yourcompany.rakhiconnect.watchkitapp`  
   - Ensure **Team** is set and **Automatically manage signing** is enabled.

> If you see signing errors, clean (`Shift + Cmd + K`) and retry.

---

## 4) Enable Capabilities

### 4.1 iOS Target — Apple Pay + WatchConnectivity

1. Select **RakhiConnectApp** target → **Signing & Capabilities**.
2. Click **+ Capability** → add **Wallet** (Apple Pay).  
   - Under **Apple Pay**:
     - **Merchant IDs:** add `merchant.com.yourcompany.rakhiconnect` (see Step 5).
     - Ensure **Apple Pay** is active on your developer account.
3. Click **+ Capability** → add **App Groups** (optional, if you plan to share data later).
4. Click **+ Capability** → add **Background Modes** → (optional) tick **Background fetch** if needed.
5. Click **+ Capability** → add **Watch Connectivity**.

### 4.2 watchOS Target — WatchConnectivity

1. Select **RakhiConnectWatch** target → **Signing & Capabilities**.
2. Click **+ Capability** → add **Watch Connectivity**.

> V1 does **not** present Apple Pay on the Watch; the Watch **triggers** payments via WatchConnectivity. Apple Pay is presented on **iPhone**.

---

## 5) Create Apple Pay Merchant ID (Developer Portal)

1. Go to **developer.apple.com** → **Account** → **Certificates, Identifiers & Profiles**.
2. **Identifiers ▸ Merchant IDs ▸ +**  
   - Description: `RakhiConnect Merchant`
   - Identifier: `merchant.com.yourcompany.rakhiconnect`
   - **Continue** → **Register**.
3. Back in Xcode, under iOS target **Apple Pay capability**, click **+** next to Merchant IDs and select your new merchant ID.
4. Ensure your **iPhone** is **Apple Pay–capable** and **has a supported card**. For sandbox testing, configure **Apple Pay Sandbox testers** (Users and Access → Sandbox).

---

## 6) Configure Constants & API Endpoints

Open **`Shared/Constants.swift`** and update:

```swift
public enum Constants {
    public static let apiBaseURL = URL(string: "https://api.yourdomain.com")! // ← your backend
    public static let defaultCurrency = "AUD" // local-only V1
    public static let defaultAmountPresetsMinor: [Int64] = [500, 1000, 2500, 5000]
}
```

Also update **`RakhiConnectApp/Payments/ApplePayConfig.swift`**:

```swift
static let merchantIdentifier = "merchant.com.yourcompany.rakhiconnect" // ← your Merchant ID
```

> For Ticketek flows, your backend should expose:
> - `POST /payments/applepay/capture`
> - `POST /ticketek/voucher/create`

---

## 7) Verify WatchConnectivity Wiring

- iOS → `RakhiConnectApp/Connectivity/WatchSessionManager_iOS.swift`
- watchOS → `RakhiConnectWatch/Connectivity/WatchSessionManager_Watch.swift`

**Flow (V1):**
1. Watch sends **`gift_request`** message (amount, currency, kind: `cash|ticketek`).
2. iPhone receives message → presents **Apple Pay**.
3. On success, iPhone calls backend to **capture** the payment.
4. If `ticketek`, backend fulfills a **Ticketek voucher** (or returns a deep link) and iPhone acknowledges.
5. iPhone returns **`gift_result`** to Watch for UI feedback.

---

## 8) Schemes & Run Destinations

- In Xcode, select the **RakhiConnectApp** scheme.  
  - **Run destination:** your **iPhone** (connected via cable or Wi‑Fi).  
  - When you run the iOS app, Xcode will install the Watch app to the paired Apple Watch.
- Ensure **iPhone** and **Watch** are on compatible OS versions and are **paired**.

---

## 9) First Run (Happy Path)

1. **Build & Run** the **iOS app** on your iPhone.
2. Allow installation of the **Watch app** when prompted.
3. On the **Watch**:
   - Open **RakhiConnect** → tap **Load Sample** to load a sample rakhi.
   - Pick **Gift Type** (Cash or Ticketek), choose an **amount**, tap **Tap to Gift**.
4. On the **iPhone**:
   - An **Apple Pay** sheet appears (Cash or Ticketek charge is identical in V1).
   - Authorize the payment.
5. If Ticketek:
   - The iPhone triggers backend fulfillment (`/ticketek/voucher/create`).
   - On success, both sides get a **success** result; you can surface a voucher code/URL in your UI.

---

## 10) Testing Apple Pay (Sandbox)

- Set up **Apple Pay Sandbox testers** (App Store Connect → Users and Access → Sandbox).
- On device, sign out of iCloud in **Settings ▸ App Store** if needed for sandbox.
- Add **Sandbox cards** to Wallet (Apple docs).  
- Repeat the run steps; you should see sandbox transactions in your PSP dashboard (e.g., Stripe test mode).

---

## 11) Common Build/Run Issues & Fixes

- **“Apple Pay not available”**:  
  - Ensure your iPhone supports Apple Pay and has a supported card (or sandbox card).  
  - Ensure **Wallet** capability is enabled and **Merchant ID** is attached to the iOS target.  
  - Try a clean build (`Shift + Cmd + K`) and rebuild.

- **Signing errors**:  
  - Check team selection and bundle identifiers for **both** targets.  
  - Make sure “Automatically manage signing” is on.

- **Watch app not installing**:  
  - Confirm the Watch is **paired** and **unlocked**.  
  - Ensure the run destination is your iPhone, and the Watch app is marked as **Embed in Companion Application**.  
  - Reboot devices if necessary.

- **WCSession not reachable**:  
  - Open the iOS app on the phone once to activate the session manager.  
  - Ensure both apps are running in foreground when you first test.  
  - Check logs for `session.isReachable`.  

- **Backend calls fail**:  
  - Make sure `Constants.apiBaseURL` points to a reachable dev server (HTTPS).  
  - Inspect device logs (Xcode **Devices and Simulators** window) for network errors.

---

## 12) Going Further (Optional Polishing for V1)

- Replace the placeholder rakhi circle with an **animated** SpriteKit/Lottie view.
- Add a **receipt screen** showing amount, currency, Ticketek voucher code/URL.
- Add **rate limiting** and basic **fraud controls** in your backend.

---

## 13) Files to Touch (Checklist)

- `Shared/Constants.swift` → **apiBaseURL**, **defaultCurrency**  
- `RakhiConnectApp/Payments/ApplePayConfig.swift` → **merchantIdentifier**  
- Xcode **Signing & Capabilities** → add **Wallet (Apple Pay)** & **WatchConnectivity**  
- Developer Portal → **Merchant ID** and **Apple Pay** enabled  
- Backend endpoints: `/payments/applepay/capture`, `/ticketek/voucher/create`

---

## 14) What’s Different in Version 2 (for later)
- Apple Pay may remain on iPhone; add international payouts & FX.
- Additional watch complication designs; notification-driven rakhi updates.
- Corridor-based rails (e.g., UPI for India) and cross‑border compliance.

---

### You’re ready 🎉
If you want, I can also generate an **.xcworkspace** scaffolding so you can open and run immediately, with the folders already added. Just say the word.
