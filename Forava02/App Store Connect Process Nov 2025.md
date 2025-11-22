# App Store Connect Submission Guide - Forava v1.0
## Multi-Cultural AI Digital Gifting Platform

**Document Version:** 1.0
**Date:** November 2025
**Status:** Ready for Submission

---

## Table of Contents
1. [Pre-Submission Checklist](#1-pre-submission-checklist)
2. [App Store Connect Account Setup](#2-app-store-connect-account-setup)
3. [Create New App in App Store Connect](#3-create-new-app-in-app-store-connect)
4. [In-App Purchases Configuration](#4-in-app-purchases-configuration)
5. [Subscription Configuration](#5-subscription-configuration)
6. [Build Upload Process](#6-build-upload-process)
7. [App Metadata and Assets](#7-app-metadata-and-assets)
8. [App Privacy Configuration](#8-app-privacy-configuration)
9. [App Review Information](#9-app-review-information)
10. [Sandbox Testing Setup](#10-sandbox-testing-setup)
11. [Final Submission](#11-final-submission)
12. [Post-Submission Monitoring](#12-post-submission-monitoring)

---

## App Details Summary

**Bundle Identifiers:**
- iOS: `com.forava.app`
- Watch: `com.forava.watch`

**Version Information:**
- Marketing Version: 1.0
- Build Number: 1

**IAP Products:**
- Subscriptions: Monthly ($7.99), Annual ($59.99)
- Credit Packs: 10 ($9.99), 25 ($19.99), 50 ($34.99), 100 ($59.99)
- Legacy: Single Regeneration ($1.99)

**Privacy:**
- Privacy Policy: https://forava.com/privacy
- Terms of Use: https://forava.com/terms

---

## 1. Pre-Submission Checklist

### Technical Requirements
- [ ] **Xcode Version:** Xcode 15.0+ installed
- [ ] **macOS Version:** macOS Sonoma 14.0+ or later
- [ ] **Code Signing:** Apple Developer account with valid certificates
- [ ] **Build Success:** Clean build with 0 errors, 0 critical warnings
- [ ] **Bundle IDs Registered:**
  - iOS: `com.forava.app`
  - Watch: `com.forava.watch`
- [ ] **Version Numbers Set:**
  - Marketing Version: 1.0
  - Build Number: 1 (increment for each upload)

### App Store Connect Prerequisites
- [ ] **Apple Developer Account:** Active paid membership ($99/year)
- [ ] **App-Specific Password:** Generated for Xcode uploads
- [ ] **Agreement & Tax:** All contracts signed, banking info complete
- [ ] **Developer Team ID:** Know your Team ID for certificate management

### Legal & Compliance
- [ ] **Privacy Policy:** Live at `https://forava.com/privacy`
- [ ] **Terms of Use:** Live at `https://forava.com/terms`
- [ ] **Age Gate Implementation:** Age verification (12+) implemented
- [ ] **Content Rating:** Prepared for 12+ rating justification

### Assets Ready
- [ ] **App Icon:** 1024x1024px PNG (no alpha channel)
- [ ] **iPhone Screenshots:** 5 screenshots for 6.7" display (1290x2796px)
- [ ] **Apple Watch Screenshots:** 2 screenshots for 45mm display
- [ ] **App Preview Video:** 30-second video (optional but recommended)

---

## 2. App Store Connect Account Setup

### Step 2.1: Access App Store Connect
1. Navigate to https://appstoreconnect.apple.com
2. Sign in with Apple ID associated with Developer account
3. Verify account shows "Active" status
4. Check "Agreements, Tax, and Banking" section:
   - Go to **Agreements, Tax, and Banking**
   - Ensure **Paid Applications Agreement** is "Active"
   - Complete **Tax Forms** (W-9 for US, W-8 for international)
   - Add **Banking Information** for revenue deposits

### Step 2.2: Generate App-Specific Password
1. Go to https://appleid.apple.com
2. Navigate to **Sign-In and Security** → **App-Specific Passwords**
3. Click **Generate Password**
4. Label: "Xcode App Store Upload - Forava"
5. Save password securely (needed for Xcode uploads)

### Step 2.3: Verify Developer Team
1. In App Store Connect, click your name (top right)
2. Select **View Membership**
3. Note your **Team ID** (e.g., "ABC123XYZ")
4. Verify role shows "Account Holder" or "Admin"

---

## 3. Create New App in App Store Connect

### Step 3.1: Create New App Record
1. In App Store Connect, go to **My Apps**
2. Click **+ (plus icon)** → **New App**
3. Fill in app details:

**Platform Selection:**
- [x] iOS
- [x] watchOS (companion app)

**App Information:**
- **Name:** Forava
- **Primary Language:** English (U.S.)
- **Bundle ID:** `com.forava.app` (select from dropdown)
- **SKU:** `com.forava.app.2025` (unique identifier)
- **User Access:** Full Access

4. Click **Create**

### Step 3.2: Configure App Information
1. Navigate to **App Information** (left sidebar)
2. Fill required fields:

**General Information:**
- **App Name:** Forava
- **Subtitle (optional):** Multi-Cultural AI Digital Gifting
- **Category:**
  - Primary: Lifestyle
  - Secondary: Social Networking

**Additional Information:**
- **Privacy Policy URL:** `https://forava.com/privacy`
- **Apple Watch:** Select "watchOS App" (companion)
- **Content Rights:** Select "No, it does not contain third-party content"

3. Click **Save**

---

## 4. In-App Purchases Configuration

### Step 4.1: Create Subscription Group
1. Go to **My Apps** → **Forava** → **In-App Purchases**
2. Click **Manage** next to "Subscription Groups"
3. Click **+ (Create Subscription Group)**
4. Configure:
   - **Reference Name:** Forava Unlimited Subscriptions
   - **Group Name:** Unlimited Generations
5. Click **Create**

### Step 4.2: Add Monthly Subscription
1. Inside subscription group, click **+ (Create Subscription)**
2. Configure:

**Subscription Information:**
- **Reference Name:** Monthly Unlimited Subscription
- **Product ID:** `com.forava.subscription.monthly`
- **Subscription Duration:** 1 month

**Subscription Pricing:**
- Click **+ (Add Pricing)**
- **Base Price:** $7.99 USD
- **Availability:** All territories
- Click **Next** → **Create**

**Localizations:**
- Click **+ (Add Localization)**
- **Language:** English (U.S.)
- **Subscription Display Name:** Monthly Unlimited
- **Description:** Unlimited AI image generations for all 12 cultural events. Unlimited generations, no watermarks, priority processing. Auto-renews monthly.
- Click **Save**

**Free Trial:**
- Click **Set Up Introductory Offer**
- **Offer Type:** Free Trial
- **Duration:** 7 days
- Click **Save**

3. Click **Save** → Submit for review

### Step 4.3: Add Annual Subscription
1. In same subscription group, click **+ (Create Subscription)**
2. Configure:
   - **Reference Name:** Annual Unlimited Subscription
   - **Product ID:** `com.forava.subscription.annual`
   - **Subscription Duration:** 1 year
   - **Base Price:** $59.99 USD
   - **Display Name:** Annual Unlimited
   - **Description:** Unlimited generations + premium features. Best value - save 38%! Auto-renews annually.
   - **Free Trial:** 7 days

3. Click **Save** → Submit for review

### Step 4.4: Add Credit Packs
Create consumable IAP products for each credit pack:

**Starter Pack (10 Credits):**
- **Product ID:** `com.forava.credits.10`
- **Price:** $9.99 USD
- **Display Name:** Starter Pack
- **Description:** 10 AI image generations. Credits never expire.

**Popular Pack (25 Credits):**
- **Product ID:** `com.forava.credits.25`
- **Price:** $19.99 USD
- **Display Name:** Popular Pack
- **Description:** 25 AI image generations. Save 20%! Credits never expire.

**Family Pack (50 Credits):**
- **Product ID:** `com.forava.credits.50`
- **Price:** $34.99 USD
- **Display Name:** Family Pack
- **Description:** 50 AI image generations. Save 30%! Credits never expire.

**Festival Pack (100 Credits):**
- **Product ID:** `com.forava.credits.100`
- **Price:** $59.99 USD
- **Display Name:** Festival Pack
- **Description:** 100 AI image generations. Save 40%! Credits never expire.

For each credit pack:
1. Go to **In-App Purchases** → **+ (plus icon)** → **Consumable**
2. Fill in product information
3. Add pricing
4. Add localization
5. Upload review screenshot
6. Click **Save** → Submit for review

**Important:** All IAP products must be submitted for review BEFORE app submission. Allow 24-48 hours for approval.

---

## 5. Subscription Configuration

### Step 5.1: Family Sharing Setup
1. Go to **Subscription Groups** → Select your group
2. For each subscription (monthly and annual):
   - Scroll to **Family Sharing**
   - Toggle **ON** "Enable Family Sharing"
   - Click **Save**

**Note:** Credit packs (consumables) cannot be shared via Family Sharing.

### Step 5.2: Subscription Disclosures
Add App Store Disclosure:

```
Subscription Details:
• Unlimited AI image generations for all 12 cultural events
• Premium features: Priority processing, early access, exclusive elements
• Price: $7.99/month or $59.99/year (auto-renewable)
• Free trial: 7 days (new subscribers only)
• Payment charged to Apple Account at confirmation
• Auto-renews unless canceled 24 hours before period ends
• Manage subscriptions in Settings → [Your Name] → Subscriptions

Privacy Policy: https://forava.com/privacy
Terms of Use: https://forava.com/terms
```

---

## 6. Build Upload Process

### Step 6.1: Prepare Build for Distribution
1. Open `Forava.xcodeproj` in Xcode
2. Select **ForavaApp** target
3. Select **Any iOS Device (arm64)** as destination

### Step 6.2: Configure Code Signing
1. Select **ForavaApp** target
2. Go to **Signing & Capabilities** tab
3. Configure:
   - **Automatically manage signing:** [x] Checked
   - **Team:** Select your Apple Developer Team
   - **Bundle Identifier:** `com.forava.app`

4. Repeat for **ForavaWatch** target:
   - **Bundle Identifier:** `com.forava.watch`

### Step 6.3: Archive Build
1. Go to **Product** → **Archive**
2. Wait for build to complete (5-10 minutes)
3. Xcode Organizer window opens automatically
4. Verify archive shows:
   - App name: ForavaApp
   - Version: 1.0
   - Build: 1

### Step 6.4: Validate Build
1. In Organizer, select archive
2. Click **Validate App**
3. Configure validation:
   - **Distribution method:** App Store Connect
   - **Upload symbols:** [x] Yes
   - **Manage Version and Build Number:** [x] Yes

4. Click **Next** → Wait for validation
5. Review validation results

### Step 6.5: Upload Build
1. Click **Distribute App**
2. Select **App Store Connect** → **Upload**
3. Wait for upload to complete (5-15 minutes)
4. Success message: "ForavaApp.ipa uploaded successfully"

### Step 6.6: Verify Upload
1. Go to App Store Connect → **Forava** → **TestFlight**
2. Wait 5-10 minutes for build processing
3. Build appears under **iOS Builds**
4. Click **Manage** next to "Missing Compliance"
5. Answer export compliance:
   - **Uses encryption?** Yes (HTTPS)
   - **Exempt from regulations?** Yes (standard HTTPS only)

---

## 7. App Metadata and Assets

### Step 7.1: Version Information
1. Go to **App Store** → Click **+ Version or Platform** → **iOS**
2. Enter version: **1.0**
3. Fill **What's New in This Version:**

```
🎉 Welcome to Forava - Multi-Cultural AI Digital Gifting Platform!

✨ NEW FEATURES:
• 12+ authentic cultural celebration contexts
• AI-powered cultural gift generation
• Apple Watch integration
• Subscription model: $7.99/month or $59.99/year
• Credit packs: $9.99-$59.99
• Free tier: 3 generations to try

🌍 CULTURAL TRADITIONS:
Hindu, Chinese, Christian, Islamic, Buddhist, Jewish celebrations

⌚ APPLE WATCH FEATURES:
• Cultural gift displays and animations
• Cross-device synchronization
• Battery-optimized experiences

Transform cultural celebrations with AI!
```

### Step 7.2: App Description
```
🎁 Transform Cultural Celebrations with AI-Powered Digital Gifts

Forava brings the world's most beautiful cultural traditions to your fingertips through AI-generated personalized digital gifts.

🌍 12+ CULTURAL TRADITIONS SUPPORTED:
• Hindu: Diwali, Raksha Bandhan, Holi
• Chinese: Chinese New Year, Mid-Autumn Festival
• Christian: Christmas, Easter
• Islamic: Eid al-Fitr, Eid al-Adha
• Buddhist: Vesak Day
• Jewish: Hanukkah, Rosh Hashanah
• Universal: Anniversaries

🎨 AI-POWERED AUTHENTICITY:
• Advanced AI creates culturally accurate artwork
• Traditional, modern, elegant, spiritual themes
• Culturally appropriate colors, symbols, elements
• Personal messages in multiple languages

⌚ APPLE WATCH INTEGRATION:
• Beautiful cultural animations
• Seamless iPhone-Watch sync
• Optimized battery performance

💎 FLEXIBLE PRICING:
• Free Tier: 3 generations (watermarked)
• Credit Packs: $9.99-$59.99
• Monthly Subscription: $7.99/month
• Annual Subscription: $59.99/year

Perfect for families maintaining traditions!
```

### Step 7.3: Keywords
```
cultural gifts,AI cards,diwali,christmas,eid,chinese new year,digital greeting,anniversary
```

### Step 7.4: Support URLs
- **Support URL:** `https://forava.com`
- **Marketing URL:** `https://forava.com`

### Step 7.5: App Icon
Upload 1024x1024px PNG (no transparency, RGB color space)

### Step 7.6: Screenshots - iPhone 6.7" Display
Upload 5 screenshots (1290x2796px each):

1. **Cultural Selection Grid** - "Celebrate 12+ Cultural Traditions"
2. **AI Generation Process** - "AI-Powered Cultural Authenticity"
3. **Personalization Interface** - "Personalize Your Cultural Gift"
4. **Subscription Tiers** - "Flexible Pricing for Everyone"
5. **Apple Watch Display** - "Beautiful on iPhone and Apple Watch"

### Step 7.7: Screenshots - Apple Watch
Upload 2 screenshots (396x484px for 45mm):

1. **Cultural Gift Display** - Watch face with animation
2. **Synchronization** - Notification on watch

---

## 8. App Privacy Configuration

### Step 8.1: Start Privacy Configuration
1. Go to **App Privacy** → **Get Started**

### Step 8.2: Data Collection - Contact Info
1. Click **Contact Info** → **Yes**
2. Select:
   - [x] **Name** (from Contacts)
   - [x] **Phone Number** (from Contacts)

3. For each:
   - **Linked to identity?** No
   - **Used for tracking?** No
   - **Purpose:** App Functionality

### Step 8.3: Data Collection - User Content
1. Click **User Content** → **Yes**
2. Select:
   - [x] **Photos or Videos** (AI-generated gifts)
   - [x] **Other User Content** (preferences, messages)

3. For each:
   - **Linked to identity?** No
   - **Used for tracking?** No
   - **Purpose:** App Functionality

### Step 8.4: Data Collection - Identifiers
1. Click **Identifiers** → **Yes**
2. Select:
   - [x] **Device ID** (crash reporting only)

3. Answer:
   - **Linked to identity?** No
   - **Used for tracking?** No
   - **Purpose:** App Functionality

### Step 8.5: Privacy Policy URL
Verify: `https://forava.com/privacy`

### Step 8.6: Age Rating Questionnaire
Answer questions:
- **Unrestricted Web Access:** No
- **Gambling:** No
- **Violence:** No
- **Profanity:** No
- **User-Generated Content:** Yes
  - **Can users communicate?** No
  - **Can users share publicly?** Yes

**Calculated Age Rating:** 12+

---

## 9. App Review Information

### Step 9.1: Contact Information
- **First Name:** Kiran
- **Last Name:** Gokal
- **Phone Number:** [Your phone]
- **Email:** foravaapp@gmail.com

### Step 9.2: Demo Account
Create test account:

**Credentials:**
- **Username:** reviewer@forava.com
- **Password:** ForavaReview2025!

**Instructions:**
```
DEMO ACCOUNT INSTRUCTIONS:

1. Age Gate: Select birthdate showing 12+ years
2. Contact Access: Allow or Don't Allow (works both ways)
3. Credit Balance: Pre-loaded with 100 credits
4. Subscription: Sandbox environment active

TEST FLOWS:
A) Free User: Use 3 free generations (watermarked)
B) Credit Pack: Buy 25-credit pack (sandbox)
C) Subscription: Subscribe monthly/annual (sandbox)
D) Cultural Testing: Test Diwali, Christmas, Chinese New Year, Eid

APPLE WATCH:
- Pair simulators
- Generate gift on iPhone
- Verify Watch synchronization

NOTES:
- All IAP uses sandbox (no real charges)
- AI generation: 20-30 seconds normal
- Cultural accuracy: >80% for all events
```

### Step 9.3: Notes for App Review
```
FORAVA APP REVIEW NOTES - NOVEMBER 2025

=== APP OVERVIEW ===
Multi-cultural AI digital gifting platform using OpenAI DALL-E 3
for generating culturally authentic artwork for 12+ celebrations.

=== CULTURAL AUTHENTICITY ===
- Color palettes match cultural traditions
- Symbols respectful and non-appropriative
- Greetings culturally appropriate
- User reporting system for concerns

=== MONETIZATION ===
- Free Tier: 3 generations (lifetime, watermarked)
- Credit Packs: $9.99-$59.99 (10-100 credits)
- Subscriptions: $7.99/month, $59.99/year
- All via Apple IAP (StoreKit 2)

=== PRIVACY & DATA ===
- Age verification: Local storage only
- Contact access: Optional (CNContactStore)
- AI generation: No PII sent to OpenAI
- No user accounts required
- Privacy: https://forava.com/privacy
- Terms: https://forava.com/terms

=== AGE RATING: 12+ ===
Reasons:
1. AI-generated content
2. Contact access requires privacy understanding
3. In-app purchases
4. User-shared content

=== TESTING RECOMMENDATIONS ===
1. Age gate flow
2. Free tier (3 generations)
3. Credit pack purchase
4. Subscription purchase
5. Cultural accuracy (3-4 events)
6. Contact access (Allow/Don't Allow)
7. Watch synchronization

Support: foravaapp@gmail.com
Response: <24 hours
```

---

## 10. Sandbox Testing Setup

### Step 10.1: Can You Reuse Existing Sandbox?

**✅ ANSWER: YES** - Sandbox test accounts are reusable across apps within the same Apple Developer account. However, it's recommended to create fresh sandbox accounts for clean testing of new IAP products.

### Step 10.2: Create Sandbox Test Accounts
1. Go to **App Store Connect** → **Users and Access**
2. Click **Sandbox** tab
3. Click **+ Add Tester**

Create 3 test accounts:

**Sandbox Tester 1 (Free User):**
- Email: test.freeuser@forava-sandbox.com
- Password: Sandbox2025!
- Country: United States

**Sandbox Tester 2 (Subscriber):**
- Email: test.subscriber@forava-sandbox.com
- Password: Sandbox2025!

**Sandbox Tester 3 (Credit Buyer):**
- Email: test.creditbuyer@forava-sandbox.com
- Password: Sandbox2025!

### Step 10.3: Configure Test Device
On iPhone/iPad:
1. **Settings** → **App Store**
2. **Sandbox Account** → **Sign In**
3. Enter sandbox email and password
4. Verify "Sandbox Account" label appears

### Step 10.4: Test IAP Flows
Test scenarios:
- [ ] Free tier: 3 generations with watermark
- [ ] Paywall: Attempt 4th generation
- [ ] Credit packs: 10, 25, 50, 100 credits
- [ ] Subscriptions: Monthly and annual
- [ ] Family Sharing: Share subscription
- [ ] Restore Purchases: Reinstall and restore

### Step 10.5: Subscription Renewal Acceleration
Sandbox subscriptions renew faster:
- **1 month** → Renews every 5 minutes
- **1 year** → Renews every 1 hour

---

## 11. Final Submission

### Step 11.1: Pre-Flight Checklist
- [x] Build uploaded and processed
- [x] All IAP products approved
- [x] Privacy Policy live
- [x] Terms of Use live
- [x] Screenshots uploaded
- [x] App icon uploaded
- [x] Metadata complete
- [x] Age rating confirmed (12+)
- [x] Demo account added
- [x] Review notes complete

### Step 11.2: Select Build
1. Go to **App Store** → **Version 1.0**
2. **Build** section → **Select a build**
3. Choose uploaded build (1.0, build 1)
4. Click **Done**

### Step 11.3: Version Release Options
Choose:
- **Manual release** (RECOMMENDED for v1.0)
- Allows final testing before public launch

### Step 11.4: Submit for Review
1. Click **Add for Review** (top right)
2. Review all sections
3. Click **Submit for Review**
4. Status: "Waiting for Review"

### Step 11.5: Review Timeline
- **Waiting for Review:** 1-3 days
- **In Review:** 1-2 days
- **Pending Developer Release:** Approved!
- **Average Total:** 3-5 days

---

## 12. Post-Submission Monitoring

### Step 12.1: Check Review Status Daily
Monitor status in App Store Connect:
- Waiting for Review
- In Review
- Pending Developer Release
- Rejected (respond via Resolution Center)

### Step 12.2: Respond to App Review
If rejected, read feedback carefully and respond via Resolution Center with fixes.

### Step 12.3: Release App to Public
1. Status: **Pending Developer Release**
2. Click **Release This Version**
3. App goes live in 1-2 hours
4. Status: **Ready for Sale**

### Step 12.4: Monitor Post-Launch
**First 24 Hours:**
- [ ] Verify App Store search
- [ ] Test IAP on production
- [ ] Monitor crash reports
- [ ] Check user reviews
- [ ] Monitor subscriptions

**First Week:**
- [ ] App Analytics (downloads, sessions)
- [ ] IAP revenue (credit vs subscription)
- [ ] Cultural feedback
- [ ] Respond to reviews
- [ ] Plan version 1.1

---

## Appendix A: IAP Product Reference

| Product ID | Type | Price | Credits | Description |
|-----------|------|-------|---------|-------------|
| com.forava.subscription.monthly | Auto-Renewable | $7.99/mo | Unlimited | Monthly unlimited generations |
| com.forava.subscription.annual | Auto-Renewable | $59.99/yr | Unlimited | Annual unlimited + premium |
| com.forava.credits.10 | Consumable | $9.99 | 10 | Starter Pack |
| com.forava.credits.25 | Consumable | $19.99 | 25 | Popular Pack (save 20%) |
| com.forava.credits.50 | Consumable | $34.99 | 50 | Family Pack (save 30%) |
| com.forava.credits.100 | Consumable | $59.99 | 100 | Festival Pack (save 40%) |
| com.forava.regeneration.credit | Consumable | $1.99 | 1 | Legacy product |

---

## Appendix B: Contact & Support

**App Details:**
- iOS Bundle ID: com.forava.app
- Watch Bundle ID: com.forava.watch
- SKU: com.forava.app.2025

**URLs:**
- Privacy Policy: https://forava.com/privacy
- Terms of Use: https://forava.com/terms
- Support Email: foravaapp@gmail.com

**Apple Resources:**
- App Store Connect: https://appstoreconnect.apple.com
- Developer Documentation: https://developer.apple.com/documentation/
- StoreKit 2 Guide: https://developer.apple.com/documentation/storekit

---

**END OF DOCUMENT**

*Version 1.0 - November 2025*
*Created for Forava iOS App Store Submission*
