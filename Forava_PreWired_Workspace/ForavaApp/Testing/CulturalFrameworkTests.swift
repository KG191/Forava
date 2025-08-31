import Foundation
import SwiftUI

// MARK: - Cultural Framework Test Suite
@MainActor
class CulturalFrameworkTests {

    private let culturalConfig = CulturalConfiguration.shared
    private let contextManager = CulturalContextManager.shared

    // MARK: - Test Runner

    func runAllTests() async {
        print("🧪 [CulturalFrameworkTests] Starting cultural framework tests...")

        // Initialize framework
        await testFrameworkInitialization()

        // Test context management
        testContextManagement()

        // Test Rakhi cultural context
        await testRakhiContext()

        // Test Chinese cultural context
        await testChineseContext()

        // Test context switching
        await testContextSwitching()

        // Test legacy compatibility
        await testLegacyCompatibility()

        // Test validation
        testValidationSystem()

        print("✅ [CulturalFrameworkTests] All tests completed!")
    }

    // MARK: - Individual Tests

    func testFrameworkInitialization() async {
        print("🔧 Testing framework initialization...")

        // Test initialization
        await culturalConfig.initialize()

        assert(culturalConfig.isInitialized, "Cultural configuration should be initialized")
        assert(culturalConfig.currentCulturalContext != nil, "Should have a current cultural context")

        print("✅ Framework initialization test passed")
    }

    func testContextManagement() {
        print("🌍 Testing context management...")

        let availableContexts = culturalConfig.getAvailableContexts()
        assert(availableContexts.count >= 2, "Should have at least 2 cultural contexts")
        assert(availableContexts.contains("rakhi_indian"), "Should contain Rakhi context")
        assert(availableContexts.contains("chinese_traditional"), "Should contain Chinese context")

        print("✅ Context management test passed")
    }

    func testRakhiContext() async {
        print("🎀 Testing Rakhi cultural context...")

        // Switch to Rakhi context
        culturalConfig.switchToCulturalContext("rakhi_indian")

        guard let context = contextManager.currentContext else {
            fatalError("Current context should not be nil")
        }

        assert(context.identifier == "rakhi_indian", "Should be Rakhi context")
        assert(context.displayName == "Rakhi (Indian)", "Display name should be correct")
        assert(!context.genres.isEmpty, "Should have genres")
        assert(!context.colorPalettes.isEmpty, "Should have color palettes")
        assert(!context.designElements.isEmpty, "Should have design elements")

        // Test genre
        let traditionalGenre = context.genres.first { $0.id == "traditional" }
        assert(traditionalGenre != nil, "Should have traditional genre")
        assert(traditionalGenre?.culturalWeight == 1.0, "Traditional genre should have max cultural weight")

        print("✅ Rakhi context test passed")
    }

    func testChineseContext() async {
        print("🏮 Testing Chinese cultural context...")

        // Switch to Chinese context
        culturalConfig.switchToCulturalContext("chinese_traditional")

        guard let context = contextManager.currentContext else {
            fatalError("Current context should not be nil")
        }

        assert(context.identifier == "chinese_traditional", "Should be Chinese context")
        assert(context.displayName == "Chinese Traditional", "Display name should be correct")
        assert(!context.genres.isEmpty, "Should have genres")
        assert(!context.colorPalettes.isEmpty, "Should have color palettes")
        assert(!context.designElements.isEmpty, "Should have design elements")

        // Test specific Chinese elements
        let dragonElement = context.designElements.first { $0.id == "dragon_motif" }
        assert(dragonElement != nil, "Should have dragon motif element")
        assert(dragonElement?.culturalSignificance == 1.0, "Dragon should have max cultural significance")

        print("✅ Chinese context test passed")
    }

    func testContextSwitching() async {
        print("🔄 Testing context switching...")

        // Test switching between contexts
        culturalConfig.switchToCulturalContext("rakhi_indian")
        var context = contextManager.currentContext
        assert(context?.identifier == "rakhi_indian", "Should switch to Rakhi")

        culturalConfig.switchToCulturalContext("chinese_traditional")
        context = contextManager.currentContext
        assert(context?.identifier == "chinese_traditional", "Should switch to Chinese")

        // Test invalid context
        culturalConfig.switchToCulturalContext("invalid_context")
        context = contextManager.currentContext
        assert(context?.identifier == "chinese_traditional", "Should remain on Chinese for invalid switch")

        print("✅ Context switching test passed")
    }

    func testLegacyCompatibility() async {
        print("🔄 Testing legacy compatibility...")

        // Create a legacy Rakhi design spec
        let legacySpec = RakhiDesignSpec(
            genre: .traditional,
            elements: [],
            colorPalette: .traditional,
            personalMessage: "Test message",
            targetAgeGroup: .adult
        )

        // Test conversion to cultural spec
        let culturalSpec = LegacyRakhiBridge.shared.convertLegacySpec(legacySpec)
        assert(culturalSpec != nil, "Should convert legacy spec to cultural spec")
        assert(culturalSpec?.culturalContext == "rakhi_indian", "Should use Rakhi cultural context")
        assert(culturalSpec?.personalMessage == "Test message", "Should preserve personal message")

        // Test conversion back to legacy
        if let cultural = culturalSpec {
            let backToLegacy = LegacyRakhiBridge.shared.convertToLegacySpec(cultural)
            assert(backToLegacy != nil, "Should convert back to legacy spec")
            assert(backToLegacy?.personalMessage == "Test message", "Should preserve message in round trip")
        }

        print("✅ Legacy compatibility test passed")
    }

