# Response to Apple App Store Review Team
## Guideline 2.1 - Information Needed - IAP Location

---

**Submission ID:** aaf66989-d30e-4926-84e6-e3c5393e2dff
**Date:** November 27, 2025

---

Dear App Store Review Team,

Thank you for your feedback regarding the location of in-app purchases in Forava v1.0.

I have made the following changes to ensure all IAP products are **immediately visible and accessible** to reviewers without needing to use the app's free generation quota:

---

## ✅ THREE DIRECT PATHS TO ACCESS IAP PRODUCTS

### PATH 1: Settings → "Buy Regeneration Credits" (RECOMMENDED)

This is the **fastest and most direct** way to access all IAP products:

1. Launch the app
2. Complete age verification (enter any age 13+)
3. On the Welcome screen, tap the **Settings gear icon** (top right)
4. Select at least one culture and tap **"Done"**
5. Navigate to **Settings** (gear icon in navigation)
6. Scroll to the **"Credits & Balance"** section
7. Tap the prominent **orange button: "Buy Regeneration Credits"**

**Result:** All 4 credit pack IAP products are displayed immediately with pricing.

---

### PATH 2: Welcome Screen → "Purchase Credits Now"

Available on first launch without any app usage:

1. Launch the app
2. Complete age verification
3. On the Welcome screen, wait 1 second
4. Tap the button: **"Purchase Credits Now"** (bottom of screen)

**Result:** All 4 credit pack IAP products displayed immediately, bypassing the free tier entirely.

---

### PATH 3: Natural User Flow (After 3 Free Generations)

1. Complete onboarding
2. Generate 3 cultural gifts (FREE)
3. Paywall appears automatically showing all IAP products

---

## 📦 IAP PRODUCTS AVAILABLE

All products are **Credit Packs** (one-time purchases) visible through the paths above:

- **Starter Pack** (10 credits) - $4.99 - `com.forava.credits.10`
- **Family Pack** (25 credits) - $9.99 - `com.forava.credits.25`
- **Festival Pack** (50 credits) - $19.99 - `com.forava.credits.50`
- **Popular Pack** (100 credits) - $29.99 - `com.forava.credits.100`

All products are configured for the **Apple-provided sandbox environment** and are ready for testing.

---

## 📝 NOTE ON SUBSCRIPTIONS

Monthly and Annual subscription options are **intentionally hidden** in this build because the subscription purchase implementation is not yet complete (returns false on purchase attempt).

To avoid confusion during review, only the **fully functional credit pack purchases** are displayed. Subscriptions will be re-enabled in a future update after full implementation.

---

## 🔐 SANDBOX ENVIRONMENT CONFIGURATION

- ✅ All IAP products registered in App Store Connect
- ✅ Configured for Apple-provided sandbox testing
- ✅ Paid Apps Agreement: ACTIVE
- ✅ Tax Forms: COMPLETED
- ✅ Bank Account: VERIFIED

I have successfully tested all IAP purchases using a sandbox test account, and the purchase flow, receipt validation, and credit allocation work correctly.

---

## 📄 DETAILED DOCUMENTATION PROVIDED

I have prepared comprehensive documentation for your review team:

- **App_Review_Instructions.md** - Complete step-by-step guide for locating IAPs
- **Xcode_Scheme_Configuration_Guide.md** - API key configuration for TestFlight

These documents are available in the app's source code repository and can be provided upon request.

---

## 🚨 KNOWN ISSUE: Image Generation in TestFlight

I am aware that AI image generation may fail in TestFlight builds due to API key configuration. This is a **build configuration issue** that does not affect IAP functionality.

**Important:** Reviewers can fully test all IAP products, purchase flows, and receipt validation **without needing to generate images**. The IAP system is completely independent of the image generation feature.

I am addressing this issue by configuring API keys in Xcode Scheme environment variables for future builds.

---

## 🙏 REQUEST FOR REVIEW

Please use **PATH 1 (Settings → "Buy Regeneration Credits")** as the most direct route to access all IAP products for review.

All 4 credit pack products will be immediately visible with correct names, pricing, and descriptions. The purchase flow can be fully tested in the Apple-provided sandbox environment.

Thank you for your time and consideration. I look forward to your feedback.

---

**Best regards,**
Forava Development Team
foravaapp@gmail.com

---

**Change Summary:**
- Added "Buy Regeneration Credits" button to Settings (immediate IAP access)
- Added "Purchase Credits Now" button to Welcome screen (skip free trial)
- Updated PaywallView to show only credit packs (hide incomplete subscriptions)
- Build tested and verified: **BUILD SUCCEEDED** ✅

---

**Copy this message to App Store Connect:**
> Please navigate to **Settings → "Buy Regeneration Credits"** to access all 4 credit pack IAP products immediately. Alternatively, on the Welcome screen, tap **"Purchase Credits Now"** to access IAPs without using any app features. All products are configured for sandbox testing.
