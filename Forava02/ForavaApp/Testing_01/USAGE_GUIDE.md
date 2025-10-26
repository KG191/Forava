# Anniversary AI Testing Framework - Usage Guide

## 🚀 Quick Start

### Option 1: Full Automated Testing (Recommended)

Execute all 240 tests automatically overnight:

```swift
import SwiftUI

@main
struct TestRunnerApp: App {
    var body: some Scene {
        WindowGroup {
            TestingCoordinatorView()
        }
    }
}

struct TestingCoordinatorView: View {
    @StateObject private var testingAgent = AnniversaryTestingAgent()
    @StateObject private var optimizationAgent = AnniversaryPromptOptimizationAgent()

    @State private var testReport: AnniversaryTestingAgent.TestReport?
    @State private var optimizationReport: AnniversaryPromptOptimizationAgent.OptimizationReport?

    var body: some View {
        VStack(spacing: 20) {
            if testingAgent.isRunning {
                ProgressView(value: testingAgent.currentProgress)
                Text("Testing: \(testingAgent.currentTestID)")
                Text("Progress: \(testingAgent.completedTests)/\(testingAgent.totalTests)")
            } else {
                Button("Run Full Test Suite (240 tests)") {
                    Task {
                        await runFullTestingCycle()
                    }
                }
            }

            if let report = testReport {
                Text("Success Rate: \(String(format: "%.1f", report.successRate))%")
                    .font(.title)
            }
        }
        .padding()
    }

    private func runFullTestingCycle() async {
        do {
            // Phase 1: Execute all tests
            print("🧪 Starting Phase 1: Baseline Testing...")
            let report = try await testingAgent.executeTestSuite(
                configuration: .standard
            )
            testReport = report

            // Save test report
            try testingAgent.saveReportToFile(
                report: report,
                filename: "phase1_baseline_\(Date().ISO8601Format()).json"
            )

            // Phase 2: Optimize based on failures
            if report.successRate < 95.0 {
                print("\n🔧 Starting Phase 2: Prompt Optimization...")
                let optimization = try await optimizationAgent.optimizeFromTestReport(
                    report: report,
                    maxIterations: 3
                )
                optimizationReport = optimization

                print(optimization.summary)
            }

        } catch {
            print("❌ Error: \(error)")
        }
    }
}
```

---

### Option 2: Quick Testing (Critical Tests Only)

Run only Tier 1 + Tier 2 tests (~48 tests, ~28 minutes):

```swift
Task {
    let testingAgent = AnniversaryTestingAgent()
    let report = try await testingAgent.executeTestSuite(
        configuration: .quick  // Only T1 + T2
    )
    print(report.summary)
}
```

---

### Option 3: Manual Single Test

Test one specific combination manually:

```swift
// Create a test case
let testCase = AnniversaryTestSuite.TestCase(
    testID: "MANUAL-001",
    tier: .t1Baseline,
    theme: .romantic,
    giftOption: "Classic Love Letter Card",
    elements: [AnniversaryElement.centrePieces[0]],  // Hearts
    colorPalette: AnniversaryColorPalette.allPalettes[0],  // Classic Romance
    description: "Manual test",
    priority: .critical
)

// Generate image
let aiService = AnniversaryAIService.shared
let generatedURL = try await aiService.generateAnniversaryGift(
    theme: testCase.theme,
    giftOption: testCase.giftOption,
    elements: testCase.elements,
    colorPalette: testCase.colorPalette,
    message: "Test message",
    contactName: "Test User"
)

// Validate result
let result = await AnniversaryValidationCriteria.validate(
    testID: testCase.testID,
    theme: testCase.theme,
    giftOption: testCase.giftOption,
    elements: testCase.elements,
    colorPalette: testCase.colorPalette,
    generatedImageURL: generatedURL,
    promptUsed: "..."
)

print("Score: \(result.overallScore)/100")
print("Status: \(result.isPassing ? "✅ PASS" : "❌ FAIL")")
```

---

## 📊 Understanding Test Reports

### Test Report Structure

```json
{
  "timestamp": "2025-10-21T19:30:00Z",
  "totalTests": 240,
  "passingTests": 168,
  "failingTests": 72,
  "successRate": 70.0,
  "averageScores": {
    "themeFidelity": 78.5,
    "elementIntegration": 82.3,
    "colorConformance": 65.8,
    "technicalQuality": 91.2
  },
  "gapsByCategory": {
    "wrongColor": 45,
    "missingElement": 18,
    "themeMismatch": 9
  },
  "executionTime": 8400.0  // ~140 minutes
}
```

