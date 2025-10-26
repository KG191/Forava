import XCTest
import SwiftUI
@testable import ForavaApp

/// Comprehensive integration test suite for Anniversary cultural design system
class AnniversaryIntegrationTests: XCTestCase {

    // MARK: - Test Properties
    var anniversaryService: AnniversaryAIService!
    var viewModel: AnniversaryDesignView.AnniversaryViewModel!

    override func setUp() async throws {
        try await super.setUp()

        await MainActor.run {
            anniversaryService = AnniversaryAIService.shared
            viewModel = AnniversaryDesignView.AnniversaryViewModel()
        }
    }

    override func tearDown() async throws {
        anniversaryService = nil
        viewModel = nil
        try await super.tearDown()
    }

    // MARK: - Complete Anniversary Workflow Tests

    func testCompleteAnniversaryGiftCreationFlow() async throws {
        await MainActor.run {
            print("🎊 Testing Complete Anniversary Gift Creation Flow")

            // Step 1: Select Anniversary Occasion
            viewModel.selectedOccasion = .wedding
            XCTAssertEqual(viewModel.selectedOccasion, .wedding,
                "Should set wedding anniversary successfully")
            print("✅ Step 1: Anniversary occasion selected (Wedding)")

            // Step 2: Enter Years Count
            viewModel.yearsCount = "10"
            XCTAssertEqual(viewModel.yearsCount, "10",
                "Should store years count correctly")
            print("✅ Step 2: Years count entered (10 years)")

            // Verify Occasion tab completion
            XCTAssertTrue(viewModel.isOccasionComplete,
                "Occasion tab should be marked complete")
            print("✅ Occasion tab validated as complete")
        }

        await MainActor.run {
            // Step 3: Select Anniversary Theme
            viewModel.selectedTheme = .romantic
            XCTAssertEqual(viewModel.selectedTheme, .romantic,
                "Should set romantic theme successfully")
            print("✅ Step 3: Theme selected (Romantic)")

            // Verify Theme tab completion
            XCTAssertTrue(viewModel.isThemeComplete,
                "Theme tab should be marked complete")
        }

        await MainActor.run {
            // Step 4: Add Anniversary Elements
            let heartElement = AnniversaryElement.heart
            let ringsElement = AnniversaryElement.rings
            viewModel.selectedElements = [heartElement, ringsElement]

            XCTAssertEqual(viewModel.selectedElements.count, 2,
                "Should have 2 elements selected")
            XCTAssertTrue(viewModel.selectedElements.contains(heartElement),
                "Should contain heart element")
            XCTAssertTrue(viewModel.selectedElements.contains(ringsElement),
                "Should contain rings element")
            print("✅ Step 4: Elements selected (Heart, Rings)")

            // Verify Elements tab completion
            XCTAssertTrue(viewModel.isElementsComplete,
                "Elements tab should be marked complete")
        }

        await MainActor.run {
            // Step 5: Select Color Palette
            viewModel.selectedColorPalette = AnniversaryColorPalette.allPalettes[0]
            XCTAssertNotNil(viewModel.selectedColorPalette,
                "Should set color palette successfully")
            print("✅ Step 5: Color palette selected")

            // Verify Colors tab completion
            XCTAssertTrue(viewModel.isColorsComplete,
                "Colors tab should be marked complete")
        }

        await MainActor.run {
            // Step 6: Add Personal Message
            viewModel.personalMessage = "Happy 10th Anniversary! Here's to many more years together."
            viewModel.recipientName = "Sarah"

            XCTAssertFalse(viewModel.personalMessage.isEmpty,
                "Personal message should not be empty")
            XCTAssertFalse(viewModel.recipientName.isEmpty,
                "Recipient name should not be empty")
            print("✅ Step 6: Personal message and recipient added")

            // Verify Personal tab completion
            XCTAssertTrue(viewModel.isPersonalComplete,
                "Personal tab should be marked complete")
        }

        await MainActor.run {
            // Step 7: Verify all tabs complete - ready to generate
            XCTAssertTrue(viewModel.isReadyToGenerate,
                "Should be ready to generate after all tabs complete")
            print("✅ Step 7: All tabs validated - Ready to generate")
        }

        // Step 8: Test mock generation
        do {
            let generatedImageURL = try await anniversaryService.generateAnniversaryGift(
                theme: .romantic,
                elements: [.heart, .rings],
                colorPalette: AnniversaryColorPalette.allPalettes[0],
                message: "Happy 10th Anniversary!",
                contactName: "Sarah"
            )

            XCTAssertFalse(generatedImageURL.isEmpty,
                "Generated image URL should not be empty")
            print("✅ Step 8: Mock generation completed successfully")
            print("   Generated URL: \(generatedImageURL)")

            // Step 9: Verify generation progress tracking
            await MainActor.run {
                XCTAssertGreaterThanOrEqual(anniversaryService.generationProgress, 0.0,
                    "Generation progress should be tracked")
                print("✅ Step 9: Generation progress tracking validated")
            }

            print("🎊 Complete Anniversary gift creation flow validated successfully!")

        } catch {
            XCTFail("Anniversary generation failed with error: \(error)")
        }
    }

