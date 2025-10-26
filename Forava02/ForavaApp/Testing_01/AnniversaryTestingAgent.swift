import Foundation
import SwiftUI

/// Automated Testing Agent - Executes all 240 Anniversary AI generation tests
/// and generates comprehensive validation reports
@MainActor
class AnniversaryTestingAgent: ObservableObject {

    // MARK: - Published Properties

    @Published var isRunning = false
    @Published var currentProgress: Double = 0.0
    @Published var currentTestID: String = ""
    @Published var completedTests: Int = 0
    @Published var totalTests: Int = 0
    @Published var currentPhase: String = "Idle"

    // MARK: - Test Results

    private var testResults: [AnniversaryValidationCriteria.ValidationResult] = []
    private var startTime: Date?
    private var endTime: Date?

    // MARK: - Configuration

    struct TestingConfiguration {
        let enableImageAnalysis: Bool  // Set to false for initial testing without Vision API
        let saveGeneratedImages: Bool
        let delayBetweenTests: TimeInterval  // To avoid API rate limits
        let maxConcurrentTests: Int
        let testTiers: [AnniversaryTestSuite.TestCase.TestTier]  // Which tiers to run

        static let standard = TestingConfiguration(
            enableImageAnalysis: false,  // Placeholder scoring for now
            saveGeneratedImages: true,
            delayBetweenTests: 2.0,  // 2 second delay between tests
            maxConcurrentTests: 1,  // Sequential execution
            testTiers: AnniversaryTestSuite.TestCase.TestTier.allCases
        )

        static let quick = TestingConfiguration(
            enableImageAnalysis: false,
            saveGeneratedImages: false,
            delayBetweenTests: 1.0,
            maxConcurrentTests: 1,
            testTiers: [.t1Baseline, .t2GiftVariations]  // Only critical tests
        )

        static let full = TestingConfiguration(
            enableImageAnalysis: true,  // Enable when Vision API integrated
            saveGeneratedImages: true,
            delayBetweenTests: 3.0,
            maxConcurrentTests: 1,
            testTiers: AnniversaryTestSuite.TestCase.TestTier.allCases
        )
    }

    // MARK: - Main Test Execution

    /// Execute complete test suite with specified configuration
    func executeTestSuite(configuration: TestingConfiguration = .standard) async throws -> TestReport {
        guard !isRunning else {
            throw TestingError.alreadyRunning
        }

        isRunning = true
        startTime = Date()
        testResults = []

        defer {
            isRunning = false
            endTime = Date()
        }

        // Load test suite
        currentPhase = "Loading test suite..."
        let fullTestSuite = AnniversaryTestSuite.generateFullTestSuite()

        // Filter tests by configured tiers
        let filteredTests = fullTestSuite.filter { configuration.testTiers.contains($0.tier) }
        totalTests = filteredTests.count

        print("🧪 TESTING AGENT STARTED")
        print("=" + String(repeating: "=", count: 79))
        print("Total Tests to Execute: \(totalTests)")
        print("Configuration: \(configuration.enableImageAnalysis ? "Full Analysis" : "Placeholder Scoring")")
        print("=" + String(repeating: "=", count: 79))

        // Execute tests sequentially
        for (index, testCase) in filteredTests.enumerated() {
            currentPhase = "Executing \(testCase.tier.rawValue)"
            currentTestID = testCase.testID
            completedTests = index
            currentProgress = Double(index) / Double(totalTests)

            print("\n[\(index + 1)/\(totalTests)] Testing: \(testCase.testID)")
            print("  Theme: \(testCase.theme.rawValue)")
            print("  Gift: \(testCase.giftOption)")
            print("  Elements: \(testCase.elements.map { $0.name }.joined(separator: ", "))")
            print("  Color: \(testCase.colorPalette.name)")

            do {
                // Execute single test
                let result = try await executeSingleTest(testCase: testCase, configuration: configuration)
                testResults.append(result)

                // Log result
                let status = result.isPassing ? "✅ PASS" : "❌ FAIL"
                print("  Result: \(status) - Score: \(String(format: "%.1f", result.overallScore))/100")

                if !result.isPassing {
                    print("  Gaps: \(result.gaps.count) issues found")
                    for gap in result.gaps.prefix(3) {
                        print("    - [\(gap.severity.rawValue)] \(gap.category.rawValue)")
                    }
                }

                // Delay between tests to avoid rate limiting
                if index < filteredTests.count - 1 {
                    try await Task.sleep(nanoseconds: UInt64(configuration.delayBetweenTests * 1_000_000_000))
                }

            } catch {
                print("  ❌ ERROR: \(error.localizedDescription)")

                // Create failed result
                let failedResult = createFailedResult(
                    testCase: testCase,
                    error: error
                )
                testResults.append(failedResult)
            }
        }

        completedTests = totalTests
        currentProgress = 1.0
        currentPhase = "Generating report..."

        // Generate comprehensive report
        let report = generateTestReport()

        print("\n" + String(repeating: "=", count: 79))
        print("🎉 TESTING COMPLETE")
        print("=" + String(repeating: "=", count: 79))
        print(report.summary)
        print("=" + String(repeating: "=", count: 79))

        return report
    }