### Success Rate Interpretation

| Success Rate | Phase | Action Required |
|--------------|-------|-----------------|
| **95%+** | Production Ready | Deploy! |
| **85-94%** | Good | Minor optimizations |
| **70-84%** | Baseline | Major optimizations needed |
| **<70%** | Critical | Fundamental prompt issues |

### Score Breakdown

Each test receives 4 scores (0-100):

1. **Theme Fidelity (35% weight)**
   - Gift option elements present?
   - Theme aesthetic maintained?
   - Intuitive title-to-image match?
   - Appropriate symbolism?

2. **Element Integration (30% weight)**
   - Centre pieces prominent?
   - Supporting elements visible?
   - Hierarchy respected?
   - No elements missing?

3. **Color Conformance (25% weight)**
   - Primary dominates (~70%)?
   - Secondary present (~20%)?
   - Accent visible (~10%)?
   - NO unauthorized colors?

4. **Technical Quality (10% weight)**
   - NO text generated?
   - High clarity?
   - Good composition?
   - No artifacts?

**Overall Score = Weighted Average**
**Passing Threshold = 80/100**

---

## 🔧 Using the Optimization Agent

### Automatic Optimization

After baseline testing, run the optimization agent:

```swift
let optimizationAgent = AnniversaryPromptOptimizationAgent()
let optimization = try await optimizationAgent.optimizeFromTestReport(
    report: baselineReport,
    maxIterations: 3
)

print(optimization.summary)
```

### Optimization Report Output

```
🔧 PROMPT OPTIMIZATION REPORT
========================================

Original Success Rate: 70.0%

OPTIMIZATIONS PROPOSED: 6

ESTIMATED IMPACT:
-----------------
Critical Issues Addressed:  5
High Issues Addressed:      50
Medium Issues Addressed:    17

Estimated New Success Rate: 88.5%
Expected Improvement:       +18.5%

NEXT STEPS:
-----------
STEP 1: Apply ultra-aggressive text blocking (5 tests affected)
STEP 2: Apply enhanced color exclusion (45 tests affected)
STEP 3: Apply strengthen element descriptions (18 tests affected)
...
```

### Applying Optimizations

The agent provides specific fixes to apply to:

1. **AnniversaryModels.swift** - Gift option prompt mappings
2. **CulturalAIConfiguration.swift** - Template prompts, negative prompts
3. **BaseCulturalAIService.swift** - Model parameters (guidance_scale, etc.)

Example fix application:

```swift
// For "Wrong Color" issues:
// In CulturalAIConfiguration.swift:

static let guidanceScale = 11.0  // Increased from 9.5

static func colorExclusionNegativePrompt(...) -> String {
    var prompt = baseNegativePrompt
    prompt += ", wrong colors, wrong colors, wrong colors"  // 3x repetition
    prompt += ", " + forbiddenColors.joined(separator: ", ")
    return prompt
}
```

---

## 📁 File Locations

### Test Reports Saved To:
```
~/Documents/TestResults/
├── phase1_baseline_2025-10-21.json
├── phase2_optimized_2025-10-21.json
└── images/
    ├── T1-ROM-001.png
    ├── T2-MIL-003.png
    └── ...
```

### Test Files:
```
ForavaApp/Testing/
├── AnniversaryValidationCriteria.swift  # Scoring system
├── AnniversaryTestSuite.swift           # 240 test definitions
├── AnniversaryTestingAgent.swift        # Automated testing
├── AnniversaryPromptOptimizationAgent.swift  # Optimization
├── IMPLEMENTATION_SUMMARY.md            # Technical docs
└── USAGE_GUIDE.md                       # This file
```

---

## 🎯 Test Execution Timeline

### Full Test Suite (240 tests)

```
Start Time: 8:00 PM
├─ T1 Baseline: 8:00 - 8:10 PM (16 tests × 35 sec = ~9 min)
├─ T2 Gift Options: 8:10 - 8:30 PM (32 tests × 35 sec = ~19 min)
├─ T3 Elements: 8:30 - 9:00 PM (51 tests × 35 sec = ~30 min)
├─ T4 Colors: 9:00 - 9:20 PM (32 tests × 35 sec = ~19 min)
├─ T5 Integration: 9:20 - 9:50 PM (50 tests × 35 sec = ~29 min)
├─ T6 Edge Cases: 9:50 - 10:05 PM (25 tests × 35 sec = ~15 min)
└─ T7 User Journey: 10:05 - 10:25 PM (34 tests × 35 sec = ~20 min)
End Time: ~10:25 PM (2 hours 25 minutes)
```

