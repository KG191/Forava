# App Store Review Instructions - Forava v1.0
## Submission ID: aaf66989-d30e-4926-84e6-e3c5393e2dff
## Review Date: November 26, 2025

---

## 🔍 HOW TO LOCATE IN-APP PURCHASES

Apple reviewers can access all in-app purchases through **THREE different paths** without needing to use the app's free generations.

---

## ✅ PATH 1: Direct Access via Settings (RECOMMENDED FOR REVIEWERS)

This is the **fastest and most direct way** to access all IAP products for review.

### Steps:
1. Launch the Forava app
2. Complete the age verification (enter any age 13+)
3. On the Welcome screen, tap the **Settings gear icon** (top right)
4. Select at least one culture from the list (required to proceed)
5. Tap **"Done"** to return to the main app
6. Navigate to **Settings** (gear icon in bottom navigation or ContentView)
7. Scroll to the **"Credits & Balance"** section
8. Tap the prominent orange button: **"Buy Regeneration Credits"**

### Result:
- All 4 credit pack IAP products will be displayed immediately
- Products are: Starter Pack (10 credits), Family Pack (25 credits), Festival Pack (50 credits), Popular Pack (100 credits)

---

## ✅ PATH 2: Welcome Screen Direct Purchase

Available on first launch without any app usage.

### Steps:
1. Launch the Forava app
2. Complete the age verification (enter any age 13+)
3. On the Welcome screen, wait 1 second for the prompt to fade in
4. At the bottom of the screen, tap the button: **"Purchase Credits Now"**

### Result:
- Bypasses the 3 free generations entirely
- Shows all 4 credit pack IAP products immediately
- Allows reviewers to purchase before using any app features

---

## ✅ PATH 3: Natural Flow (After Free Generations)

This is the standard user experience flow.

### Steps:
1. Complete onboarding and age verification
2. Select a culture and contact
3. Generate 3 cultural gifts (these are FREE)
4. After the 3rd generation, the paywall automatically appears

### Result:
- Shows all 4 credit pack IAP products
- This demonstrates the free tier + paid conversion flow

---

## 📦 IN-APP PURCHASE PRODUCTS AVAILABLE

All products are **Credit Packs** (one-time purchases):

| Product ID | Display Name | Credits | Price | Description |
|-----------|--------------|---------|-------|-------------|
| `com.forava.credits.10` | Starter Pack | 10 | $4.99 | Perfect for trying the regeneration feature |
| `com.forava.credits.25` | Family Pack | 25 | $9.99 | Great value for families |
| `com.forava.credits.50` | Festival Pack | 50 | $19.99 | Ideal for festival seasons |
| `com.forava.credits.100` | Popular Pack | 100 | $29.99 | **Most popular** - Best value per credit |

### Note on Subscriptions:
- Monthly and Annual subscriptions are **intentionally hidden** in this build
- Subscription implementation is not complete (returns false on purchase)
- Focus is on credit pack purchases for this review
- Subscriptions will be re-enabled in a future update after full implementation

---

## 🎯 WHAT CREDITS ARE USED FOR

### Free Tier:
- Users receive **3 free first-time generations** (lifetime)
- After 3 free generations, users must purchase credits

### Regeneration Feature:
- **1 credit = 1 regeneration** of an existing gift
- Allows users to try different styles, colors, or messages
- First generation is always free; regenerations cost credits

---

## 🏪 SANDBOX TESTING CONFIGURATION

### Apple-Provided Sandbox Environment:
- All IAP products are configured for the **Apple-provided sandbox**
- Product IDs are registered in App Store Connect
- Prices are properly configured with localized tiers

### Developer's Sandbox Testing:
- Developer has successfully tested all IAP purchases using a sandbox account
- Purchase flow, receipt validation, and credit allocation all work correctly

### Business Agreements:
- ✅ Paid Apps Agreement: **ACTIVE**
- ✅ Tax Forms: **COMPLETED**
- ✅ Bank Account: **VERIFIED**

---

## 📱 APP FEATURES OVERVIEW

### Cultural Events Supported (12):
1. Anniversary (Universal)
2. Chinese New Year (Chinese)
3. Christmas (Christian)
4. Diwali (Hindu)
5. Easter (Christian)
6. Eid al-Adha (Islamic)
7. Hanukkah (Jewish)
8. Holi (Hindu)
9. Mid-Autumn Festival (Chinese)
10. Raksha Bandhan (Hindu)
11. Rosh Hashanah (Jewish)
12. Vesak Day (Buddhist)

### Key Features:
- AI-powered personalized cultural gift generation
- Culturally-authentic designs and animations
- Multi-cultural support with respectful representations
- Contact integration for easy sharing
- Free tier (3 generations) + credit-based regeneration

---

## 🔐 AGE GATE IMPLEMENTATION

### Guideline 1.3 - Kids Category:
- App includes an **age gate** on first launch
- Users must be **13 years or older** to use the app
- Age verification is required before accessing any features
- Prevents underage users from accessing AI-generated content

### To Pass Age Gate:
- Enter any age **13 or higher**
- Age is verified immediately
- User can proceed to onboarding

---

## 🛡️ PRIVACY & DATA HANDLING

### Guideline 5.1.1 - Data Collection and Storage:
- Privacy Policy: https://kg191.github.io/forava-legal/privacy.html
- Terms of Service: https://kg191.github.io/forava-legal/terms.html
- Minimal data collection (contacts used with permission)
- AI-generated content is not stored permanently
- Full compliance with Apple privacy guidelines

---

## 🚨 IMAGE GENERATION IN TESTFLIGHT

### Known Issue - TestFlight Builds:
The developer has noted that **AI image generation may fail in TestFlight** due to API key configuration issues. This is a **build configuration issue**, not an App Store rejection reason.

### Why This Happens:
- API keys (OpenAI, Replicate) are loaded from environment variables
- Environment variables are not set in archived/TestFlight builds
- Local development builds work correctly

### Workaround for Review:
If image generation fails during your review:
1. You can still **access and test all IAP products** (they don't require image generation)
2. The IAP purchase flow, receipt validation, and credit allocation can be fully tested
3. The UI/UX for cultural gift selection, contact selection, and customization are all functional

### Developer's Plan to Fix:
- Configure API keys in Xcode Scheme environment variables
- Ensure keys are available in Archive scheme for production builds
- This will be resolved before production release

---

## 📞 CONTACT INFORMATION

**Developer Support Email:** foravaapp@gmail.com

For any questions or clarification during the review process, please contact the developer.

---

## ✅ REVIEW CHECKLIST FOR APPLE

Please verify the following during your review:

- [ ] IAP products are accessible via **Settings → "Buy Regeneration Credits"**
- [ ] IAP products are accessible via **Welcome Screen → "Purchase Credits Now"**
- [ ] All 4 credit pack products display with correct names and prices
- [ ] IAP purchase flow can be initiated (sandbox testing)
- [ ] Age gate properly restricts underage users
- [ ] Privacy Policy and Terms of Service are accessible
- [ ] Cultural content is respectful and appropriate
- [ ] Contact permission is requested appropriately

---

## 🎉 THANK YOU

Thank you for reviewing Forava! We've made IAP access **immediately visible** through Settings and the Welcome screen to ensure a smooth review process.

If you have any difficulty locating the IAP products, please use **PATH 1 (Settings)** as the most direct route.

---

**Document Version:** 1.0
**Created:** November 27, 2025
**For Review Submission:** aaf66989-d30e-4926-84e6-e3c5393e2dff