    // MARK: - Single Test Execution

    /// Execute a single test case
    private func executeSingleTest(
        testCase: AnniversaryTestSuite.TestCase,
        configuration: TestingConfiguration
    ) async throws -> AnniversaryValidationCriteria.ValidationResult {

        // Step 1: Generate image using AI service
        let generatedImageURL: String?
        let promptUsed: String

        do {
            // Create a test contact for generation
            let testContact = Contact(
                id: UUID().uuidString,
                name: "Test Contact",
                phoneNumber: "+1234567890",
                email: "test@example.com"
            )

            // Generate the anniversary gift image
            let aiService = AnniversaryAIService.shared
            generatedImageURL = try await aiService.generateAnniversaryGift(
                theme: testCase.theme,
                giftOption: testCase.giftOption,
                elements: testCase.elements,
                colorPalette: testCase.colorPalette,
                message: "Test message for validation",
                contactName: testContact.name,
                format: .iPhone
            )

            // Capture the prompt that was used (for analysis)
            let designSpec = AnniversaryDesignSpec(
                theme: testCase.theme,
                giftOption: testCase.giftOption,
                elements: testCase.elements,
                colorPalette: testCase.colorPalette,
                message: "Test message",
                contactName: testContact.name
            )
            promptUsed = aiService.createCulturalPrompt(from: designSpec)

        } catch {
            throw TestingError.generationFailed(testCase.testID, error)
        }

        // Step 2: Save generated image if configured
        if configuration.saveGeneratedImages, let imageURL = generatedImageURL {
            try await saveGeneratedImage(url: imageURL, testID: testCase.testID)
        }

        // Step 3: Validate the generated image
        let validationResult = await AnniversaryValidationCriteria.validate(
            testID: testCase.testID,
            theme: testCase.theme,
            giftOption: testCase.giftOption,
            elements: testCase.elements,
            colorPalette: testCase.colorPalette,
            generatedImageURL: generatedImageURL,
            promptUsed: promptUsed
        )

        return validationResult
    }

    // MARK: - Image Management

    /// Save generated image for later analysis
    private func saveGeneratedImage(url: String, testID: String) async throws {
        // Create results directory if it doesn't exist
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let resultsPath = documentsPath.appendingPathComponent("TestResults/images")

        try fileManager.createDirectory(at: resultsPath, withIntermediateDirectories: true)

        // Download and save image
        if let imageURL = URL(string: url) {
            let (imageData, _) = try await URLSession.shared.data(from: imageURL)
            let imagePath = resultsPath.appendingPathComponent("\(testID).png")
            try imageData.write(to: imagePath)
            print("  💾 Saved image: \(imagePath.lastPathComponent)")
        }
    }

