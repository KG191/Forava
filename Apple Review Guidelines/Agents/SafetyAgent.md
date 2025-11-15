# SafetyAgent Specification
## Apple App Store Review Guidelines - Section 1: SAFETY

**Agent ID:** SAFETY-AGENT-001
**Guideline Section:** 1.0 Safety
**Priority:** HIGH
**Status:** Active Audit Required

---

## Agent Role & Responsibilities

**Specialist Focus:** Content safety, user-generated content moderation, cultural sensitivity, age appropriateness, developer information, data security

**Primary Objective:** Ensure Forava complies with all Apple safety guidelines, particularly around cultural/religious content accuracy, AI-generated user content moderation, and age-appropriate content restrictions.

**Reporting To:** OrchestratorAgent

---

## Input Requirements

### Files to Audit:
1. **AI Service Files:**
   - `ForavaApp/Services/BaseCultural

AIService.swift`
   - `ForavaApp/Services/AnniversaryAIService.swift`
   - `ForavaApp/Services/ChineseNewYearAIService.swift`
   - `ForavaApp/Services/ChristmasAIService.swift`
   - `ForavaApp/Services/DiwaliAIService.swift`
   - `ForavaApp/Services/EasterAIService.swift`
   - `ForavaApp/Services/EidAlAdhaAIService.swift`
   - `ForavaApp/Services/HanukkahAIService.swift`
   - `ForavaApp/Services/HoliAIService.swift`
   - `ForavaApp/Services/MidAutumnFestivalAIService.swift`
   - `ForavaApp/Services/RakshaBandhanAIService.swift`
   - `ForavaApp/Services/RoshHashanahAIService.swift`
   - `ForavaApp/Services/VesakDayAIService.swift`

2. **Cultural Models:**
   - All 12 cultural design model files (`*Models.swift`)
   - Cultural validation logic (if separate file exists)

3. **UI/UX Files:**
   - All DesignView files (12 cultural designs)
   - `ForavaApp/Views/SettingsView.swift` (for contact information)
   - Any content reporting UI (if exists)

4. **Data Security:**
   - API configuration files
   - Keychain usage implementations
   - Network request handling code

### External Resources:
- Privacy policy (privacy-policy.html)
- Terms of use (terms-of-use.html)
- Cultural advisory board documentation (if exists)
- Expert validation records (if exists)

---

## Comprehensive Audit Checklist

### ✅ 1.1.4 - Religious Content Accuracy
**Guideline:** *"Apps referencing religious text that is inaccurate or misleading are rejected"*

**Forava Application:** 12 cultural/religious events including:
- Hindu: Diwali, Holi, Raksha Bandhan
- Islamic: Eid al-Adha, Eid al-Fitri
- Christian: Christmas, Easter
- Jewish: Rosh Hashanah, Hanukkah
- Buddhist: Vesak Day
- Chinese: Chinese New Year, Mid-Autumn Festival
- Universal: Anniversaries

**Audit Tasks:**
- [ ] Review all 12 cultural design models for religious symbolism accuracy
- [ ] Verify cultural scoring system (`calculateCulturalScore` if exists) has appropriate criteria
- [ ] Check AI service prompts for culturally sensitive language
- [ ] Validate that no religious text is quoted or referenced inaccurately
- [ ] Confirm cultural design elements (colors, symbols, imagery) are culturally appropriate
- [ ] Review user-facing descriptions of cultural events for accuracy

**Evidence to Collect:**
- [ ] Screenshots of cultural designs for all 12 events
- [ ] Cultural validation process documentation
- [ ] Expert review records (if available)
- [ ] AI prompt templates for each culture

**Risk Assessment:**
- **Current Status:** REQUIRES_VERIFICATION
- **Risk Level:** MEDIUM
- **Rejection Probability:** 30% (if inaccuracies found)
- **Mitigation:** Cultural advisory board review, expert validation

**Action Items if Non-Compliant:**
1. Establish cultural advisory board with representatives from each tradition
2. Document cultural validation process
3. Create cultural accuracy review checklist
4. Implement user reporting for cultural inaccuracies
5. Add cultural sensitivity disclaimer in app

---

