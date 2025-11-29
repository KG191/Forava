# App Store Connect Actions - Review 4 Fix

**Date:** November 28, 2025

Follow these steps in App Store Connect to resolve both rejection issues.

---

## Action 1: Remove Subscription Products (Guideline 2.1)

### Steps:

1. **Log in to App Store Connect**
   - Go to: https://appstoreconnect.apple.com

2. **Navigate to Forava App**
   - Apps → Forava

3. **Go to Monetization Section**
   - Click "Monetization" in left sidebar
   - Select "In-App Purchases"

4. **Remove Subscription Products**

   Find and remove these auto-renewable subscription products:

   | Product Name | Product ID | Action |
   |--------------|------------|--------|
   | Monthly Unlimited | `monthlySubscription` | Delete or set to "Developer Action Needed" |
   | Annual Unlimited | `annualSubscription` | Delete or set to "Developer Action Needed" |

5. **Verify Credit Products Remain**

   Ensure these consumable products are still active and "Ready to Submit":

   | Product Name | Product ID | Price |
   |--------------|------------|-------|
   | Single Regeneration | `regenerationCredit` | $1.99 |
   | Starter Pack | `credits10` | $9.99 |
   | Popular Pack | `credits25` | $19.99 |
   | Family Pack | `credits50` | $34.99 |
   | Festival Pack | `credits100` | $59.99 |

---

## Action 2: Add Terms of Use Link (Guideline 3.1.2)

### Option A: Add to App Description (Recommended)

1. **Navigate to App Information**
   - Apps → Forava → App Information

2. **Edit App Description**
   - Scroll to "Description" field
   - Add the following at the END of the description:

   ```

   ---
   Terms of Use: https://kg191.github.io/forava-legal/terms.html
   Privacy Policy: https://kg191.github.io/forava-legal/privacy.html
   ```

3. **Save Changes**

### Option B: Use Custom EULA Field

1. **Navigate to App Information**
   - Apps → Forava → App Information

2. **Find EULA Section**
   - Scroll to "License Agreement (EULA)" section

3. **Select Custom EULA**
   - Choose "Custom EULA" instead of "Standard Apple EULA"
   - Enter Terms URL or paste full terms text

---

## Action 3: Verify Privacy Policy URL

1. **Navigate to App Privacy**
   - Apps → Forava → App Privacy

2. **Check Privacy Policy URL**
   - Confirm field contains: `https://kg191.github.io/forava-legal/privacy.html`

3. **Check User Privacy Choices URL (Optional)**
   - This field is for GDPR privacy choices, NOT Terms of Use
   - If Terms URL is here, consider removing it
   - This field should link to privacy preferences/opt-out, if applicable

---

## Action 4: Verify Agreements

1. **Go to Business Section**
   - App Store Connect → Agreements, Tax, and Banking

2. **Verify Paid Apps Agreement**
   - Ensure "Paid Apps" agreement is ACTIVE (not expired)
   - This is required for IAP to function in sandbox

---

## Pre-Resubmission Checklist

Before resubmitting to App Review:

- [ ] Subscription products removed (Monthly Unlimited, Annual Unlimited)
- [ ] Credit pack products verified as "Ready to Submit"
- [ ] Terms of Use URL added to App Description
- [ ] Privacy Policy URL verified in App Privacy section
- [ ] Paid Apps Agreement is active
- [ ] Response message sent to Apple

---

## Testing After Changes

After making these changes, test in sandbox:

1. Create a sandbox tester account (if not already)
2. Sign out of App Store on device
3. Launch Forava app
4. Complete onboarding (select any culture)
5. Navigate to Settings → "Buy Regeneration Credits"
6. Verify all 5 credit packs appear
7. Test a purchase with sandbox account