    // MARK: - Error Handling

    /// Create a failed result for tests that couldn't execute
    private func createFailedResult(
        testCase: AnniversaryTestSuite.TestCase,
        error: Error
    ) -> AnniversaryValidationCriteria.ValidationResult {

        let gap = AnniversaryValidationCriteria.ValidationGap(
            gapID: "GAP-\(testCase.testID)-ERROR",
            category: .lowQuality,
            severity: .critical,
            criterion: "Test Execution",
            actualScore: 0,
            expectedScore: 80,
            description: "Test failed to execute: \(error.localizedDescription)",
            promptSection: "N/A",
            hypothesis: "API error, network issue, or configuration problem",
            proposedFix: "Check API credentials, network connectivity, and service availability"
        )

        return AnniversaryValidationCriteria.ValidationResult(
            testID: testCase.testID,
            timestamp: Date(),
            themeFidelityScore: 0,
            elementIntegrationScore: 0,
            colorConformanceScore: 0,
            technicalQualityScore: 0,
            gaps: [gap],
            theme: testCase.theme,
            giftOption: testCase.giftOption,
            elements: testCase.elements,
            colorPalette: testCase.colorPalette,
            generatedImageURL: nil,
            promptUsed: "Test failed to execute"
        )
    }

    // MARK: - Report Generation

    /// Generate comprehensive test report
    private func generateTestReport() -> TestReport {
        let passingTests = testResults.filter { $0.isPassing }
        let failingTests = testResults.filter { !$0.isPassing }

        let successRate = totalTests > 0 ? Double(passingTests.count) / Double(totalTests) * 100 : 0

        // Aggregate scores
        let avgThemeFidelity = testResults.map { $0.themeFidelityScore }.reduce(0, +) / Double(testResults.count)
        let avgElementIntegration = testResults.map { $0.elementIntegrationScore }.reduce(0, +) / Double(testResults.count)
        let avgColorConformance = testResults.map { $0.colorConformanceScore }.reduce(0, +) / Double(testResults.count)
        let avgTechnicalQuality = testResults.map { $0.technicalQualityScore }.reduce(0, +) / Double(testResults.count)

        // Collect all gaps
        let allGaps = testResults.flatMap { $0.gaps }

        // Group gaps by category
        let gapsByCategory = Dictionary(grouping: allGaps, by: { $0.category })

        // Calculate execution time
        let executionTime = endTime?.timeIntervalSince(startTime ?? Date()) ?? 0

        return TestReport(
            timestamp: Date(),
            totalTests: totalTests,
            passingTests: passingTests.count,
            failingTests: failingTests.count,
            successRate: successRate,
            averageScores: AverageScores(
                themeFidelity: avgThemeFidelity,
                elementIntegration: avgElementIntegration,
                colorConformance: avgColorConformance,
                technicalQuality: avgTechnicalQuality
            ),
            gapsByCategory: gapsByCategory,
            allResults: testResults,
            executionTime: executionTime
        )
    }

    // MARK: - Data Models

    struct TestReport: Codable {
        let timestamp: Date
        let totalTests: Int
        let passingTests: Int
        let failingTests: Int
        let successRate: Double
        let averageScores: AverageScores
        let gapsByCategory: [AnniversaryValidationCriteria.ValidationGap.GapCategory: [AnniversaryValidationCriteria.ValidationGap]]
        let allResults: [AnniversaryValidationCriteria.ValidationResult]
        let executionTime: TimeInterval

