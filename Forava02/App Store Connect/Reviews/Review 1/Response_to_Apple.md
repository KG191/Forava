# Response to App Store Review Team
## Guideline 2.1 - Information Needed - PassKit Framework

**Date**: November 25, 2025
**Submission ID**: aaf66989-d30e-4926-84e6-e3c5393e2dff
**Version**: 1.0
**App**: Forava - Multi-Cultural AI Digital Gifting Platform

---

## Summary

Thank you for reviewing our app submission. We have resolved the PassKit framework issue identified in your review. The PassKit framework references have been completely removed from the app binary, as Forava does not implement Apple Pay functionality.

---

## Issue Identified by Apple

> "The app binary includes the PassKit framework for implementing Apple Pay, but we were unable to verify any integration of Apple Pay within the app."

---

## Root Cause

Our investigation revealed that the PassKit framework was inadvertently linked in the app binary due to **dead code** - unused source files from early development that were never integrated into the app's functionality:

1. **ApplePayConfig.swift** - Stub configuration file, never called
2. **APIClient.swift** - Stub payment capture file, never called
3. **SettingsView.swift** - Contained unnecessary `import PassKit` statement
4. **ForavaApp.entitlements** - Contained unused `com.apple.developer.in-app-payments` entitlement

These files were created during early development exploration but were never connected to any active code paths. The app's actual payment implementation uses **StoreKit 2** for subscriptions and in-app purchases, which is the appropriate technology for digital content and subscriptions.

---

## Actions Taken

We have completed the following remediation steps:

### 1. Code Cleanup
- ✅ Deleted `ApplePayConfig.swift` (unused file)
- ✅ Deleted `APIClient.swift` (unused file)
- ✅ Removed `import PassKit` statement from `SettingsView.swift`
- ✅ Removed all PassKit references from Xcode project file

### 2. Entitlements Update
- ✅ Removed `com.apple.developer.in-app-payments` entitlement from `ForavaApp.entitlements`
- ✅ Confirmed StoreKit 2 requires no entitlements for in-app purchases

### 3. Verification
- ✅ Cleaned Xcode derived data and rebuilt project
- ✅ Build successful with zero errors
- ✅ Verified PassKit framework NOT linked in app binary using `otool -L`
- ✅ Confirmed no `import PassKit` statements remain in codebase
- ✅ SwiftLint validation passed

---

## Forava's Payment Architecture

For clarity, here is how Forava handles payments:

### StoreKit 2 Integration (Active - Digital Goods)

**Purpose**: Subscriptions and consumable in-app purchases

**Products**:
- Monthly Unlimited Subscription: $7.99/month
- Annual Unlimited Subscription: $59.99/year
- Regeneration Credit Packs: $9.99 - $59.99

**Payment Methods Available to Users**:
Users can pay for these subscriptions and credits using any payment method configured in their Apple ID, including:
- Apple Pay (handled by iOS/App Store infrastructure)
- Credit/Debit cards
- Carrier billing
- Apple Account balance

**Implementation**: Modern StoreKit 2 with async/await, secure receipt validation, and Family Sharing support.

### Gratitude Tab - Voucher Referrals (External Links)

**Purpose**: Directory of retailers for physical gift purchases

**Implementation**: Simple URL opening (`UIApplication.shared.open()`) to external retailer websites

**Retailers**: David Jones, Myer, Westfield, Sephora, and 12 other retailers

**Payment Processing**: Occurs entirely on retailer websites, not within Forava app

---

## Why PassKit Was Not Needed

PassKit/Apple Pay is designed for:
- Merchant payments for physical goods/services
- Direct payment processing by the app developer
- Peer-to-peer money transfers
- Digital wallet passes

Forava's use case requires:
- **StoreKit 2**: For digital subscriptions and in-app content purchases (✅ correct implementation)
- **External links**: For physical gift voucher referrals (✅ correct implementation)

**Conclusion**: PassKit was never needed for Forava's functionality and has been completely removed.

---

## Binary Verification

We have verified that PassKit is no longer present in the app binary:

```bash
$ otool -L ForavaApp.app/ForavaApp | grep -i passkit
(no output - PassKit not linked)

$ grep -r "import PassKit" ForavaApp/
(no results - no PassKit imports remain)
```

---

## New Build Details

**Build Status**: ✅ Successfully built without PassKit
**Build Date**: November 25, 2025
**Version**: 1.0 (Build 2)
**Verification Method**: `otool -L` binary analysis
**Result**: PassKit framework NOT present in binary

---

## App Store Connect Review Notes (For New Submission)

**For Review Team Reference**:

Forava uses **StoreKit 2** (not PassKit/Apple Pay) for all in-app purchases:
- Subscription tiers: $7.99/month, $59.99/year
- Consumable credit packs: $9.99-$59.99
- Payment processed through Apple's App Store infrastructure
- No merchant payment processing implemented

The Gratitude tab provides external links to retailer websites for physical gift purchases. These purchases occur on retailer websites, not within the Forava app.

**PassKit Status**: Completely removed from app binary and source code.

---

## Testing Recommendations

To verify the PassKit issue has been resolved:

1. **Binary Analysis**: Confirm PassKit framework absent using App Store's automated analysis tools
2. **Functional Testing**:
   - Test subscription purchase flow (uses StoreKit 2) ✅
   - Test credit pack purchases (uses StoreKit 2) ✅
   - Test Gratitude tab voucher links (opens Safari to external sites) ✅
3. **Code Review**: No PassKit imports or references in source code ✅

---

## Conclusion

The PassKit framework has been completely removed from Forava. The app now builds successfully without PassKit, and binary analysis confirms the framework is no longer linked. Forava correctly uses StoreKit 2 for all digital subscriptions and in-app purchases, which is the appropriate technology for our use case.

We are confident this new build resolves the issue identified in your review and meets all App Store guidelines.

Thank you for your thorough review, and please let us know if you require any additional information.

---

## Contact Information

**Developer**: Kiran Gokal
**Support Email**: foravaapp@gmail.com
**Response Time**: <24 hours

---

**Resubmission Ready**: ✅ Yes
**Next Build Number**: 2
**Estimated Upload**: November 26, 2025
