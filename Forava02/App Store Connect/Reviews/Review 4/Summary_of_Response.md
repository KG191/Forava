# App Store Review 4 - Summary of Response

**Date:** November 28, 2025
**Submission ID:** aaf66989-d30e-4926-84e6-e3c5393e2dff
**Version:** 1.0
**Response Character Count:** 2,418 (under 4,000 limit)

---

## Issues & Resolutions

### Issue 1: Guideline 2.1 - IAP Visibility

| Aspect | Details |
|--------|---------|
| **Apple's Concern** | Cannot locate "Monthly Unlimited" and "Annual Unlimited" subscriptions |
| **Root Cause** | Subscription products exist in App Store Connect but are NOT implemented in the app |
| **Business Model** | Credit-based purchases (not subscriptions) |
| **Resolution** | Remove subscription products from App Store Connect |

**Credit Pack Products Available:**

| Product | Price | Credits | Status |
|---------|-------|---------|--------|
| Single Regeneration | $1.99 | 1 | Active |
| Starter Pack | $9.99 | 10 | Active |
| Popular Pack | $19.99 | 25 | Active |
| Family Pack | $34.99 | 50 | Active |
| Festival Pack | $59.99 | 100 | Active |

**Testing Paths for Apple Reviewer:**
1. Settings → "Buy Regeneration Credits"
2. Use 3 free generations → Paywall appears
3. Welcome screen → "Purchase Credits Now"

---

### Issue 2: Guideline 3.1.2 - Missing EULA

| Aspect | Details |
|--------|---------|
| **Apple's Concern** | Missing Terms of Use (EULA) link in metadata |
| **Root Cause** | Terms URL was in wrong field ("User Privacy Choices URL") |
| **Resolution** | Add Terms URL to App Description |

**Legal URLs:**
- **Terms of Use:** https://kg191.github.io/forava-legal/terms.html
- **Privacy Policy:** https://kg191.github.io/forava-legal/privacy.html

**In-App Access:**
- Settings → "Terms of Service" button
- Settings → "Privacy Policy" button

---

## App Store Connect Actions Required

### Action Checklist:

- [ ] **Remove Subscription Products**
  - Delete "Monthly Unlimited" (monthlySubscription)
  - Delete "Annual Unlimited" (annualSubscription)

- [ ] **Add Terms URL to App Description**
  - Add at bottom of description:
    ```
    Terms of Use: https://kg191.github.io/forava-legal/terms.html
    Privacy Policy: https://kg191.github.io/forava-legal/privacy.html
    ```

- [ ] **Verify Privacy Policy URL**
  - Confirm App Privacy section has correct URL

- [ ] **Verify Agreements**
  - Confirm Paid Apps Agreement is active

- [ ] **Send Response to Apple**
  - Copy text from `App_Store_Connect_Response.txt`
  - Paste in App Store Connect message thread

---

## Technical Notes

### No Code Changes Required
This rejection is purely a metadata/configuration issue. The app already has:
- ✅ Functional credit pack purchases (StoreKit 2)
- ✅ Working Terms of Service view (WebView)
- ✅ Working Privacy Policy view (WebView)
- ✅ PaywallView with all credit packs displayed

### Key Files (Reference Only)
| File | Purpose |
|------|---------|
| `SubscriptionModels.swift` | Product definitions |
| `RegenerationIAPManager.swift` | IAP implementation |
| `PaywallView.swift` | Purchase UI |
| `SettingsView.swift` | Legal links (lines 413-449) |

---

## Timeline

| Date | Event |
|------|-------|
| Nov 28, 2025 | Review 4 rejection received |
| Nov 28, 2025 | Analysis completed |
| Nov 28, 2025 | Response prepared |
| Pending | App Store Connect changes made |
| Pending | Response sent to Apple |
| Pending | Resubmission for review |

---

## Files in This Folder

| File | Purpose |
|------|---------|
| `Apple_Rejection_Notes.txt` | Original rejection text from Apple |
| `Analysis.md` | Technical analysis of both issues |
| `App_Store_Connect_Actions.md` | Step-by-step actions guide |
| `App_Store_Connect_Response.txt` | Plain text response for Apple (copy-paste ready) |
| `Summary_of_Response.md` | This summary document |
