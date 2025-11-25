# Internal Clarification: Payment Systems Architecture

**Document Purpose**: Clarify the distinction between StoreKit and PassKit to prevent future confusion
**Created**: November 25, 2025
**Related To**: App Store Review 1 - PassKit Rejection

---

## Question That Prompted This Document

> **"What if the user wants to pay for subscriptions/credits using Apple Pay? Will removing PassKit prevent that?"**
>
> **"How does payment work for David Jones purchases in the Gratitude tab? Does PassKit need to be involved?"**

---

## Short Answer

**NO** - Removing PassKit will NOT prevent users from using Apple Pay for:
1. ✅ Forava subscriptions
2. ✅ Forava regeneration credits
3. ✅ Gratitude tab retailer purchases

Users can still use Apple Pay for ALL payment scenarios. Here's why:

---

## The Critical Distinction: StoreKit vs PassKit

### StoreKit (What Forava Uses) ✅

**Purpose**: Digital goods, subscriptions, in-app purchases within apps

**Payment Flow**:
- User purchases through Apple's App Store system
- Payment processed by Apple (not the app developer)
- Apple handles ALL payment method choices

**Available Payment Methods** (Managed by iOS/App Store):
- ✅ Apple Pay
- ✅ Credit/Debit cards
- ✅ Carrier billing
- ✅ Apple Account balance
- ✅ Gift cards

**How Apple Pay Works with StoreKit**:
When a user buys a Forava subscription through StoreKit, Apple shows their standard payment sheet. If the user has Apple Pay configured in their Apple ID settings, **they can already use Apple Pay** - no PassKit code needed in the app.

**Code Requirements**:
- Import `StoreKit`
- NO need to import `PassKit`
- NO entitlements required

**Examples**:
- App Store app downloads
- Netflix subscription
- Spotify Premium
- Forava subscriptions
- Forava regeneration credits

---

### PassKit (What Forava Doesn't Need) ❌

**Purpose**: Physical goods, services, merchant payments

**Payment Flow**:
- App directly processes payments through merchant account
- Developer handles payment authorization
- App implements Apple Pay UI (PKPaymentButton)

**Use Cases**:
- Retail store purchases (buying clothes, groceries)
- Restaurant payments (Domino's pizza)
- Ride-sharing services (Uber, Lyft)
- Event tickets, boarding passes
- Peer-to-peer money transfers

**Code Requirements**:
- Import `PassKit`
- Implement PKPaymentAuthorizationController
- Requires merchant identifier entitlement
- Requires payment processor integration (Stripe, Adyen, etc.)

**Examples**:
- Ordering pizza in Domino's app
- Buying shoes in Nike app
- Paying for Uber ride
- Purchasing physical goods in retail apps

---

## Forava's Three Payment Systems

Forava actually has **three separate payment systems**, each with different technologies:

### 1. Forava Subscriptions (StoreKit - Internal to App)

**What**: Monthly ($7.99) and Annual ($59.99) unlimited subscription plans

**Where Payment Happens**: Apple's App Store (through user's Apple ID)

**Technology**: StoreKit 2

**Can Users Use Apple Pay**: ✅ **YES** - Apple handles this at the iOS system level

**PassKit Needed**: ❌ **NO**

**User Experience**:
```
1. User taps "Subscribe Monthly" in Forava app
2. iOS shows standard App Store payment sheet
3. User sees their default payment method (could be Apple Pay)
4. User authenticates with Face ID/Touch ID
5. Purchase completes
6. Forava receives transaction confirmation from StoreKit
```

**Key Point**: The user's choice of Apple Pay happens at the **Apple/iOS level**, not in Forava's app code. Apple manages everything.

---

### 2. Forava Regeneration Credits (StoreKit - Internal to App)

**What**: Credit packs for additional AI image generations
- Starter Pack (10 credits): $9.99
- Popular Pack (25 credits): $19.99
- Family Pack (50 credits): $34.99
- Festival Pack (100 credits): $59.99

**Where Payment Happens**: Apple's App Store (through user's Apple ID)

**Technology**: StoreKit 2 (Consumable IAP)

**Can Users Use Apple Pay**: ✅ **YES** - Same as subscriptions, handled by Apple

**PassKit Needed**: ❌ **NO**

**User Experience**: Identical to subscription purchase flow above

---

### 3. Gratitude Gift Vouchers (External - Retailer Websites)

**What**: Physical gifts from 17 retailers
- Department Stores: David Jones, Myer, Westfield
- Entertainment: Ticketek, Event Cinema
- Beauty: Sephora, Mecca Maxima
- Books: Dymocks
- Fashion: Country Road, Witchery, Mimco
- Sports: Nike, Adidas, Rebel
- Electronics: JB Hi-Fi