        var summary: String {
            """
            📊 ANNIVERSARY AI TEST REPORT
            ========================================

            Execution Date: \(timestamp.formatted())
            Execution Time: \(String(format: "%.1f", executionTime / 60.0)) minutes

            OVERALL RESULTS:
            ----------------
            Total Tests:     \(totalTests)
            Passing Tests:   \(passingTests) ✅
            Failing Tests:   \(failingTests) ❌
            Success Rate:    \(String(format: "%.1f", successRate))%

            AVERAGE SCORES (0-100):
            -----------------------
            Theme Fidelity:       \(String(format: "%.1f", averageScores.themeFidelity))
            Element Integration:  \(String(format: "%.1f", averageScores.elementIntegration))
            Color Conformance:    \(String(format: "%.1f", averageScores.colorConformance))
            Technical Quality:    \(String(format: "%.1f", averageScores.technicalQuality))

            GAP DISTRIBUTION:
            -----------------
            \(gapsByCategory.map { "\($0.key.rawValue): \($0.value.count) failures" }.sorted().joined(separator: "\n"))

            TOP ISSUES:
            -----------
            \(getTopIssues())

            RECOMMENDATIONS:
            ----------------
            \(getRecommendations())
            """
        }

        private func getTopIssues() -> String {
            let sortedGaps = gapsByCategory
                .map { (category: $0.key, count: $0.value.count) }
                .sorted { $0.count > $1.count }
                .prefix(5)

            return sortedGaps.enumerated().map { index, item in
                "\(index + 1). \(item.category.rawValue): \(item.count) occurrences"
            }.joined(separator: "\n")
        }

        private func getRecommendations() -> String {
            var recommendations: [String] = []

            if successRate < 70 {
                recommendations.append("⚠️  CRITICAL: Success rate below 70% - Major prompt revisions needed")
            }

            if let colorGaps = gapsByCategory[.wrongColor], colorGaps.count > totalTests / 4 {
                recommendations.append("🎨 Color conformance issues detected - Review color enforcement in prompts")
            }

            if let elementGaps = gapsByCategory[.missingElement], !elementGaps.isEmpty {
                recommendations.append("🔍 Missing elements detected - Strengthen element descriptions")
            }

            if let textGaps = gapsByCategory[.textGenerated], !textGaps.isEmpty {
                recommendations.append("⚠️  CRITICAL: Text generation detected - Strengthen NO TEXT directives")
            }

            if recommendations.isEmpty {
                recommendations.append("✅ System performing well - Proceed with minor optimizations")
            }

            return recommendations.joined(separator: "\n")
        }
    }

    struct AverageScores: Codable {
        let themeFidelity: Double
        let elementIntegration: Double
        let colorConformance: Double
        let technicalQuality: Double
    }

    enum TestingError: LocalizedError {
        case alreadyRunning
        case generationFailed(String, Error)
        case analysisEnabled

        var errorDescription: String? {
            switch self {
            case .alreadyRunning:
                return "Testing agent is already running"
            case .generationFailed(let testID, let error):
                return "Test \(testID) failed: \(error.localizedDescription)"
            case .analysisEnabled:
                return "Image analysis not yet implemented"
            }
        }
    }

    // MARK: - Report Export

    /// Save test report to JSON file
    func saveReportToFile(report: TestReport, filename: String = "test_report.json") throws {
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let resultsPath = documentsPath.appendingPathComponent("TestResults")

        try fileManager.createDirectory(at: resultsPath, withIntermediateDirectories: true)

        let reportPath = resultsPath.appendingPathComponent(filename)
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

        let jsonData = try encoder.encode(report)
        try jsonData.write(to: reportPath)

        print("📄 Test report saved: \(reportPath.path)")
    }
}

// MARK: - TestTier Extension

extension AnniversaryTestSuite.TestCase.TestTier: CaseIterable {
    public static var allCases: [AnniversaryTestSuite.TestCase.TestTier] {
        return [
            .t1Baseline,
            .t2GiftVariations,
            .t3ElementCombinations,
            .t4ColorValidation,
            .t5CrossTabIntegration,
            .t6EdgeCases,
            .t7UserJourney
        ]
    }
}