**Pro Tip:** Start testing before bed, review results in the morning!

---

## 🚨 Troubleshooting

### Issue: Tests Taking Too Long

**Solution:** Use `.quick` configuration for faster iteration:
```swift
let report = try await testingAgent.executeTestSuite(
    configuration: .quick  // ~28 minutes instead of 140
)
```

### Issue: API Rate Limits

**Solution:** Increase delay between tests:
```swift
let customConfig = TestingConfiguration(
    enableImageAnalysis: false,
    saveGeneratedImages: true,
    delayBetweenTests: 5.0,  // 5 seconds instead of 2
    maxConcurrentTests: 1,
    testTiers: .allCases
)
```

### Issue: Out of Memory

**Solution:** Disable image saving:
```swift
let customConfig = TestingConfiguration(
    enableImageAnalysis: false,
    saveGeneratedImages: false,  // Don't save images
    delayBetweenTests: 2.0,
    maxConcurrentTests: 1,
    testTiers: .allCases
)
```

### Issue: Testing Agent Crashes

**Solution:** Check API key configuration:
```swift
let aiService = AnniversaryAIService.shared
print("API Key Status: \(aiService.apiKeyStatus)")
```

---

## 📈 Expected Results by Phase

### Phase 1: Baseline Testing (Current)
- **Success Rate:** 70-75%
- **Top Issues:**
  - Color conformance (primary not dominating)
  - Some elements missing or weak
  - Occasional theme mismatches
- **Action:** Run optimization agent

### Phase 2: After Optimization
- **Success Rate:** 85-90%
- **Improvements:**
  - Better element visibility
  - Stronger color adherence
  - Improved gift option matching
- **Action:** Re-test problem areas

### Phase 3: After Color Fixes
- **Success Rate:** 90-92%
- **Achievement:** 100% color conformance
- **Action:** Polish remaining issues

### Phase 4: Production Ready
- **Success Rate:** 95%+
- **Quality Gates Met:**
  - ✅ 100% gift option fidelity
  - ✅ 100% color conformance
  - ✅ 95% element integration
  - ✅ 0% text generation

---

## 🎓 Advanced Usage

### Custom Test Subset

Test only specific scenarios:

```swift
// Create custom test list
let customTests = [
    // Test all romantic gift options
    ...AnniversaryTestSuite.generateFullTestSuite()
        .filter { $0.theme == .romantic }
]

// Execute custom tests
for testCase in customTests {
    // Run test...
}
```

### Parallel Testing (Experimental)

**NOT RECOMMENDED** - May hit API rate limits:

```swift
let customConfig = TestingConfiguration(
    enableImageAnalysis: false,
    saveGeneratedImages: true,
    delayBetweenTests: 0.5,
    maxConcurrentTests: 3,  // Run 3 tests simultaneously
    testTiers: .allCases
)
```

### Integration with CI/CD

```swift
// In your CI pipeline
func runCITests() async throws {
    let agent = AnniversaryTestingAgent()
    let report = try await agent.executeTestSuite(configuration: .quick)

    // Fail CI if success rate drops below threshold
    guard report.successRate >= 90.0 else {
        throw TestingError.qualityThresholdNotMet
    }
}
```

---

## 📞 Support

### Questions?

- Review `IMPLEMENTATION_SUMMARY.md` for technical details
- Check test reports in `~/Documents/TestResults/`
- Review gap analysis for specific failure reasons

### Contributing Improvements

To add new test scenarios:

1. Add test case to `AnniversaryTestSuite.swift`
2. Update tier definitions if needed
3. Re-run test suite
4. Update documentation

---

## ✅ Pre-Flight Checklist

Before running full test suite:

- [ ] API key configured (`REPLICATE_API_TOKEN` set)
- [ ] Sufficient API credits (~$50 for 240 tests)
- [ ] Disk space available (~500MB for images)
- [ ] Time allocated (2-3 hours for full suite)
- [ ] Network stable (long-running process)
- [ ] Device won't sleep (disable auto-sleep)

---

## 🎉 You're Ready!

**To begin automated testing:**

```swift
let testingAgent = AnniversaryTestingAgent()

Task {
    let report = try await testingAgent.executeTestSuite(
        configuration: .standard  // Full 240 tests
    )

    print(report.summary)
    try testingAgent.saveReportToFile(report: report)
}
```

**Expected completion:** ~2.5 hours
**Next morning:** Review test report and optimization recommendations!

---

*Last Updated: October 21, 2025*
*Version: 1.0.0*