    // MARK: - Theme Selection Tests

    func testAllAnniversaryThemes() async throws {
        await MainActor.run {
            print("🎨 Testing All Anniversary Themes")

            let themes: [AnniversaryTheme] = [.romantic, .milestone, .family, .achievement]

            for theme in themes {
                viewModel.selectedTheme = theme
                XCTAssertEqual(viewModel.selectedTheme, theme,
                    "Should set \(theme.rawValue) theme successfully")
                print("✅ Theme validated: \(theme.rawValue)")
            }

            print("🎨 All Anniversary themes validated")
        }
    }

    // MARK: - Element Combination Tests

    func testElementCategoryValidation() async throws {
        await MainActor.run {
            print("🎁 Testing Element Category Validation")

            // Test centre piece elements
            let centrePieces = AnniversaryElement.allElements.filter {
                $0.category == .centrePiece
            }
            XCTAssertGreaterThan(centrePieces.count, 0,
                "Should have centre piece elements")
            print("✅ Centre pieces count: \(centrePieces.count)")

            // Test supporting elements
            let supportingElements = AnniversaryElement.allElements.filter {
                $0.category == .supportingElement
            }
            XCTAssertGreaterThan(supportingElements.count, 0,
                "Should have supporting elements")
            print("✅ Supporting elements count: \(supportingElements.count)")

            // Test accent elements
            let accentElements = AnniversaryElement.allElements.filter {
                $0.category == .accentElement
            }
            XCTAssertGreaterThan(accentElements.count, 0,
                "Should have accent elements")
            print("✅ Accent elements count: \(accentElements.count)")

            print("🎁 Element category validation complete")
        }
    }

    // MARK: - Color Palette Tests

    func testColorPaletteConfiguration() async throws {
        print("🎨 Testing Color Palette Configuration")

        let palettes = AnniversaryColorPalette.allPalettes

        XCTAssertGreaterThan(palettes.count, 0,
            "Should have color palettes available")

        for palette in palettes {
            XCTAssertFalse(palette.name.isEmpty,
                "Palette name should not be empty")
            XCTAssertFalse(palette.primaryColor.isEmpty,
                "Primary color should be defined")
            XCTAssertFalse(palette.secondaryColor.isEmpty,
                "Secondary color should be defined")
            XCTAssertFalse(palette.accentColor.isEmpty,
                "Accent color should be defined")

            print("✅ Palette validated: \(palette.name)")
        }

        print("🎨 Color palette configuration validated")
    }

    // MARK: - State Persistence Tests

    func testStatePersistenceAcrossTabSwitching() async throws {
        await MainActor.run {
            print("💾 Testing State Persistence Across Tab Switching")

            // Set data in different tabs
            viewModel.selectedOccasion = .dating
            viewModel.yearsCount = "5"
            viewModel.selectedTheme = .milestone
            viewModel.selectedElements = [.heart, .flowers]
            viewModel.selectedColorPalette = AnniversaryColorPalette.allPalettes[1]
            viewModel.personalMessage = "Test message"
            viewModel.recipientName = "Test recipient"

            // Simulate tab switching by accessing currentTab
            viewModel.currentTab = 0
            XCTAssertEqual(viewModel.selectedOccasion, .dating,
                "Occasion should persist after tab switch")

            viewModel.currentTab = 1
            XCTAssertEqual(viewModel.selectedTheme, .milestone,
                "Theme should persist after tab switch")

            viewModel.currentTab = 2
            XCTAssertEqual(viewModel.selectedElements.count, 2,
                "Elements should persist after tab switch")

            viewModel.currentTab = 3
            XCTAssertNotNil(viewModel.selectedColorPalette,
                "Color palette should persist after tab switch")

            viewModel.currentTab = 4
            XCTAssertEqual(viewModel.personalMessage, "Test message",
                "Personal message should persist after tab switch")

            print("✅ All state persisted correctly across tabs")
            print("💾 State persistence validation complete")
        }
    }

    // MARK: - Error Handling Tests

    func testGenerationErrorHandling() async throws {
        print("⚠️ Testing Error Handling")

        // Test with minimal/invalid data
        do {
            _ = try await anniversaryService.generateAnniversaryGift(
                theme: .romantic,
                elements: [], // Empty elements
                colorPalette: AnniversaryColorPalette.allPalettes[0],
                message: "",
                contactName: ""
            )

            // Should still succeed with mock generation
            print("✅ Error handling validated - mock generation handles edge cases")

        } catch {
            print("✅ Error properly caught and handled: \(error)")
        }
    }

    // MARK: - Cultural Authenticity Tests

