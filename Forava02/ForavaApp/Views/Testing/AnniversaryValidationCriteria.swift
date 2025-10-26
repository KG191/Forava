import Foundation
import SwiftUI

/// Comprehensive validation criteria and scoring system for Anniversary AI generation testing
/// Validates that all user selections (theme, gift option, elements, colors) are correctly
/// incorporated into the generated image
struct AnniversaryValidationCriteria {

    // MARK: - Scoring Weights

    /// Weight distribution for overall score calculation
    static let themeFidelityWeight: Double = 0.35  // 35%
    static let elementIntegrationWeight: Double = 0.30  // 30%
    static let colorConformanceWeight: Double = 0.25  // 25%
    static let technicalQualityWeight: Double = 0.10  // 10%

    /// Minimum passing threshold for production readiness
    static let passingThreshold: Double = 80.0

    // MARK: - Validation Result

    /// Complete validation result with detailed scoring
    struct ValidationResult {
        let testID: String
        let timestamp: Date

        // Individual category scores (0-100)
        let themeFidelityScore: Double
        let elementIntegrationScore: Double
        let colorConformanceScore: Double
        let technicalQualityScore: Double

        // Overall weighted score
        var overallScore: Double {
            return (themeFidelityScore * themeFidelityWeight) +
                   (elementIntegrationScore * elementIntegrationWeight) +
                   (colorConformanceScore * colorConformanceWeight) +
                   (technicalQualityScore * technicalQualityWeight)
        }

        // Pass/Fail determination
        var isPassing: Bool {
            return overallScore >= passingThreshold
        }

        // Detailed gaps
        let gaps: [ValidationGap]

        // Test metadata
        let theme: AnniversaryTheme
        let giftOption: String
        let elements: [AnniversaryElement]
        let colorPalette: AnniversaryColorPalette
        let generatedImageURL: String?
        let promptUsed: String
    }

    // MARK: - Gap Definition

    /// Represents a specific failure in validation criteria
    struct ValidationGap: Identifiable {
        let id = UUID()
        let gapID: String
        let category: GapCategory
        let severity: GapSeverity
        let criterion: String
        let actualScore: Double
        let expectedScore: Double
        let description: String
        let promptSection: String
        let hypothesis: String
        let proposedFix: String

        enum GapCategory: String, Codable {
            case missingElement = "Missing Element"
            case wrongColor = "Wrong Color"
            case weakElement = "Weak Element Prominence"
            case themeMismatch = "Theme Mismatch"
            case colorRatioOff = "Color Ratio Incorrect"
            case textGenerated = "Text Generated"
            case lowQuality = "Low Image Quality"
        }

        enum GapSeverity: String, Codable {
            case critical = "CRITICAL"  // Blocks production (e.g., text generated)
            case high = "HIGH"          // Major quality issue
            case medium = "MEDIUM"      // Noticeable but acceptable
            case low = "LOW"            // Minor polish issue

            var priorityOrder: Int {
                switch self {
                case .critical: return 4
                case .high: return 3
                case .medium: return 2
                case .low: return 1
                }
            }
        }
    }

    // MARK: - Criterion 1: Theme/Gift Option Fidelity (35% weight)

    /// Validates that the gift option visual elements are present and theme is maintained
    /// Max score: 100 (4 sub-criteria × 25 points each)
    struct ThemeFidelityCriteria {

        /// Check if gift option-specific visual elements are present
        /// Examples: envelope for "Love Letter", trophy for "Achievement", tree for "Family Tree"
        static func giftOptionElementsPresent(
            giftOption: String,
            imageAnalysis: ImageAnalysisResult
        ) -> Double {
            // Score: 0-25 points
            // 25 pts: All key elements present and recognizable
            // 15 pts: Most elements present but some weak
            // 5 pts: Few elements present
            // 0 pts: No gift option elements visible

            // This would integrate with image recognition API
            // For now, placeholder scoring logic
            return 25.0  // Placeholder - needs actual image analysis
        }

        /// Check if theme aesthetic is maintained (romantic/milestone/family/achievement)
        static func themeAestheticMaintained(
            theme: AnniversaryTheme,
            imageAnalysis: ImageAnalysisResult
        ) -> Double {
            // Score: 0-25 points
            // Romantic: soft, flowing, heart-focused
            // Milestone: celebratory, golden, achievement-focused
            // Family: warm, connected, generational
            // Achievement: professional, success-oriented
            return 25.0  // Placeholder
        }

        /// Check intuitive match between gift option title and generated image
        static func intuitiveMatch(
            giftOption: String,
            imageAnalysis: ImageAnalysisResult
        ) -> Double {
            // Score: 0-25 points
            // User should immediately recognize the concept from the image
            return 25.0  // Placeholder
        }

