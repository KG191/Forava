# DRAFT FORAVA REVENUE MODEL

## Objective

Enable the following user journey entirely within Apple's platform rules:
1. **Sender shares one Messages bubble containing:**
   • A Rakhi image (for recipient to set as Photos Watch Face).
   • A tappable Universal Link that opens a watchOS app to present Apple Pay.
2. **Recipient on Apple Watch:**
   • Taps the link → opens the watch app → Apple Pay sheet appears for a quick gift.
   • Opens the image → long-press / ⋯ → Create Watch Face → Photos Watch Face.

This preserves Apple's sandbox (no programmatic face setting) while achieving the desired UX.

⸻

## Workflow

**Sender (iPhone):**
1. Open the Forava iOS helper app.
2. Pick the Rakhi image.
3. Enter amount (e.g., AUD 5.00) and optional description.
4. Tap Send in Messages → prefilled text:

```
🎊 I've created a beautiful Rakhi for you! Made with love using Forava ❤️.
Tap to send gift: https://your.domain/pay?amount=5&desc=Thanks
```

**Recipient (Apple Watch):**
1. Tap the link → watch app deep-links into Apple Pay and presents the sheet.
2. Tap the image (in Messages), open it full-screen → long-press / ⋯ → Create Watch Face (Photos face).

**Behind the scenes:**
• Universal Link is routed by Associated Domains.
• The watch app calls PassKit (PKPaymentAuthorizationController) to present Apple Pay.

⸻

## Execution Plan

### 1. Project setup
• Create iOS + watchOS SwiftUI targets.
• Add shared config (shared/Constants.swift).

### 2. Associated Domains
• Add `applinks:your.domain` to iOS and watchOS entitlements.
• Host `/.well-known/apple-app-site-association` with the app IDs and `/pay/*` path.

### 3. Apple Pay on watchOS
• Create Merchant ID in Apple Developer portal.
• Enable Apple Pay capability in WatchKit Extension; set merchant ID entitlement.
• Implement ApplePayManager with PKPaymentAuthorizationController.

### 4. Deep Links
• Parse amount and desc query items (defaults provided).
• Call presentApplePay on app open via `.onOpenURL` or a visible tap.

### 5. iOS Sender UI
• PHPickerViewController to pick the image.
• MFMessageComposeViewController wrapper to attach image + prefilled text.

### 6. Assets
• Add watchPoster to both targets (sized appropriately for watch screens).

### 7. Testing
• Verify Universal Links on device (tap link in Messages).
• Verify Apple Pay with Sandbox test cards on Apple Watch.

⸻

## Expected Outputs

**Messages bubble that contains:**
1. Rakhi image (suitable for Photos Watch Face).
2. Tappable Universal Link (blue text) that opens the watch app and shows Apple Pay.

**watchOS app behavior:**
• On Universal Link open → immediately present Apple Pay with configured amount/description.
• Manual tap on the poster view also triggers Apple Pay.
• No programmatic watch face changes (by Apple policy). User can add the image as a Photos Watch Face via the system UI.

⸻

## Revenue Model Integration

This architecture enables multiple revenue streams:

### 1. Transaction Fees
- Small percentage (1-3%) on gift payments processed through Apple Pay
- Leverages Apple's secure payment infrastructure

### 2. Premium Features
- Advanced Rakhi customization options
- Cultural blessing messages
- Animation effects for watch faces

### 3. Cultural Occasions Expansion
- Diwali, Holi, Eid, Christmas gift templates
- Seasonal content subscriptions
- Cultural calendar integration

### 4. B2B Partnerships
- Corporate gifting solutions
- Cultural organization partnerships
- Festival marketplace integrations

### 5. AI Generation Credits
- Freemium model: 3 free Rakhi generations
- Additional generations: $1-2 each
- Subscription tiers for unlimited generation

This model respects Apple's ecosystem while creating sustainable revenue through cultural technology innovation.