**Where Payment Happens**: Retailer's website (davidjones.com, myer.com.au, etc.)

**Technology**: Simple URL opening (`UIApplication.shared.open()`)

**Can Users Use Apple Pay**: ✅ **YES, IF** the retailer's website supports it (not Forava's concern)

**PassKit Needed**: ❌ **NO**

**User Experience**:
```
1. User taps "Browse Gift Vouchers" in Gratitude tab
2. User selects category (e.g., "Department Stores")
3. User taps on retailer (e.g., "David Jones")
4. Forava app opens Safari to davidjones.com
5. User browses and shops on David Jones' website
6. User checks out using David Jones' payment system
   - If David Jones supports Apple Pay, user can use it there
   - Payment processed entirely by David Jones
7. Forava app is NOT involved in the payment at all
```

**Key Point**: Forava acts as a **directory/referral service** only. It simply opens the retailer's website. The retailer handles everything else:
- Product browsing
- Shopping cart
- Payment processing (including Apple Pay if they support it)
- Order fulfillment
- Customer accounts

**Account Requirements**: Depends on the retailer's policies:
- Some retailers allow guest checkout (no account needed)
- Others require account creation
- This is controlled by the retailer, not Forava

---

## What This Means for PassKit Removal

### Safe to Remove Because:

1. **StoreKit Subscriptions**: Users can already use Apple Pay through Apple's App Store infrastructure. No PassKit code needed.

2. **StoreKit Credits**: Same as subscriptions - Apple Pay is available through App Store, not PassKit.

3. **Gratitude Vouchers**: Forava just opens Safari. If a retailer supports Apple Pay on their website, users can use it there. That's the retailer's PassKit implementation, not Forava's.

### What Won't Change:

