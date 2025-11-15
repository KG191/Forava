# Forava App Store Compliance - Action Items Backlog

**Last Updated:** 2025-11-15
**Prioritization:** MoSCoW (Must/Should/Could/Won't)
**Total Items:** 16 actionable tasks

---

## 🔴 P0: CRITICAL - BLOCKING SUBMISSION (Must Have)

### BUSINESS-001: Implement Re-generation IAP
**Priority:** P0 (BLOCKING)
**Effort:** 14 developer days
**Owner:** Payments Team
**Risk Level:** CRITICAL
**Rejection Probability:** 95% if not fixed

**Current State:**
- ComprehensivePaymentService.swift is disabled stub (line 5: "temporarily disabled")
- Re-generation payment ($2/image) mentioned in docs but not implemented
- Subscription IAP exists (forava_monthly_full_access) but consumable IAP missing

**Required Actions:**
1. Create consumable IAP product in App Store Connect
   - Product ID: `forava_regeneration_credit`
   - Type: Consumable
   - Price: $1.99 USD (Apple pricing tier)
   - Localized name: "AI Regeneration Credit"

2. Implement StoreKit 2 purchase flow
   - Create `RegenerationIAPManager.swift`
   - Purchase method: `purchaseRegenerationCredit() async throws -> Transaction?`
   - Restore purchases support
   - Transaction verification

3. Replace/Complete ComprehensivePaymentService
   - Remove "temporarily disabled" stub
   - Integrate RegenerationIAPManager
   - Update UI to trigger IAP purchase

4. UI Integration
   - Add "Regenerate (99¢)" button to all DesignView files (12 cultures)
   - Show purchase flow when clicked
   - Handle purchase success/failure
   - Update UI to show remaining credits (if applicable)

5. Testing
   - Sandbox testing with test Apple ID
   - Purchase flow: success, failure, cancellation
   - Restore purchases functionality
   - Receipt validation

**Files to Modify:**
- Create: `ForavaApp/Services/RegenerationIAPManager.swift`
- Modify: `ForavaApp/Services/ComprehensivePaymentService.swift`
- Modify: All 12 DesignView files to add regeneration button
- Modify: `ForavaApp/Models/SubscriptionModels.swift` (add consumable product)

**Dependencies:**
- App Store Connect access for IAP product creation
- Test Apple ID for sandbox testing

**Definition of Done:**
- [ ] IAP product created in App Store Connect
- [ ] RegenerationIAPManager implemented with StoreKit 2
- [ ] UI integration complete in all 12 cultural designs
- [ ] Sandbox testing passed (purchase, restore, cancellation)
- [ ] Receipt validation implemented
- [ ] Documentation updated

---

### SAFETY-003: Implement Age Gate for AI Content
**Priority:** P0 (BLOCKING)
**Effort:** 10 developer days
**Owner:** Product + Senior iOS Engineer
**Risk Level:** CRITICAL
**Rejection Probability:** 90% if not fixed (explicit 2024 guideline)

**Current State:**
- NO age verification system found in codebase
- AI-generated content qualifies as "creator content" under guideline 1.2.1
- App age rating not yet determined (dependency on PerformanceAgent)

**Required Actions:**
1. Determine App Age Rating (coordinate with PERFORMANCE-003)
   - Complete App Store Connect age rating questionnaire
   - Consider: religious imagery, AI unpredictability, cultural maturity
   - **Recommended:** 12+ rating

2. Design Age Gate UI
   - Shown during first app launch (before AI generation access)
   - Birthdate input field (MM/DD/YYYY)
   - Age calculation logic
   - Persistent storage of age verification status

3. Implement Age Verification
   - Create `AgeGateView.swift`
   - Birthdate validation (reject invalid dates, future dates)
   - Age calculation: `isUserOverMinimumAge(birthdate: Date, minimumAge: Int) -> Bool`
   - Secure storage in UserDefaults or Keychain

4. Restrict AI Generation Based on Age
   - If under minimum age: Show "Age Restricted" message
   - Block access to all 12 cultural design AI generation
   - Allow viewing pre-generated samples (optional)

5. Integration Points
   - Add to `WelcomeView.swift` or onboarding flow
   - Check age before allowing navigation to DesignView
   - Update App Store description to mention age requirement

**Files to Create/Modify:**
- Create: `ForavaApp/Views/AgeGateView.swift`
- Create: `ForavaApp/Utils/AgeVerification.swift`
- Modify: `ForavaApp/Views/WelcomeView.swift` or onboarding
- Modify: All 12 DesignView files to check age before AI generation

**Dependencies:**
- Age rating determination (PERFORMANCE-003)
- UX design for age gate

**Definition of Done:**
- [ ] Age gate UI implemented and tested
- [ ] Birthdate validation functional
- [ ] Age verification persisted securely
- [ ] AI generation blocked for underage users
- [ ] App description updated with age requirement
- [ ] Testing: Various age inputs (under/over minimum, edge cases)

---

### LEGAL-004: Implement PII Sanitization in AI Prompts
**Priority:** P0 (BLOCKING)
**Effort:** 7 developer days
**Owner:** AI Engineering + Privacy Team
**Risk Level:** CRITICAL
**Rejection Probability:** 70% if not fixed + privacy violation

**Current State:**
- Privacy policy states "No personal information included in AI prompts"
- AI prompt building happens in all 12 AI service files (line ~201 in AIRakhiService pattern)
- No verification that contact names or other PII are excluded from prompts

**Required Actions:**
1. Audit Existing AI Prompt Code
   - Review all 12 AI service files (Anniversary, ChineseNewYear, Christmas, Diwali, Easter, EidAlAdha, Hanukkah, Holi, MidAutumnFestival, RakshaBandhan, RoshHashanah, VesakDay)
   - Identify all places where prompts are built
   - Check if contact names, emails, or other PII currently included

2. Create PII Sanitization Layer
   - Create `ForavaApp/Utils/PIISanitizer.swift`
   - Methods:
     - `sanitizePrompt(_ prompt: String) -> String`
     - `containsPII(_ text: String) -> Bool`
     - `removePII(_ text: String) -> String`
   - Detection patterns:
     - Names (contact names)
     - Email addresses
     - Phone numbers
     - Addresses
     - Other identifiable information

3. Integrate into All AI Services
   - Update `buildPrompt()` method in all 12 AI services
   - Call PIISanitizer before sending to OpenAI/Replicate
   - Log sanitized prompts (privacy-safe) for compliance audits

4. Implement Automated Tests
   - Unit tests for PIISanitizer
   - Test cases: names, emails, phone numbers, addresses
   - Integration tests: Verify sanitization in AI generation flow

5. Documentation
   - Update privacy policy with sanitization process
   - Document PII detection patterns
   - Create developer guidelines for future AI features

**Files to Create/Modify:**
- Create: `ForavaApp/Utils/PIISanitizer.swift`
- Modify: All 12 AI service files (add sanitization call)
- Create: `ForavaAppTests/PIISanitizerTests.swift`
- Modify: `Resources/privacy-policy.html` (document sanitization)

**Dependencies:**
- Privacy team review of sanitization patterns
- Testing with real contact data (anonymized)

**Definition of Done:**
- [ ] PIISanitizer implemented with comprehensive detection
- [ ] All 12 AI services integrate sanitization
- [ ] Automated tests cover common PII patterns
- [ ] Privacy policy updated
- [ ] Manual testing: Generate AI images, verify no PII in prompts
- [ ] Code review by privacy team

---

## 🟠 P1: HIGH PRIORITY - REQUIRED FOR APPROVAL (Should Have)

### SAFETY-002: Complete UGC Moderation System
**Priority:** P1 (HIGH)
**Effort:** 5 developer days
**Owner:** Safety & Moderation Team
**Risk Level:** HIGH
**Rejection Probability:** 60% if incomplete

**Required Actions:**
1. Implement Content Reporting
   - Add "Report Inappropriate Content" button to all generated image views
   - Create `ReportContentView.swift` with reporting form
   - Capture: content being reported, reason, optional reporter contact
   - Backend: Email reports to support@forava.com (or moderation queue)

2. Enhance Content Filtering
   - Expand `validateCulturalElements()` in AI services
   - Add profanity filter (use library like Swift Profanity Checker)
   - Hate speech detection
   - Violence/gore keywords
   - Sexual content keywords

3. Add Contact Support to Settings
   - Modify `SettingsView.swift` around line 289
   - Add "Contact Support" menu item
   - Email link: mailto:support@forava.com
   - Test email functionality on real device

4. User Blocking (if applicable)
   - Determine if app has multi-user accounts
   - If yes: Implement user blocking for offensive content
   - If no (single-user): Blocking may not apply

**Files to Modify:**
- Create: `ForavaApp/Views/ReportContentView.swift`
- Modify: All 12 DesignView files (add report button)
- Modify: `ForavaApp/Services/BaseCulturalAIService.swift` (enhance filtering)
- Modify: `ForavaApp/Views/SettingsView.swift` (add contact support)

**Definition of Done:**
- [ ] Report button present in all AI generation UIs
- [ ] Reporting form captures necessary information
- [ ] Reports delivered to moderation team
- [ ] Enhanced content filtering operational
- [ ] Contact support easily accessible in Settings
- [ ] Response SLA documented (e.g., "24-48 hours")

---

### LEGAL-001: Privacy Policy App Store Connect Integration
**Priority:** P1 (HIGH)
**Effort:** 3 developer days
**Owner:** Legal + Product Team
**Risk Level:** HIGH
**Rejection Probability:** 40% if not linked

**Required Actions:**
1. Add Privacy Policy URL to App Store Connect
   - Upload privacy policy to accessible URL
   - Add URL to App Store Connect → App Privacy → Privacy Policy
   - Verify URL accessibility (test from various devices)

2. Verify In-App Privacy Policy Display
   - Check `SettingsView.swift` has privacy policy menu item
   - Verify privacy-policy.html loads correctly in WebView
   - Test on iOS 15, 16, 17

3. Update App Store Privacy Nutrition Labels
   - Review current labels in App Store Connect
   - Cross-reference with privacy-policy.html
   - Ensure labels match actual data collection:
     - Contact names (local only)
     - AI prompts (sent to OpenAI, no PII)
     - Preferences (local only)

4. Add Privacy Policy to Onboarding
   - Show privacy policy during first launch (optional but recommended)
   - "By continuing, you agree to our Terms & Privacy Policy"

**Files to Modify:**
- Verify: `ForavaApp/Resources/privacy-policy.html`
- Modify: `ForavaApp/Views/SettingsView.swift` (verify privacy link exists)
- Optional: `ForavaApp/Views/WelcomeView.swift` (add to onboarding)

**Definition of Done:**
- [ ] Privacy policy URL added to App Store Connect
- [ ] URL accessible from real devices
- [ ] Privacy nutrition labels accurate
- [ ] In-app privacy policy display verified
- [ ] Onboarding includes privacy policy (optional)

---

### LEGAL-002: Contact Handling Audit
**Priority:** P1 (HIGH)
**Effort:** 2 developer days
**Owner:** Engineering + Legal Team
**Risk Level:** HIGH
**Rejection Probability:** 35% if database building found

**Required Actions:**
1. Comprehensive Code Audit
   - Review `ContactSelectionView.swift` for contact handling
   - Verify contacts stored locally only (not transmitted)
   - Check for any database creation (SQLite, Core Data, etc.)
   - Confirm no contact export/sharing functionality

2. Verify No "Select All" Functionality
   - Search ContactSelectionView for "Select All" or bulk operations
   - Guideline prohibits: "Do not include a Select All option"
   - Ensure per-contact individual selection only

3. Add Compliance Comments
   - Add code comments documenting local-only storage
   - Document prohibition of database building
   - Reference guideline 5.1.1 in comments

4. Implement Automated Tests
   - Test to verify no network requests when accessing contacts
   - Test to ensure no database file creation
   - Test that contacts remain local-only

**Files to Audit:**
- `ForavaApp/Views/ContactSelectionView.swift`
- Any contact-related service files
- Network layer (verify no contact transmission)

**Definition of Done:**
- [ ] Code audit complete with findings documented
- [ ] No contact database building confirmed
- [ ] No "Select All" functionality confirmed
- [ ] Compliance comments added to code
- [ ] Automated tests prevent future violations

---

### PERFORMANCE-003: Age Rating Determination
**Priority:** P1 (HIGH - Dependency for SAFETY-003)
**Effort:** 2 developer days
**Owner:** Product + PerformanceAgent
**Risk Level:** MEDIUM
**Rejection Probability:** N/A (required for age gate)

**Required Actions:**
1. Complete Age Rating Questionnaire
   - App Store Connect → My Apps → App Information → Age Rating
   - Answer all questions considering:
     - Religious/cultural references (12 traditions)
     - AI-generated content unpredictability
     - Potential for mature themes
     - Contact access

2. Analyze Content for Maturity
   - Review all 12 cultural designs for intense imagery
   - Consider religious symbolism appropriateness
   - Evaluate AI content risk level

3. Determine Recommended Rating
   - **4+:** Unrestricted (NOT recommended - AI unpredictability)
   - **9+:** Mild religious themes (possible but risky)
   - **12+:** Moderate religious/cultural content ✅ RECOMMENDED
   - **17+:** Mature themes (likely too restrictive)

4. Document Rating Justification
   - Create `Age_Rating_Justification.md`
   - Explain rating choice
   - Document content analysis
   - Reference age gate implementation

**Deliverables:**
- Completed age rating questionnaire
- Age rating recommendation: 12+
- Justification document

**Definition of Done:**
- [ ] Age rating questionnaire completed in App Store Connect
- [ ] Rating selection: 12+ (recommended)
- [ ] Justification documented
- [ ] Communicated to SAFETY-003 (age gate) team

---

## 🟡 P2: MEDIUM PRIORITY - QUALITY IMPROVEMENTS (Could Have)

### SAFETY-004: Cultural Accuracy Validation
**Priority:** P2 (MEDIUM)
**Effort:** 5 days (advisory board coordination)
**Owner:** Product + Cultural Advisory Board

**Required Actions:**
1. Establish Cultural Advisory Board
   - Recruit representatives from 12 cultural traditions
   - Diverse perspectives (religious scholars, community leaders)

2. Review All Cultural Designs
   - Present 12 cultural designs for validation
   - Collect feedback on accuracy, sensitivity, appropriateness
   - Document validation results

3. Address Feedback
   - Implement any necessary corrections
   - Update cultural design elements
   - Re-validate after changes

---

### DESIGN-001: AI Content Moderation Enhancements
**Priority:** P2 (MEDIUM)
**Effort:** 3 developer days
**Owner:** AI Engineering

**Required Actions:**
1. Implement Post-Generation Moderation
   - After AI generates image, analyze for inappropriate content
   - Use OpenAI Moderation API or similar
   - Block display if content violates guidelines

2. Age-Appropriate Content Filtering
   - Different standards for different age groups
   - More restrictive for users under 17
   - Document filtering criteria

---

### PERFORMANCE-004: Payment Service Functional Testing
**Priority:** P2 (MEDIUM - Dependency on BUSINESS-001)
**Effort:** 2 developer days
**Owner:** QA + Payments Team

**Required Actions:**
1. End-to-End Subscription Testing
   - Purchase subscription flow
   - Renewal testing
   - Cancellation testing
   - Restore purchases

2. Re-generation IAP Testing (after BUSINESS-001)
   - Purchase consumable
   - Use credit
   - Multiple purchases
   - Edge cases (no internet, etc.)

---

## ⚪ P3: LOW PRIORITY - NICE TO HAVE (Won't Have in V1)

### SECURITY-001: Enhanced Data Security
**Priority:** P3 (LOW)
**Effort:** 3 developer days

**Actions:** Security audit, SSL pinning, penetration testing

---

### UI-001: Accessibility Improvements
**Priority:** P3 (LOW)
**Effort:** 2 developer days

**Actions:** VoiceOver support, Dynamic Type, color contrast audit

---

## Implementation Timeline

```
Week 1:
├─ BUSINESS-001 (Re-gen IAP) - Days 1-7
├─ LEGAL-004 (PII Sanitization) - Days 1-5
└─ PERFORMANCE-003 (Age Rating) - Days 1-2

Week 2:
├─ SAFETY-003 (Age Gate) - Days 8-12
├─ SAFETY-002 (UGC Moderation) - Days 8-12
└─ BUSINESS-001 (continued) - Days 8-14

Week 3:
├─ LEGAL-001 (Privacy Policy) - Days 15-17
├─ LEGAL-002 (Contact Audit) - Days 15-16
└─ PERFORMANCE-004 (Testing) - Days 18-19

Week 4:
├─ P2 items (if time permits)
└─ Final verification
```

---

## Progress Tracking

Use this checklist to track completion:

### CRITICAL (P0):
- [ ] BUSINESS-001: Re-generation IAP
- [ ] SAFETY-003: Age Gate
- [ ] LEGAL-004: PII Sanitization

### HIGH (P1):
- [ ] SAFETY-002: UGC Moderation
- [ ] LEGAL-001: Privacy Policy
- [ ] LEGAL-002: Contact Audit
- [ ] PERFORMANCE-003: Age Rating

### MEDIUM (P2):
- [ ] SAFETY-004: Cultural Validation
- [ ] DESIGN-001: AI Moderation
- [ ] PERFORMANCE-004: Payment Testing

---

**Next Update:** After Week 1 completion (re-assess priorities)
**Owner:** OrchestratorAgent (coordination)
**Reviewed By:** Project Manager + Engineering Lead