        /// Check theme-appropriate symbolism
        static func appropriateSymbolism(
            theme: AnniversaryTheme,
            imageAnalysis: ImageAnalysisResult
        ) -> Double {
            // Score: 0-25 points
            // Correct symbols for the theme (hearts for romantic, trophies for achievement, etc.)
            return 25.0  // Placeholder
        }

        /// Calculate total theme fidelity score
        static func calculateScore(
            theme: AnniversaryTheme,
            giftOption: String,
            imageAnalysis: ImageAnalysisResult
        ) -> Double {
            let elements = giftOptionElementsPresent(giftOption: giftOption, imageAnalysis: imageAnalysis)
            let aesthetic = themeAestheticMaintained(theme: theme, imageAnalysis: imageAnalysis)
            let intuitive = intuitiveMatch(giftOption: giftOption, imageAnalysis: imageAnalysis)
            let symbolism = appropriateSymbolism(theme: theme, imageAnalysis: imageAnalysis)

            return elements + aesthetic + intuitive + symbolism
        }
    }

    // MARK: - Criterion 2: Element Integration (30% weight)

    /// Validates that all selected elements are visible with correct hierarchy
    /// Max score: 100
    struct ElementIntegrationCriteria {

        /// Check if centre piece(s) are prominent and identifiable
        static func centrePieceProminence(
            selectedElements: [AnniversaryElement],
            imageAnalysis: ImageAnalysisResult
        ) -> Double {
            // Score: 0-40 points
            let centrePieces = selectedElements.filter { $0.name != "" }

            guard !centrePieces.isEmpty else { return 40.0 }  // No centre pieces required

            // All centre pieces should be:
            // - Clearly visible and identifiable
            // - Largest/most prominent visual elements
            // - Take 40-60% of visual focus
            // - Rendered in primary color

            return 40.0  // Placeholder
        }

        /// Check if supporting elements are visible as accents
        static func supportingElementsVisible(
            selectedElements: [AnniversaryElement],
            imageAnalysis: ImageAnalysisResult
        ) -> Double {
            // Score: 0-30 points
            let supportingElements = selectedElements.filter { $0.name != "" }

            guard !supportingElements.isEmpty else { return 30.0 }  // No supporting elements required

            // All supporting elements should be:
            // - Clearly visible
            // - Complement centre pieces
            // - Take 10-20% of visual space each
            // - Rendered in secondary color

            return 30.0  // Placeholder
        }

        /// Check if visual hierarchy respects priority order
        static func visualHierarchyRespected(
            selectedElements: [AnniversaryElement],
            imageAnalysis: ImageAnalysisResult
        ) -> Double {
            // Score: 0-20 points
            // Higher priority elements should be more prominent
            // Priority 100 > Priority 95 > Priority 90, etc.
            return 20.0  // Placeholder
        }

        /// Check that NO selected element is missing
        static func noElementMissing(
            selectedElements: [AnniversaryElement],
            imageAnalysis: ImageAnalysisResult
        ) -> Double {
            // Score: 0-10 points
            // CRITICAL: Every selected element MUST appear
            // 10 pts: All elements present
            // 0 pts: Any element missing
            return 10.0  // Placeholder
        }

        /// Calculate total element integration score
        static func calculateScore(
            selectedElements: [AnniversaryElement],
            imageAnalysis: ImageAnalysisResult
        ) -> Double {
            let centrePiece = centrePieceProminence(selectedElements: selectedElements, imageAnalysis: imageAnalysis)
            let supporting = supportingElementsVisible(selectedElements: selectedElements, imageAnalysis: imageAnalysis)
            let hierarchy = visualHierarchyRespected(selectedElements: selectedElements, imageAnalysis: imageAnalysis)
            let complete = noElementMissing(selectedElements: selectedElements, imageAnalysis: imageAnalysis)

            return centrePiece + supporting + hierarchy + complete
        }
    }

    // MARK: - Criterion 3: Color Conformance (25% weight)

    /// Validates color palette adherence (only 3 selected colors, correct ratios)
    /// Max score: 100
    struct ColorConformanceCriteria {

        /// Check if primary color dominates (~70% of image)
        static func primaryColorDominance(
            colorPalette: AnniversaryColorPalette,
            imageAnalysis: ImageAnalysisResult
        ) -> Double {
            // Score: 0-40 points
            // Target: 70% ± 10% (60-80% acceptable)
            // 40 pts: 65-75%
            // 30 pts: 60-80%
            // 20 pts: 55-85%
            // 10 pts: 50-90%
            // 0 pts: <50% or >90%

            return 40.0  // Placeholder
        }