### ✅ 1.2.1 - User-Generated Content (UGC) Moderation
**Guideline:** *"Apps with user-generated content must include: (a) method for filtering objectionable material, (b) mechanism to report offensive content and timely responses, (c) ability to block abusive users, (d) published contact information"*

**Forava Application:** AI prompts are user-generated content requiring full moderation system

**Audit Tasks:**

#### (a) Filtering Objectionable Material
- [ ] Locate content filtering implementation (e.g., `validateCulturalElements()`)
- [ ] Test filtering against objectionable categories:
  - [ ] Profanity/vulgar language
  - [ ] Hate speech
  - [ ] Violence/gore
  - [ ] Sexual content
  - [ ] Dangerous activities
  - [ ] Illegal content
  - [ ] Harassment/bullying
- [ ] Verify filtering occurs BEFORE AI generation (not just after)
- [ ] Check if filtered prompts are logged for moderation review
- [ ] Validate user notification when content is filtered

**Current Status:** PARTIAL - Basic filtering exists but incomplete

#### (b) Reporting Mechanism
- [ ] Search codebase for "Report" functionality
- [ ] Verify reporting button accessible from AI generation UI
- [ ] Check reporting flow captures:
  - [ ] Content being reported
  - [ ] Reason for report
  - [ ] Reporter contact (if not anonymous)
- [ ] Verify timely response commitment (e.g., "reviewed within 24 hours")
- [ ] Check moderation workflow documentation

**Current Status:** NON_COMPLIANT - No reporting mechanism found

#### (c) User Blocking Capability
- [ ] Determine if app has multi-user accounts (or single-user)
- [ ] If multi-user: Verify ability to block offensive users
- [ ] If single-user: Verify ability to block/report offensive AI generations
- [ ] Check if blocking prevents future interactions

**Current Status:** NON_COMPLIANT - No blocking capability found (may not apply if single-user)

#### (d) Published Contact Information
- [ ] Verify support@forava.com easily accessible in-app
- [ ] Check SettingsView.swift for "Contact Support" or "Help" section
- [ ] Confirm contact method functional (test email delivery)
- [ ] Validate contact info also in privacy policy
- [ ] Check App Store Connect listing has developer contact

**Current Status:** PARTIAL - Email in privacy policy but in-app accessibility unclear

**Evidence to Collect:**
- [ ] Screenshot of content filtering in action
- [ ] Test report of filtering profanity/offensive content
- [ ] Screenshots of reporting UI (or note absence)
- [ ] Screenshot of contact information in Settings
- [ ] Email delivery test confirmation

**Risk Assessment:**
- **Current Status:** NON_COMPLIANT
- **Risk Level:** CRITICAL
- **Rejection Probability:** 85% (missing required components)
- **Mitigation:** Immediate implementation of missing features

**Action Items:**
1. **URGENT:** Implement content reporting button in AI generation UI
2. Add "Report Inappropriate Content" to all generated image views
3. Create moderation backend/workflow (or manual process)
4. Add "Contact Support" prominently to SettingsView (line ~290)
5. Document content moderation response SLA (recommend: 24-48 hours)
6. Create moderation team training materials
7. Implement content flagging system
8. Add automated profanity filter to prompt validation

**Estimated Effort:** 3-5 developer days + moderation process setup

---

### ✅ 1.2.1 - Creator Content Age Gating (CRITICAL)
**Guideline:** *"Apps that feature...creator content (such as video apps, AI prompt apps, music composition apps)...must...restrict underage users' access to age-inappropriate content by using an age gate or age verification mechanism based on verified or declared age"*

**Forava Application:** AI-generated cultural designs qualify as "creator content" - users create via prompts, AI generates unpredictable output

**Audit Tasks:**
- [ ] Determine app's age rating (coordinate with PerformanceAgent)
- [ ] Identify content that may exceed app's age rating:
  - [ ] Religious imagery (may be intense for young children)
  - [ ] Cultural symbolism (some cultures have mature themes)
  - [ ] AI unpredictability (could generate unexpected content)
- [ ] Verify age verification mechanism exists (likely MISSING)
- [ ] Check if age gate restricts:
  - [ ] AI generation feature
  - [ ] Viewing generated content
  - [ ] Sharing capabilities
- [ ] Validate age verification is "verified or declared":
  - Verified: Government ID, payment method, third-party service
  - Declared: User inputs birthdate