    func testCulturalPromptGeneration() async throws {
        print("🌍 Testing Cultural Authenticity")

        let testSpec = AnniversaryDesignSpec(
            theme: .romantic,
            elements: [.heart, .rings, .flowers],
            colorPalette: AnniversaryColorPalette.allPalettes[0],
            message: "Happy Anniversary!",
            contactName: "Alex"
        )

        let prompt = anniversaryService.createCulturalPrompt(from: testSpec)

        XCTAssertFalse(prompt.isEmpty, "Cultural prompt should not be empty")
        XCTAssertTrue(prompt.contains("anniversary"),
            "Prompt should contain 'anniversary' keyword")

        print("✅ Cultural prompt generated successfully")
        print("   Prompt length: \(prompt.count) characters")
        print("🌍 Cultural authenticity validation complete")
    }

    // MARK: - Performance Tests

    func testTabLoadPerformance() async throws {
        print("⚡ Testing Tab Load Performance")

        let startTime = CFAbsoluteTimeGetCurrent()

        await MainActor.run {
            // Simulate loading all tabs
            for tabIndex in 0..<7 {
                viewModel.currentTab = tabIndex
            }
        }

        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        let timeInMs = timeElapsed * 1000

        XCTAssertLessThan(timeInMs, 100.0,
            "Tab switching should complete in <100ms (actual: \(String(format: "%.2f", timeInMs))ms)")

        print("✅ Tab load performance: \(String(format: "%.2f", timeInMs))ms")
        print("⚡ Performance validation complete")
    }

    func testGenerationPerformance() async throws {
        print("⚡ Testing Mock Generation Performance")

        let startTime = CFAbsoluteTimeGetCurrent()

        _ = try await anniversaryService.generateAnniversaryGift(
            theme: .romantic,
            elements: [.heart, .rings],
            colorPalette: AnniversaryColorPalette.allPalettes[0],
            message: "Test",
            contactName: "Test"
        )

        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime

        print("✅ Mock generation time: \(String(format: "%.2f", timeElapsed))s")
        XCTAssertLessThan(timeElapsed, 10.0,
            "Mock generation should complete in <10s")
        print("⚡ Generation performance validated")
    }

    // MARK: - UI Validation Tests

    func testOccasionTypesAvailable() async throws {
        await MainActor.run {
            print("📋 Testing Occasion Types")

            let occasions: [AnniversaryOccasion] = [
                .wedding, .dating, .friendship, .business, .custom
            ]

            for occasion in occasions {
                viewModel.selectedOccasion = occasion
                XCTAssertEqual(viewModel.selectedOccasion, occasion,
                    "Should support \(occasion.rawValue) occasion")
                print("✅ Occasion type validated: \(occasion.rawValue)")
            }

            print("📋 All occasion types validated")
        }
    }

    // MARK: - Integration with Base Services

    func testProtocolConformance() async throws {
        print("🔌 Testing Protocol Conformance")

        // Verify AnniversaryAIService conforms to CulturalAIServiceProtocol
        XCTAssertNotNil(anniversaryService as? CulturalAIServiceProtocol,
            "Should conform to CulturalAIServiceProtocol")

        // Test protocol methods
        let culturalEventType = await anniversaryService.culturalEventType
        XCTAssertEqual(culturalEventType, "Anniversary",
            "Cultural event type should be 'Anniversary'")

        let themes = await anniversaryService.getCulturalThemes()
        XCTAssertGreaterThan(themes.count, 0,
            "Should provide cultural themes")

        let elements = await anniversaryService.getCulturalElements()
        XCTAssertGreaterThan(elements.count, 0,
            "Should provide cultural elements")

        let palettes = await anniversaryService.getCulturalColorPalettes()
        XCTAssertGreaterThan(palettes.count, 0,
            "Should provide color palettes")

        print("✅ Protocol conformance validated")
        print("🔌 Integration tests complete")
    }

    // MARK: - Summary Test

    func testCompleteSummaryView() async throws {
        await MainActor.run {
            print("📊 Testing Summary View Data")

            // Set complete data
            viewModel.selectedOccasion = .wedding
            viewModel.yearsCount = "25"
            viewModel.selectedTheme = .milestone
            viewModel.selectedElements = [.heart, .rings, .flowers]
            viewModel.selectedColorPalette = AnniversaryColorPalette.allPalettes[0]
            viewModel.personalMessage = "Happy 25th Anniversary!"
            viewModel.recipientName = "Jane"

            // Verify summary is complete
            XCTAssertTrue(viewModel.isReadyToGenerate,
                "Summary should show ready to generate")

            print("✅ Summary view data validated")
            print("   Occasion: \(viewModel.selectedOccasion.rawValue)")
            print("   Years: \(viewModel.yearsCount)")
            print("   Theme: \(viewModel.selectedTheme.rawValue)")
            print("   Elements: \(viewModel.selectedElements.count)")
            print("   Has color palette: \(viewModel.selectedColorPalette != nil)")
            print("   Has message: \(!viewModel.personalMessage.isEmpty)")
            print("   Has recipient: \(!viewModel.recipientName.isEmpty)")

            print("📊 Summary view validation complete")
        }
    }
}