        /// Check if secondary color is present (~20% of image)
        static func secondaryColorPresence(
            colorPalette: AnniversaryColorPalette,
            imageAnalysis: ImageAnalysisResult
        ) -> Double {
            // Score: 0-30 points
            // Target: 20% ± 5% (15-25% acceptable)
            return 30.0  // Placeholder
        }

        /// Check if accent color is visible (~10% of image)
        static func accentColorVisibility(
            colorPalette: AnniversaryColorPalette,
            imageAnalysis: ImageAnalysisResult
        ) -> Double {
            // Score: 0-20 points
            // Target: 10% ± 5% (5-15% acceptable)
            return 20.0  // Placeholder
        }

        /// Check that NO unauthorized colors are present
        static func noUnauthorizedColors(
            colorPalette: AnniversaryColorPalette,
            imageAnalysis: ImageAnalysisResult
        ) -> Double {
            // Score: 0-10 points
            // CRITICAL for romantic theme: NO BLACK color
            // Only the 3 selected colors should appear
            // 10 pts: Perfect adherence
            // 5 pts: Minor color bleeding (<5% off-palette)
            // 0 pts: Significant off-palette colors (>5%)

            return 10.0  // Placeholder
        }

        /// Calculate total color conformance score
        static func calculateScore(
            colorPalette: AnniversaryColorPalette,
            imageAnalysis: ImageAnalysisResult
        ) -> Double {
            let primary = primaryColorDominance(colorPalette: colorPalette, imageAnalysis: imageAnalysis)
            let secondary = secondaryColorPresence(colorPalette: colorPalette, imageAnalysis: imageAnalysis)
            let accent = accentColorVisibility(colorPalette: colorPalette, imageAnalysis: imageAnalysis)
            let pure = noUnauthorizedColors(colorPalette: colorPalette, imageAnalysis: imageAnalysis)

            return primary + secondary + accent + pure
        }
    }

    // MARK: - Criterion 4: Technical Quality (10% weight)

    /// Validates technical aspects: no text, clarity, composition, artifacts
    /// Max score: 100
    struct TechnicalQualityCriteria {

        /// Check that NO text/letters/numbers are generated
        static func noTextGenerated(imageAnalysis: ImageAnalysisResult) -> Double {
            // Score: 0-30 points
            // CRITICAL: AI should NEVER generate text
            // 30 pts: Zero text detected
            // 0 pts: Any text/letters/numbers present

            return 30.0  // Placeholder
        }

        /// Check image clarity and resolution
        static func imageClarityAndResolution(imageAnalysis: ImageAnalysisResult) -> Double {
            // Score: 0-30 points
            // Should be sharp, high resolution, no blur
            return 30.0  // Placeholder
        }

        /// Check composition balance
        static func compositionBalance(imageAnalysis: ImageAnalysisResult) -> Double {
            // Score: 0-20 points
            // Visual elements well-distributed, not all clustered in one corner
            return 20.0  // Placeholder
        }

        /// Check for artifacts or distortions
        static func noArtifactsOrDistortions(imageAnalysis: ImageAnalysisResult) -> Double {
            // Score: 0-20 points
            // No compression artifacts, weird shapes, or AI glitches
            return 20.0  // Placeholder
        }

        /// Calculate total technical quality score
        static func calculateScore(imageAnalysis: ImageAnalysisResult) -> Double {
            let noText = noTextGenerated(imageAnalysis: imageAnalysis)
            let clarity = imageClarityAndResolution(imageAnalysis: imageAnalysis)
            let balance = compositionBalance(imageAnalysis: imageAnalysis)
            let artifacts = noArtifactsOrDistortions(imageAnalysis: imageAnalysis)

            return noText + clarity + balance + artifacts
        }
    }

    // MARK: - Image Analysis Result (Placeholder)

    /// Placeholder for actual image analysis integration
    /// In production, this would integrate with:
    /// - Vision API for object detection
    /// - Color analysis libraries
    /// - Text detection APIs
    /// - Quality assessment tools
    struct ImageAnalysisResult {
        let detectedObjects: [String]
        let colorDistribution: [String: Double]  // Color name -> percentage
        let hasText: Bool
        let clarity: Double  // 0-1
        let balance: Double  // 0-1
        let artifacts: Bool

        /// Placeholder initialization
        static func placeholder() -> ImageAnalysisResult {
            return ImageAnalysisResult(
                detectedObjects: [],
                colorDistribution: [:],
                hasText: false,
                clarity: 1.0,
                balance: 1.0,
                artifacts: false
            )
        }
    }

    // MARK: - Main Validation Function