- [ ] Check if age is stored and enforced persistently

**Current Status:** NON_COMPLIANT - No age verification found in codebase

**Evidence to Collect:**
- [ ] Age rating determination document (from PerformanceAgent)
- [ ] Examples of content exceeding app rating (if any)
- [ ] Age gate UI mockup/screenshot (when implemented)
- [ ] Age verification flow test results

**Risk Assessment:**
- **Current Status:** NON_COMPLIANT
- **Risk Level:** CRITICAL
- **Rejection Probability:** 90% (explicit requirement for AI apps)
- **Mitigation:** Implement before submission (BLOCKING)

**Action Items:**
1. **URGENT:** Determine minimum age rating for app (collaborate with PerformanceAgent)
2. **URGENT:** Implement age gate for AI generation feature
3. Choose age verification method:
   - **Option A (Declared):** User inputs birthdate during onboarding
   - **Option B (Verified):** Third-party age verification service
   - **RECOMMENDED:** Option A for first version (simpler, Apple-compliant)
4. Implement age gate UI:
   - Shown before first AI generation
   - Requests birthdate
   - Stores age verification status locally
   - Restricts access if under minimum age
5. Add age restriction notice to app description
6. Test with various age inputs
7. Document age verification process

**Estimated Effort:** 5-7 developer days

**Dependencies:**
- Age rating determination (PerformanceAgent PERFORMANCE-003)

---

### ✅ 1.5.1 - Developer Contact Information
**Guideline:** *"Apps must include easily accessible contact information"*

**Forava Application:** support@forava.com mentioned in privacy policy

**Audit Tasks:**
- [ ] Verify contact info in SettingsView.swift (around line 290)
- [ ] Check if "Contact Support" or "Help" menu item exists
- [ ] Confirm email link opens default mail client
- [ ] Validate contact info also in:
  - [ ] App Store Connect listing
  - [ ] Privacy policy
  - [ ] Terms of Use
- [ ] Test email delivery (send test support email)
- [ ] Verify contact is monitored (someone reads support emails)

**Current Status:** PARTIAL - Email exists but in-app accessibility unclear

**Evidence to Collect:**
- [ ] Screenshot of contact info in Settings
- [ ] Screenshot of App Store Connect contact field
- [ ] Test email delivery confirmation
- [ ] Support response time commitment

**Risk Assessment:**
- **Current Status:** PARTIAL_COMPLIANCE
- **Risk Level:** LOW
- **Rejection Probability:** 10% (if not easily accessible)
- **Mitigation:** Add to Settings prominently

**Action Items:**
1. Add "Contact Support" to SettingsView.swift (around line 289, near "Support" row)
2. Verify support@forava.com is monitored
3. Create support response process (target: 24-48 hour response)
4. Add contact info to onboarding/help screen
5. Test email functionality on real device

**Estimated Effort:** 1 developer day

---

### ✅ 1.6 - Data Security
**Guideline:** *"Apps must implement appropriate security measures to ensure proper handling of user information and prevent unauthorized use"*

**Forava Application:** AI prompts sent to OpenAI/Replicate, contact data stored locally, API keys in keychain

**Audit Tasks:**
- [ ] Verify all API calls use HTTPS (not HTTP)
- [ ] Check SSL certificate pinning (optional but recommended)
- [ ] Audit keychain usage for API key storage
- [ ] Verify no API keys hardcoded in source code
- [ ] Check local storage encryption:
  - [ ] Contact names encrypted at rest
  - [ ] Generated images encrypted at rest
  - [ ] User preferences encrypted
- [ ] Validate data transmission security:
  - [ ] AI prompts sent over secure channel
  - [ ] Images returned over secure channel
  - [ ] No man-in-the-middle vulnerability
- [ ] Review third-party service security:
  - [ ] OpenAI API security compliance
  - [ ] Replicate API security compliance
- [ ] Check for common vulnerabilities:
  - [ ] SQL injection (if using database)
  - [ ] XSS attacks (if displaying user content)
  - [ ] CSRF tokens (if web views)

**Current Status:** REQUIRES_VERIFICATION

**Evidence to Collect:**
- [ ] Network traffic analysis (Wireshark/Charles Proxy)
- [ ] Keychain audit results
- [ ] Code review for hardcoded secrets
- [ ] Third-party security certifications (OpenAI, Replicate)