- ✅ Users can still use Apple Pay for Forava subscriptions (via StoreKit/App Store)
- ✅ Users can still use Apple Pay for regeneration credits (via StoreKit/App Store)
- ✅ Users can still use Apple Pay on retailer websites (via retailer's implementation)
- ✅ All three payment systems continue working exactly as before

### What Will Change:

- ❌ Dead code removed (ApplePayConfig.swift, APIClient.swift)
- ❌ Unnecessary import removed (SettingsView.swift)
- ❌ Incorrect entitlement removed (ForavaApp.entitlements)
- ✅ App Store approval obtained

---

## Real-World Analogy

Think of it like this:

**StoreKit = Buying from Apple**
- Like buying an app, Netflix subscription, or Spotify Premium through the App Store
- Apple handles all payment options (including Apple Pay)
- You pay through your Apple ID
- The app developer doesn't need to implement payment UI

**PassKit = Buying from a Merchant Directly**
- Like paying for pizza in Domino's app, buying shoes in Nike app, or paying for an Uber ride
- The merchant (app developer) implements Apple Pay button and payment flow
- Payment goes directly to the merchant
- Requires PassKit code in the app

**Forava's Gratitude Tab = Phone Book/Directory**
- Like a phone book that just lists retailers and their addresses
- Forava says "David Jones is at davidjones.com"
- You visit their website yourself
- David Jones handles their own payment system
- Forava doesn't need PassKit for this

---

## Technical Implementation Details

### What Users See (StoreKit Subscriptions)

When a user buys a Forava subscription:

**Step 1**: User taps "Subscribe" in Forava app

**Step 2**: iOS shows Apple's standard purchase dialog:
```
┌─────────────────────────────────┐
│  Confirm Purchase                │
│                                  │
│  Monthly Unlimited               │
│  $7.99 per month                 │
│                                  │
│  [Apple Pay Card •••• 1234]     │
│                                  │
│  [Pay with Face ID]             │
│                                  │
│  Cancel                          │
└─────────────────────────────────┘
```

**Step 3**: User authenticates with Face ID/Touch ID

**Step 4**: Apple processes payment using the user's preferred payment method (could be Apple Pay, credit card, etc.)

**Step 5**: Forava receives transaction confirmation from StoreKit

**Where Apple Pay Happens**: In Step 2-4, entirely managed by iOS. Forava's app code never touches payment details.

---

### Implementation Code Comparison

#### StoreKit Implementation (What Forava Has)

```swift
import StoreKit

// This is all Forava needs for subscriptions
Task {
    let product = try await Product.products(for: ["com.forava.subscription.monthly"]).first
    let result = try await product?.purchase()
    // Apple shows payment sheet, user chooses Apple Pay if they want
    // Forava receives confirmation when done
}
```

**PassKit Needed**: ❌ NO - Apple handles payment UI

---

#### PassKit Implementation (What Forava Doesn't Need)

```swift
import PassKit

// This is what merchant apps (like Domino's) do
let request = PKPaymentRequest()
request.merchantIdentifier = "merchant.com.dominos"
request.paymentSummaryItems = [PKPaymentSummaryItem(label: "Pizza", amount: 15.99)]

let controller = PKPaymentAuthorizationController(paymentRequest: request)
controller.delegate = self
controller.present() // Shows Apple Pay sheet

// App must implement delegate methods to process payment
func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController,
                                    didAuthorizePayment payment: PKPayment) {
    // Send payment token to payment processor (Stripe, Adyen, etc.)
    // Handle payment confirmation
}
```

**PassKit Needed**: ✅ YES - App directly implements Apple Pay

**Forava's Use Case**: ❌ NO - Forava sells digital subscriptions, not physical goods

---

## Why Apple Rejected Forava

Apple's automated review process detected:

1. ✅ PassKit framework linked in the binary (from dead code imports)
2. ✅ Apple Pay entitlement present (`com.apple.developer.in-app-payments`)
3. ❌ NO Apple Pay UI or payment flow anywhere in the app

**Apple's Logic**: "This app claims to use Apple Pay (has framework + entitlement) but doesn't actually implement it. Either they forgot to finish the implementation, or they have dead code."

**Reality**: Dead code from early development. Team initially considered Apple Pay for merchant payments, created stub files, then correctly chose StoreKit for digital subscriptions instead, but forgot to clean up the unused files.

---

## Future Considerations

### If Forava Ever Needs PassKit

Scenarios where PassKit would be needed:

1. **Digital Wallet Passes**: If Forava wants to add gift cards/vouchers to Apple Wallet
   - Would use PassKit but NOT for payments
   - Would use PKPass for creating wallet passes

2. **Peer-to-Peer Money Transfer**: If Forava adds "send money to friend" feature
   - Would need PassKit for Apple Pay merchant payments
   - Would need payment processor (Stripe, Adyen, etc.)
   - Would need PCI compliance

3. **Physical Goods Marketplace**: If Forava becomes a marketplace selling physical items
   - Would need PassKit for direct payment processing
   - Would need merchant account
   - Would need fulfillment system

**Current Forava**: None of these scenarios apply. Forava sells:
- Digital subscriptions → StoreKit ✅
- Digital credits → StoreKit ✅
- Referrals to retailers → URL opening ✅

---

## Key Takeaways

1. **StoreKit ≠ PassKit**: Completely different frameworks for different purposes

2. **Apple Pay Works Without PassKit**: For digital goods/subscriptions, users can use Apple Pay through StoreKit without any PassKit code

3. **Three Payment Systems in Forava**: All three continue working after PassKit removal

4. **Gratitude Tab Doesn't Need PassKit**: It's just a directory that opens websites

5. **Safe to Remove**: Dead code removal has zero functional impact

6. **App Store Will Approve**: Once PassKit references removed, rejection reason disappears

---

## Reference Documents

- **Root Cause Analysis**: `Response_1_Analysis.md` - Technical details of PassKit inclusion
- **Apple's Rejection**: `Review_1_Rejection.md` - Original rejection message
- **Formal Response**: `Response_to_Apple.docx` - Official response for resubmission

---

## Questions & Answers

### Q: Will users be able to use Apple Pay after PassKit is removed?
**A**: Yes. For subscriptions/credits through StoreKit, and for retailer purchases on their websites.

### Q: Do we need to do anything special to enable Apple Pay for StoreKit purchases?
**A**: No. It's automatically available if the user has Apple Pay configured in their Apple ID.

### Q: What if David Jones doesn't support Apple Pay on their website?
**A**: That's David Jones' choice. Forava just opens their website - we don't control their payment options.

### Q: Should we add affiliate tracking to Gratitude voucher URLs?
**A**: Possible future enhancement. Currently URLs are direct without tracking parameters.

### Q: Could we use SFSafariViewController instead of opening Safari?
**A**: Yes, would keep users in-app. Consider for future UX improvement.

### Q: What about Apple Wallet passes for gift vouchers?
**A**: Would require PassKit, but only for pass creation (not payments). Could be future feature if retailers provide passes.

---

**Document Version**: 1.0
**Last Updated**: November 25, 2025
**Author**: Forava Development Team
**Purpose**: Internal technical clarification for payment architecture