    /// Perform complete validation on a generated anniversary image
    static func validate(
        testID: String,
        theme: AnniversaryTheme,
        giftOption: String,
        elements: [AnniversaryElement],
        colorPalette: AnniversaryColorPalette,
        generatedImageURL: String?,
        promptUsed: String
    ) async -> ValidationResult {

        // Step 1: Analyze the generated image
        let imageAnalysis = await analyzeImage(url: generatedImageURL)

        // Step 2: Score each criterion
        let themeFidelity = ThemeFidelityCriteria.calculateScore(
            theme: theme,
            giftOption: giftOption,
            imageAnalysis: imageAnalysis
        )

        let elementIntegration = ElementIntegrationCriteria.calculateScore(
            selectedElements: elements,
            imageAnalysis: imageAnalysis
        )

        let colorConformance = ColorConformanceCriteria.calculateScore(
            colorPalette: colorPalette,
            imageAnalysis: imageAnalysis
        )

        let technicalQuality = TechnicalQualityCriteria.calculateScore(
            imageAnalysis: imageAnalysis
        )

        // Step 3: Identify gaps (any criterion with score < 80)
        var gaps: [ValidationGap] = []

        if themeFidelity < 80 {
            gaps.append(ValidationGap(
                gapID: "GAP-\(testID)-THEME",
                category: .themeMismatch,
                severity: .high,
                criterion: "Theme Fidelity",
                actualScore: themeFidelity,
                expectedScore: 80,
                description: "Gift option visual elements not adequately represented",
                promptSection: "[THEME_STYLE]",
                hypothesis: "Gift option prompt description may be too generic or unclear",
                proposedFix: "Enhance gift option prompt with more specific visual descriptors"
            ))
        }

        if elementIntegration < 80 {
            gaps.append(ValidationGap(
                gapID: "GAP-\(testID)-ELEMENT",
                category: .missingElement,
                severity: .high,
                criterion: "Element Integration",
                actualScore: elementIntegration,
                expectedScore: 80,
                description: "Selected elements not all visible or prominent enough",
                promptSection: "[CENTRE_ELEMENTS] or [SUPPORTING_ELEMENTS]",
                hypothesis: "Element descriptions may be too weak or conflicting priorities",
                proposedFix: "Strengthen element prominence language and clarify hierarchy"
            ))
        }

        if colorConformance < 80 {
            gaps.append(ValidationGap(
                gapID: "GAP-\(testID)-COLOR",
                category: .wrongColor,
                severity: .high,
                criterion: "Color Conformance",
                actualScore: colorConformance,
                expectedScore: 80,
                description: "Color palette not correctly applied or unauthorized colors present",
                promptSection: "COLOR PALETTE ENFORCEMENT",
                hypothesis: "Color instructions may be insufficiently strict or negative prompt needs strengthening",
                proposedFix: "Increase guidance_scale or enhance color-exclusion negative prompt"
            ))
        }

        if technicalQuality < 80 {
            let severity: ValidationGap.GapSeverity = imageAnalysis.hasText ? .critical : .low
            gaps.append(ValidationGap(
                gapID: "GAP-\(testID)-TECH",
                category: imageAnalysis.hasText ? .textGenerated : .lowQuality,
                severity: severity,
                criterion: "Technical Quality",
                actualScore: technicalQuality,
                expectedScore: 80,
                description: imageAnalysis.hasText ?
                    "AI generated text/letters (CRITICAL FAILURE)" :
                    "Image quality issues (clarity/balance/artifacts)",
                promptSection: imageAnalysis.hasText ?
                    "NO TEXT ENFORCEMENT or negative_prompt" :
                    "Quality parameters",
                hypothesis: imageAnalysis.hasText ?
                    "NO TEXT directives insufficient, text enforcement needs strengthening" :
                    "Model parameters may need tuning",
                proposedFix: imageAnalysis.hasText ?
                    "Add more aggressive text-blocking terms to negative prompt" :
                    "Adjust inference_steps or guidance_scale"
            ))
        }

        // Step 4: Return complete validation result
        return ValidationResult(
            testID: testID,
            timestamp: Date(),
            themeFidelityScore: themeFidelity,
            elementIntegrationScore: elementIntegration,
            colorConformanceScore: colorConformance,
            technicalQualityScore: technicalQuality,
            gaps: gaps,
            theme: theme,
            giftOption: giftOption,
            elements: elements,
            colorPalette: colorPalette,
            generatedImageURL: generatedImageURL,
            promptUsed: promptUsed
        )
    }

    // MARK: - Helper Functions

    /// Analyze image using Vision API or similar (placeholder)
    private static func analyzeImage(url: String?) async -> ImageAnalysisResult {
        // TODO: Integrate with actual image analysis service
        // - Vision API for object detection
        // - Color histogram analysis
        // - Text detection
        // - Quality metrics

        // For now, return placeholder
        return ImageAnalysisResult.placeholder()
    }
}
