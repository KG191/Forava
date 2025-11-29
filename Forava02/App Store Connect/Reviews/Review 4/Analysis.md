# App Store Review 4 - Technical Analysis

**Date:** November 28, 2025
**Submission ID:** aaf66989-d30e-4926-84e6-e3c5393e2dff
**Version:** 1.0

---

## Issue 1: Guideline 2.1 - IAP Visibility

### Problem Statement
Apple cannot locate "Monthly Unlimited" and "Annual Unlimited" in-app purchases within the app.

### Root Cause Analysis

**Subscription Products in App Store Connect:**
- `monthlySubscription` → "Monthly Unlimited" ($7.99/month)
- `annualSubscription` → "Annual Unlimited" ($59.99/year)

**However, the app implements a credit-based model, NOT subscriptions:**

The app's current IAP implementation uses consumable credit packs:

| Product ID | Name | Price | Credits |
|------------|------|-------|---------|
| `credits10` | Starter Pack | $9.99 | 10 credits |
| `credits25` | Popular Pack | $19.99 | 25 credits |
| `credits50` | Family Pack | $34.99 | 50 credits |
| `credits100` | Festival Pack | $59.99 | 100 credits |
| `regenerationCredit` | Single Credit | $1.99 | 1 credit |

**Key Files:**
- `ForavaApp/Models/SubscriptionModels.swift` - Product definitions
- `ForavaApp/Services/RegenerationIAPManager.swift` - Purchase implementation
- `ForavaApp/Views/Paywall/PaywallView.swift` - Purchase UI

### Why Subscriptions Are Not Visible
1. PaywallView only displays credit pack products (not subscriptions)
2. RegenerationIAPManager.loadProducts() only fetches credit products
3. Subscription purchase flow is defined but NOT implemented in UI
4. ComprehensivePaymentService.purchaseSubscription() is a stub

### Resolution
**Remove subscription products from App Store Connect** since the app exclusively uses a credit-based purchase model.

---

## Issue 2: Guideline 3.1.2 - Missing EULA Link

### Problem Statement
App metadata missing functional link to Terms of Use (EULA).

### Root Cause Analysis

**Current Implementation:**
- Terms of Use IS implemented in the app:
  - Settings → "Terms of Service" button
  - Opens TermsOfServiceView (WebView)
  - URL: `https://kg191.github.io/forava-legal/terms.html`

- Privacy Policy IS implemented:
  - Settings → "Privacy Policy" button
  - URL: `https://kg191.github.io/forava-legal/privacy.html`

**The Problem:**
The Terms URL is currently in the **"User Privacy Choices URL"** field in App Store Connect, which is the **WRONG location**.

Apple requires Terms of Use in:
1. **App Description** text field, OR
2. **EULA field** in App Store Connect (App Information section)

### Where Apple Looks for EULA
| Field | Purpose | Current Status |
|-------|---------|----------------|
| Privacy Policy URL | Privacy policy link | ✅ Correct |
| User Privacy Choices URL | GDPR/privacy choices | ❌ Has Terms URL (wrong!) |
| App Description | App info + legal links | ❌ Missing Terms URL |
| EULA Field | Custom EULA text/link | ❌ Not configured |

### Resolution
1. Add Terms URL to **App Description** (at bottom)
2. AND/OR configure **EULA field** with custom Terms link
3. Remove Terms URL from "User Privacy Choices URL" (use only for GDPR)

---

## Summary of Required Actions

### App Store Connect Changes:

| Action | Location | Change |
|--------|----------|--------|
| Remove | In-App Purchases | Delete Monthly Unlimited & Annual Unlimited |
| Add | App Description | Add Terms of Use URL at bottom |
| Verify | Privacy Policy URL | Confirm correct URL is set |
| Fix | User Privacy Choices URL | Remove Terms URL if present |

### No Code Changes Required
The app already has functional Terms and Privacy links. This is purely a metadata configuration issue in App Store Connect.

---

## Technical References

**Terms of Use in App:**
- File: `ForavaApp/Views/SettingsView.swift` (lines 432-449)
- View: `TermsOfServiceView` (lines 589-607)
- URL: `https://kg191.github.io/forava-legal/terms.html`

**Privacy Policy in App:**
- File: `ForavaApp/Views/SettingsView.swift` (lines 413-430)
- View: `PrivacyPolicyView` (lines 569-587)
- URL: `https://kg191.github.io/forava-legal/privacy.html`

**Credit Pack Purchase Flow:**
- PaywallView.swift → ComprehensivePaymentService → RegenerationIAPManager → StoreKit 2
