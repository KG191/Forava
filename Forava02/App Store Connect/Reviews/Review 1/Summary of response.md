# Response to App Store Review Team
**Guideline 2.1 - PassKit Framework Issue**

**Submission ID**: aaf66989-d30e-4926-84e6-e3c5393e2dff
**App**: Forava v1.0
**Date**: November 25, 2025

---

## Issue Resolution Summary

Thank you for your review. We have **completely removed** the PassKit framework from our app binary. PassKit was inadvertently linked due to unused dead code from early development.

---

## Root Cause

Three unused source files from early development contained PassKit imports but were never integrated into any active code paths:
- ApplePayConfig.swift (unused stub file)
- APIClient.swift (unused stub file)
- SettingsView.swift (unnecessary import statement)
- ForavaApp.entitlements (unused Apple Pay entitlement)

---

## Actions Taken

**Code Cleanup:**
✅ Deleted ApplePayConfig.swift
✅ Deleted APIClient.swift
✅ Removed `import PassKit` from SettingsView.swift
✅ Removed PassKit references from Xcode project

**Entitlements Update:**
✅ Removed `com.apple.developer.in-app-payments` entitlement
(StoreKit 2 requires no entitlements)

**Verification:**
✅ Clean rebuild successful (zero errors)
✅ Binary analysis confirms PassKit NOT linked (otool -L)
✅ No PassKit imports remain in codebase
✅ SwiftLint validation passed

---

## Forava's Actual Payment Implementation

**StoreKit 2 Integration** (Digital Subscriptions & IAP):
- Monthly subscription: $7.99
- Annual subscription: $59.99
- Credit packs: $9.99-$59.99
- Payment processed through Apple's App Store infrastructure
- Users can pay with Apple Pay, cards, carrier billing, or Apple Account balance (all handled by iOS/App Store, not PassKit)

**Gratitude Tab** (External Retailer Links):
- Simple URL opening to external retailer websites
- Payment occurs on retailer sites, not within Forava
- No merchant payment processing in app

---

## Why PassKit Was Not Needed

PassKit/Apple Pay is for:
- Merchant payments for physical goods
- Direct payment processing by app

Forava uses:
- **StoreKit 2** for digital subscriptions (correct approach ✅)
- **External links** for physical gift referrals (correct approach ✅)

---

## New Build Ready

**Build Status**: Successfully built without PassKit
**Version**: 1.0 (Build 2)
**Verification**: Binary analysis confirms PassKit framework absent
**Ready for Resubmission**: Yes

---

## Testing Verification

To confirm resolution:
1. Binary analysis shows PassKit framework absent ✅
2. Subscription purchases work via StoreKit 2 ✅
3. Credit pack purchases work via StoreKit 2 ✅
4. Gratitude tab external links work ✅

---

## Conclusion

PassKit has been completely removed from Forava. The app correctly uses StoreKit 2 for all digital purchases, which is the appropriate technology for subscription-based apps with digital content.

We are confident this resolves the issue and meets all App Store guidelines.

**Contact**: foravaapp@gmail.com | Response time: <24 hours

---

**Character Count**: 2,847 characters