**Risk Assessment:**
- **Current Status:** LIKELY_COMPLIANT (but needs verification)
- **Risk Level:** MEDIUM
- **Rejection Probability:** 20% (if vulnerabilities found)
- **Mitigation:** Security audit, penetration testing

**Action Items:**
1. Conduct security audit of API calls
2. Verify HTTPS for all external requests
3. Audit keychain implementation for API keys
4. Scan codebase for hardcoded secrets (use tool like `git-secrets`)
5. Consider SSL certificate pinning for production
6. Document security measures for App Review
7. Third-party security certification collection (OpenAI/Replicate SOC 2)

**Estimated Effort:** 2-3 developer days

---

## Output Deliverables

### 1. Safety Compliance Report (5-10 pages)
**Filename:** `Safety_Compliance_Report.pdf`

**Contents:**
- Executive Summary
  - Overall safety compliance score: X/100
  - Critical issues: X
  - High priority issues: X
  - Compliance status: READY / NOT READY
- Detailed Findings
  - 1.1.4 Religious Content: Status, evidence, recommendations
  - 1.2.1 UGC Moderation: Status, gaps, action items
  - 1.2.1 Creator Age Gating: Status, implementation plan
  - 1.5.1 Contact Info: Status, accessibility verification
  - 1.6 Data Security: Status, vulnerabilities (if any)
- Risk Assessment
  - Rejection probability by issue
  - Mitigation strategies
  - Timeline estimates
- Evidence Appendix
  - Screenshots
  - Test results
  - Code snippets

### 2. Cultural Accuracy Validation Matrix
**Filename:** `Cultural_Accuracy_Matrix.xlsx`

**Format:** Spreadsheet with columns:
| Culture | Religious Symbols | Color Accuracy | Cultural Sensitivity | Expert Review | Status |
|---------|-------------------|----------------|----------------------|---------------|--------|
| Diwali | Diya, Rangoli, Om | Orange/Purple/Gold | Verified | Pending | PARTIAL |
| ... | ... | ... | ... | ... | ... |

### 3. Content Moderation Gap Analysis
**Filename:** `UGC_Moderation_Gaps.md`

**Contents:**
- Current State Assessment
  - What exists: Basic filtering
  - What's missing: Reporting, blocking, contact accessibility
- Required Components Breakdown
  - Filtering system (a): Status, gaps, recommendations
  - Reporting mechanism (b): Design, implementation plan
  - User blocking (c): Applicability, implementation (if needed)
  - Contact information (d): Current state, improvements needed
- Implementation Roadmap
  - Phase 1: Critical gaps (reporting, contact)
  - Phase 2: Enhanced filtering
  - Phase 3: Advanced moderation features

### 4. Age Rating Recommendation Document
**Filename:** `Age_Rating_Analysis.md`

**Contents:**
- Content Analysis
  - Religious/cultural imagery intensity
  - AI content unpredictability
  - Potential for mature themes
- Age Rating Options
  - 4+: Unrestricted (likely NOT appropriate due to AI)
  - 9+: Mild religious themes
  - 12+: Moderate religious/cultural content (RECOMMENDED)
  - 17+: Mature themes (likely too restrictive)
- Recommendation: **12+ Rating**
  - Reasoning: Religious imagery, AI unpredictability, cultural maturity
  - Age gate requirement: Yes (for AI generation)
  - Implementation: Birthdate verification during onboarding

### 5. Risk-Ranked Action Items
**Filename:** `Safety_Action_Items.md`

**Format:**
```markdown
## CRITICAL (Blocking Submission)
1. [SAFETY-003] Implement Age Gate for AI Content
   - Priority: P0 (Blocking)
   - Effort: 5-7 days
   - Owner: Product + Engineering
   - Deadline: Before submission

## HIGH (Required for Approval)
2. [SAFETY-002] Implement UGC Moderation System
   - Priority: P1
   - Effort: 3-5 days
   - Owner: Safety Team
   - Deadline: Before submission

...
```

---

## Risk Assessment Criteria

### CRITICAL Risk Indicators:
- Missing age gate for AI content (1.2.1 Creator Content)
- No UGC moderation system (1.2.1 requirements)
- Inaccurate religious content (1.1.4)
- Data security vulnerabilities (1.6)
- Contact information not accessible (1.5.1)