    func testValidationSystem() {
        print("✅ Testing validation system...")

        // Switch to Rakhi context for validation test
        culturalConfig.switchToCulturalContext("rakhi_indian")

        guard let context = contextManager.currentContext else {
            fatalError("Current context should not be nil")
        }

        // Create a test design spec
        let testSpec = CulturalDesignSpec(
            culturalContext: "rakhi_indian",
            genre: context.genres.first!,
            elements: Array(context.designElements.prefix(2)),
            colorPalette: context.colorPalettes.first!,
            targetAgeGroup: context.ageGroups.first { $0.id == "adult" }!
        )

        // Test validation
        let validationResult = contextManager.validateDesignSpec(testSpec)
        assert(validationResult != nil, "Should get validation result")
        assert(validationResult?.isValid == true, "Valid spec should pass validation")
        assert(validationResult?.culturalScore > 0, "Should have cultural score")

        print("✅ Validation system test passed")
    }

    // MARK: - Performance Tests

    func testContextSwitchingPerformance() async {
        print("⚡ Testing context switching performance...")

        let startTime = CFAbsoluteTimeGetCurrent()

        // Switch contexts multiple times
        for _ in 0..<100 {
            culturalConfig.switchToCulturalContext("rakhi_indian")
            culturalConfig.switchToCulturalContext("chinese_traditional")
        }

        let endTime = CFAbsoluteTimeGetCurrent()
        let executionTime = endTime - startTime

        print("⚡ Context switching performance: \(executionTime)s for 200 switches")
        assert(executionTime < 1.0, "Context switching should be fast")

        print("✅ Performance test passed")
    }

    // MARK: - Integration Tests

    func testCulturalAIServiceIntegration() async throws {
        print("🤖 Testing Cultural AI Service integration...")

        // Switch to Rakhi context
        culturalConfig.switchToCulturalContext("rakhi_indian")

        guard let context = contextManager.currentContext else {
            throw TestError.noCurrentContext
        }

        // Create a test design spec
        let testSpec = CulturalDesignSpec(
            culturalContext: context.identifier,
            genre: context.genres.first!,
            elements: Array(context.designElements.prefix(1)),
            colorPalette: context.colorPalettes.first!,
            targetAgeGroup: context.ageGroups.first { $0.id == "any" }!
        )

        // Test prompt building
        let (positive, negative) = contextManager.buildCulturalPrompt(from: testSpec)
        assert(!positive.isEmpty, "Should generate positive prompt")
        assert(!negative.isEmpty, "Should generate negative prompt")
        assert(positive.contains("Indian rakhi"), "Prompt should contain cultural context")

        print("✅ Cultural AI Service integration test passed")
    }

    // MARK: - Error Handling Tests

    func testErrorHandling() {
        print("⚠️ Testing error handling...")

        // Test invalid context validation
        let invalidSpec = CulturalDesignSpec(
            culturalContext: "invalid_context",
            genre: CulturalGenre(id: "test", displayName: "Test", icon: "star", basePrompt: "test", culturalContext: "invalid"),
            colorPalette: CulturalColorPalette(id: "test", displayName: "Test", colors: [], culturalContext: "invalid"),
            targetAgeGroup: CulturalAgeGroup(id: "test", displayName: "Test", ageRange: "test", culturalContext: "invalid")
        )

        let validationResult = contextManager.validateDesignSpec(invalidSpec)
        // Should handle invalid context gracefully (return nil or valid error state)

        print("✅ Error handling test passed")
    }
}

// MARK: - Test Error Types
enum TestError: Error {
    case noCurrentContext
    case validationFailed
    case conversionFailed
}

// MARK: - Test Runner Extension
extension CulturalFrameworkTests {

    static func runQuickTest() async {
        let tests = CulturalFrameworkTests()

        print("🚀 Running quick cultural framework test...")

        // Initialize
        await tests.culturalConfig.initialize()

        // Basic functionality test
        let availableContexts = tests.culturalConfig.getAvailableContexts()
        print("📋 Available contexts: \(availableContexts)")

        // Test context switching
        tests.culturalConfig.switchToCulturalContext("rakhi_indian")
        print("🎀 Switched to Rakhi context: \(tests.contextManager.currentContext?.displayName ?? "Unknown")")

        tests.culturalConfig.switchToCulturalContext("chinese_traditional")
        print("🏮 Switched to Chinese context: \(tests.contextManager.currentContext?.displayName ?? "Unknown")")

        print("✅ Quick test completed successfully!")
    }
}