### HIGH Risk Indicators:
- Incomplete content filtering (1.2.1a)
- No reporting mechanism (1.2.1b)
- Cultural inaccuracies in designs
- Weak AI prompt validation

### MEDIUM Risk Indicators:
- Cultural sensitivity concerns (not inaccurate but potentially insensitive)
- Contact info in privacy policy but not prominently in-app
- Minor security improvements needed

### LOW Risk Indicators:
- Documentation gaps
- Cultural validation process not formalized
- User education about cultural content could be improved

---

## Integration Points with Other Agents

### Dependencies FROM Other Agents:
1. **PerformanceAgent:**
   - Age rating determination (needed for 1.2.1 age gate)
   - App Store metadata validation

2. **LegalAgent:**
   - Privacy policy verification (contact info, data handling)
   - Third-party service compliance (OpenAI/Replicate TOS)

3. **DesignAgent:**
   - AI content moderation requirements (4.7)
   - User reporting UI implementation

### Dependencies TO Other Agents:
1. **PerformanceAgent:**
   - Age rating recommendation impacts metadata
   - Content filtering may affect app description

2. **LegalAgent:**
   - UGC moderation informs privacy policy requirements
   - Contact info requirements cross-reference with 5.1.1

3. **DesignAgent:**
   - Age gate UI requirements
   - Content reporting UI specifications

---

## Timeline & Effort Estimates

### Critical Path Items:
1. **Age Gate Implementation:** 5-7 developer days (BLOCKING)
2. **UGC Moderation System:** 3-5 developer days (HIGH)
3. **Contact Info Accessibility:** 1 developer day (MEDIUM)
4. **Data Security Audit:** 2-3 developer days (MEDIUM)
5. **Cultural Accuracy Review:** 3-5 days (advisory board) (MEDIUM)

**Total Estimated Effort:** 14-21 developer days + cultural advisory time

**Recommended Timeline:**
- **Week 1:** Age gate implementation + UGC moderation start
- **Week 2:** Complete UGC moderation + security audit
- **Week 3:** Cultural accuracy review + contact info fixes + final verification

---

## Success Criteria

**SafetyAgent audit is COMPLETE when:**
- [ ] All 5 checklist items reviewed and documented
- [ ] Safety Compliance Report generated
- [ ] Cultural Accuracy Matrix populated for all 12 cultures
- [ ] Content Moderation Gap Analysis completed
- [ ] Age Rating Recommendation finalized (coordinated with PerformanceAgent)
- [ ] Risk-Ranked Action Items delivered to development team
- [ ] All CRITICAL issues have mitigation plans
- [ ] Evidence collected for all compliance areas
- [ ] Integration points communicated to OrchestratorAgent

**Submission-Ready Criteria:**
- [ ] Age gate implemented and tested
- [ ] UGC moderation system functional (filtering, reporting, contact)
- [ ] Contact information easily accessible in-app
- [ ] Data security audit passed (no critical vulnerabilities)
- [ ] Cultural accuracy validated (no inaccuracies found)

---

## Notes & Recommendations

### Key Insights:
1. **Age Gate is NON-NEGOTIABLE:** Apple explicitly requires this for AI "creator content" apps. This is a new guideline (2024) that many developers miss.

2. **UGC Moderation is Comprehensive:** All 4 components (filtering, reporting, blocking, contact) must be present. Partial implementation will result in rejection.

3. **Cultural Sensitivity is High-Risk:** 12 cultural/religious events means high scrutiny. One inaccuracy could result in rejection + negative press.

4. **AI Unpredictability Requires Extra Safeguards:** Even with filtering, AI can generate unexpected content. Age gate + robust moderation are essential.

### Recommendations:
1. Prioritize age gate implementation (BLOCKING issue)
2. Establish cultural advisory board ASAP
3. Implement "Report" button as minimum viable moderation
4. Consider third-party content moderation API (e.g., OpenAI Moderation API)
5. Document all safety measures for App Review response

---

**Last Updated:** 2025-11-15
**Agent Version:** 1.0
**Reviewed By:** OrchestratorAgent
**Status:** Ready for Deployment
