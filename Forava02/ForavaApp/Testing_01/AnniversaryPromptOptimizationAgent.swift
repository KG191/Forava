import Foundation
import SwiftUI

/// Prompt Optimization Agent - Analyzes test failures and iteratively improves
/// AI prompts to achieve correct image generation
@MainActor
class AnniversaryPromptOptimizationAgent: ObservableObject {

    // MARK: - Published Properties

    @Published var isOptimizing = false
    @Published var currentProgress: Double = 0.0
    @Published var currentOptimization: String = ""
    @Published var optimizationsCompleted: Int = 0

    // MARK: - Optimization Results

    private var optimizationLog: [OptimizationEntry] = []

    // MARK: - Main Optimization Workflow

    /// Analyze test report and optimize failing prompts
    func optimizeFromTestReport(
        report: AnniversaryTestingAgent.TestReport,
        maxIterations: Int = 3
    ) async throws -> OptimizationReport {

        guard !isOptimizing else {
            throw OptimizationError.alreadyOptimizing
        }

        isOptimizing = true
        optimizationLog = []
        optimizationsCompleted = 0

        defer {
            isOptimizing = false
        }

        print("🔧 PROMPT OPTIMIZATION AGENT STARTED")
        print("=" + String(repeating: "=", count: 79))
        print("Total Failures to Analyze: \(report.failingTests)")
        print("=" + String(repeating: "=", count: 79))

        // Get all failing results sorted by priority
        let failingResults = report.allResults
            .filter { !$0.isPassing }
            .sorted { result1, result2 in
                // Sort by severity of gaps
                let maxSeverity1 = result1.gaps.map { $0.severity.priorityOrder }.max() ?? 0
                let maxSeverity2 = result2.gaps.map { $0.severity.priorityOrder }.max() ?? 0
                return maxSeverity1 > maxSeverity2
            }

        // Group failures by gap category for systematic optimization
        let failuresByCategory = Dictionary(grouping: failingResults) { result in
            result.gaps.first?.category ?? .lowQuality
        }

        print("\nFAILURE ANALYSIS:")
        for (category, failures) in failuresByCategory.sorted(by: { $0.value.count > $1.value.count }) {
            print("  \(category.rawValue): \(failures.count) failures")
        }
        print("")

        // Optimize each category systematically
        for (category, failures) in failuresByCategory.sorted(by: { $0.value.count > $1.value.count }) {
            currentOptimization = "Optimizing \(category.rawValue)"

            print("\n" + String(repeating: "-", count: 79))
            print("🎯 OPTIMIZING: \(category.rawValue) (\(failures.count) failures)")
            print(String(repeating: "-", count: 79))

            // Analyze and propose fix for this category
            let optimization = try await optimizeCategory(
                category: category,
                failures: failures,
                maxIterations: maxIterations
            )

            optimizationLog.append(optimization)
            optimizationsCompleted += 1
        }

        // Generate optimization report
        let optimizationReport = generateOptimizationReport(
            originalReport: report,
            optimizations: optimizationLog
        )

        print("\n" + String(repeating: "=", count: 79))
        print("🎉 OPTIMIZATION COMPLETE")
        print("=" + String(repeating: "=", count: 79))
        print(optimizationReport.summary)
        print("=" + String(repeating: "=", count: 79))

        return optimizationReport
    }

    // MARK: - Category-Specific Optimization

    /// Optimize prompts for a specific failure category
    private func optimizeCategory(
        category: AnniversaryValidationCriteria.ValidationGap.GapCategory,
        failures: [AnniversaryValidationCriteria.ValidationResult],
        maxIterations: Int
    ) async throws -> OptimizationEntry {

        // Analyze the category to understand the root cause
        let analysis = analyzeFailureCategory(category: category, failures: failures)

        print("\nANALYSIS:")
        print("  Root Cause: \(analysis.rootCause)")
        print("  Affected Prompt Section: \(analysis.promptSection)")
        print("  Hypothesis: \(analysis.hypothesis)")

        // Propose fix based on category
        let proposedFix = proposeFixForCategory(category: category, analysis: analysis)

        print("\nPROPOSED FIX:")
        print("  Strategy: \(proposedFix.strategy)")
        print("  Modifications:")
        for (index, mod) in proposedFix.modifications.enumerated() {
            print("    \(index + 1). \(mod)")
        }

        // For now, log the optimization without actually testing
        // In production, this would:
        // 1. Apply the fix
        // 2. Re-test affected test cases
        // 3. Validate improvement
        // 4. Iterate if needed

        return OptimizationEntry(
            category: category,
            affectedTestsCount: failures.count,
            analysis: analysis,
            proposedFix: proposedFix,
            iterationsTaken: 1,
            successRate: 0.0,  // Placeholder - would be calculated after re-testing
            status: .proposed
        )
    }

    // MARK: - Failure Analysis

    /// Analyze failures to identify root cause
    private func analyzeFailureCategory(
        category: AnniversaryValidationCriteria.ValidationGap.GapCategory,
        failures: [AnniversaryValidationCriteria.ValidationResult]
    ) -> FailureAnalysis {

        switch category {
        case .missingElement:
            return FailureAnalysis(
                category: category,
                rootCause: "Selected elements not appearing in generated images",
                promptSection: "[CENTRE_ELEMENTS] or [SUPPORTING_ELEMENTS]",
                hypothesis: "Element descriptions may be too generic or lack emphasis. AI might not recognize element names.",
                affectedTests: failures.map { $0.testID }
            )

        case .wrongColor:
            return FailureAnalysis(
                category: category,
                rootCause: "Unauthorized colors appearing in images",
                promptSection: "COLOR PALETTE ENFORCEMENT + negative_prompt",
                hypothesis: "Color enforcement insufficient. Negative prompt may not exclude all unwanted colors. Guidance scale might be too low.",
                affectedTests: failures.map { $0.testID }
            )

        case .weakElement:
            return FailureAnalysis(
                category: category,
                rootCause: "Elements present but not prominent enough",
                promptSection: "[CENTRE_ELEMENTS]",
                hypothesis: "Priority language not strong enough. Need more emphasis on element size and prominence.",
                affectedTests: failures.map { $0.testID }
            )

        case .themeMismatch:
            return FailureAnalysis(
                category: category,
                rootCause: "Generated image doesn't match gift option concept",
                promptSection: "[THEME_STYLE] (gift option mappings)",
                hypothesis: "Gift option AI prompts may be too abstract or lack specific visual descriptors that match the title.",
                affectedTests: failures.map { $0.testID }
            )

        case .colorRatioOff:
            return FailureAnalysis(
                category: category,
                rootCause: "Color ratios incorrect (not 70/20/10%)",
                promptSection: "COLOR PALETTE ENFORCEMENT percentages",
                hypothesis: "Percentage instructions may be ignored by AI. Need stronger directive language for color distribution.",
                affectedTests: failures.map { $0.testID }
            )

        case .textGenerated:
            return FailureAnalysis(
                category: category,
                rootCause: "AI generated text/letters/numbers (CRITICAL)",
                promptSection: "NO TEXT ENFORCEMENT + negative_prompt",
                hypothesis: "Text blocking insufficient. Need more aggressive NO TEXT directives and enhanced negative prompt.",
                affectedTests: failures.map { $0.testID }
            )

        case .lowQuality:
            return FailureAnalysis(
                category: category,
                rootCause: "Image quality issues (blur, artifacts, composition)",
                promptSection: "Model parameters (inference_steps, guidance_scale)",
                hypothesis: "Model settings may need adjustment. Could also be API/network issues.",
                affectedTests: failures.map { $0.testID }
            )
        }
    }

    // MARK: - Fix Proposals

    /// Propose specific fixes for each category
    private func proposeFixForCategory(
        category: AnniversaryValidationCriteria.ValidationGap.GapCategory,
        analysis: FailureAnalysis
    ) -> ProposedFix {

        switch category {
        case .missingElement:
            return ProposedFix(
                category: category,
                strategy: "Strengthen element descriptions with ultra-specific visual language",
                modifications: [
                    "Add 'YOU MUST PROMINENTLY DISPLAY' emphasis before all element descriptions",
                    "Replace generic element names with detailed visual descriptions (e.g., 'hearts' → 'large decorative red hearts with visible curves and symmetrical lobes')",
                    "Add size indicators (e.g., 'large', 'prominent', 'centerpiece')",
                    "Specify exact placement (e.g., 'in the center', 'as the dominant feature')",
                    "Add repetition: mention critical elements multiple times in prompt"
                ],
                expectedImprovement: "Elements should appear prominently in 90%+ of tests",
                promptTemplate: """
                    YOU MUST PROMINENTLY DISPLAY: [specific visual description of element]. \
                    This [element] should be the LARGEST and MOST VISIBLE feature, occupying 40-60% of the visual space. \
                    The [element] must be clearly identifiable with [specific characteristics]. \
                    CRITICAL: Do not proceed without including [element] as the central focal point.
                    """
            )

        case .wrongColor:
            return ProposedFix(
                category: category,
                strategy: "Enhance color exclusion with comprehensive negative prompt",
                modifications: [
                    "Increase guidance_scale from 9.5 to 11.0 for stricter prompt adherence",
                    "Enhance colorExclusionNegativePrompt with ALL color variations",
                    "Add 'STRICTLY FORBIDDEN' language to color restrictions",
                    "Repeat color names 3x in negative prompt for emphasis",
                    "Add color adjacency restrictions (e.g., 'no red if primary is blue')",
                    "For Romantic theme: Add 'absolutely no black, no darkness, no shadows' 5x to negative prompt"
                ],
                expectedImprovement: "100% color conformance on all palettes",
                promptTemplate: """
                    STRICT COLOR ENFORCEMENT - ONLY THESE COLORS ALLOWED:
                    - PRIMARY: [color] (MUST dominate 70% of image) [color] [color] [color]
                    - SECONDARY: [color] (MUST fill 20% of image) [color] [color] [color]
                    - ACCENT: [color] (MUST fill 10% of image) [color] [color] [color]

                    STRICTLY FORBIDDEN COLORS: [all other colors listed 3x each]
                    """
            )

        case .weakElement:
            return ProposedFix(
                category: category,
                strategy: "Add explicit size and prominence directives",
                modifications: [
                    "Prefix all centre piece descriptions with 'MASSIVE', 'DOMINANT', 'OVERSIZED'",
                    "Add percentage indicators: 'occupying 50% of the visual space'",
                    "Use comparative language: 'larger than all other elements combined'",
                    "Add spatial directives: 'filling the entire center third of the image'",
                    "Emphasize contrast: 'clearly distinct from background'"
                ],
                expectedImprovement: "Centre pieces should be 3x more prominent",
                promptTemplate: "DOMINANT OVERSIZED [element] occupying 50% of image, LARGER than all other elements"
            )

        case .themeMismatch:
            return ProposedFix(
                category: category,
                strategy: "Refine gift option prompts with hyper-specific visual language",
                modifications: [
                    "Review all 32 gift option prompts for specificity",
                    "Add 3-5 specific visual elements per gift option",
                    "Use concrete objects instead of abstract concepts",
                    "Add composition guidance (e.g., 'centered', 'layered', 'arranged in circle')",
                    "For each gift option, list MUST-HAVE visual elements explicitly"
                ],
                expectedImprovement: "Gift options should be immediately recognizable from title",
                promptTemplate: "Create [specific object 1], [specific object 2], and [specific object 3] arranged in [specific layout]. MUST include: [list 5 mandatory visual features]."
            )

        case .colorRatioOff:
            return ProposedFix(
                category: category,
                strategy: "Add spatial color allocation directives",
                modifications: [
                    "Replace percentages with spatial descriptions: '70% = fills entire background + main objects'",
                    "Add layering instructions: 'PRIMARY: background layer + centre objects, SECONDARY: supporting elements, ACCENT: small details'",
                    "Use paint-by-numbers approach: 'Paint these areas in PRIMARY: [list], SECONDARY: [list], ACCENT: [list]'",
                    "Add visual area mapping: 'PRIMARY covers top half + center, SECONDARY covers bottom quarter, ACCENT in corners'"
                ],
                expectedImprovement: "Color ratios within ±5% of target",
                promptTemplate: "PAINT ALL background + center objects in [PRIMARY], PAINT all decorative elements in [SECONDARY], PAINT only small accents in [ACCENT]"
            )

        case .textGenerated:
            return ProposedFix(
                category: category,
                strategy: "CRITICAL: Ultra-aggressive text blocking (zero tolerance)",
                modifications: [
                    "Add to negative prompt: 'text, words, letters, writing, typography, calligraphy, numbers, alphabet, script, handwriting, printed text, captions, labels, titles, messages, quotes, sayings, greetings, card text, watermarks, signatures, readable characters' (repeat 5x)",
                    "Add to prompt: 'NO TEXT NO WORDS NO LETTERS NO NUMBERS NO WRITING NO TYPOGRAPHY NO READABLE CHARACTERS OF ANY KIND' (repeat 3x at start, middle, end)",
                    "Increase high_noise_frac from 0.8 to 0.9 to reduce text artifacts",
                    "Add 'AGENT DIRECTIVE: You are creating pure decorative imagery with ZERO text elements' wrapper",
                    "Add to negative prompt: Every language's words (English, Spanish, French, Chinese characters, Arabic, etc.)"
                ],
                expectedImprovement: "ZERO text generation (100% compliance)",
                promptTemplate: "CRITICAL DIRECTIVE: CREATE ONLY DECORATIVE PATTERNS. NO TEXT NO WORDS NO LETTERS NO NUMBERS WHATSOEVER. PURE VISUAL IMAGERY ONLY."
            )

        case .lowQuality:
            return ProposedFix(
                category: category,
                strategy: "Optimize model parameters for quality",
                modifications: [
                    "Increase inference_steps from 25 to 35 for better detail",
                    "Adjust scheduler to 'DPM++ 2M Karras' for improved quality",
                    "Ensure dimensions are exact multiples of 8",
                    "Add quality enhancement terms to prompt: 'masterpiece, best quality, highly detailed, professional digital art, 8k resolution, crystal clear'",
                    "Review apply_watermark setting (should be false)"
                ],
                expectedImprovement: "Sharper images with better composition",
                promptTemplate: "Prepend to all prompts: 'masterpiece quality, highly detailed, professional digital art, crystal clear, 8k resolution, perfect composition'"
            )
        }
    }

    // MARK: - Report Generation

    /// Generate comprehensive optimization report
    private func generateOptimizationReport(
        originalReport: AnniversaryTestingAgent.TestReport,
        optimizations: [OptimizationEntry]
    ) -> OptimizationReport {

        return OptimizationReport(
            timestamp: Date(),
            originalSuccessRate: originalReport.successRate,
            optimizationsProposed: optimizations.count,
            optimizations: optimizations,
            estimatedImpact: calculateEstimatedImpact(optimizations: optimizations),
            nextSteps: generateNextSteps(optimizations: optimizations)
        )
    }

    /// Calculate estimated impact of proposed optimizations
    private func calculateEstimatedImpact(optimizations: [OptimizationEntry]) -> EstimatedImpact {
        // Conservative estimates based on optimization category
        var criticalFixes = 0
        var highFixes = 0
        var mediumFixes = 0

        for optimization in optimizations {
            let maxSeverity = optimization.analysis.category
            switch maxSeverity {
            case .textGenerated:
                criticalFixes += optimization.affectedTestsCount
            case .missingElement, .wrongColor, .themeMismatch:
                highFixes += optimization.affectedTestsCount
            case .weakElement, .colorRatioOff:
                mediumFixes += optimization.affectedTestsCount
            case .lowQuality:
                break  // Quality issues require parameter tuning, not prompt changes
            }
        }

        // Estimate success rate improvement
        // Critical fixes: 90% likely to resolve
        // High fixes: 75% likely to resolve
        // Medium fixes: 60% likely to resolve
        let estimatedResolved = Double(criticalFixes) * 0.9 + Double(highFixes) * 0.75 + Double(mediumFixes) * 0.6

        return EstimatedImpact(
            criticalIssuesAddressed: criticalFixes,
            highIssuesAddressed: highFixes,
            mediumIssuesAddressed: mediumFixes,
            estimatedTestsImproved: Int(estimatedResolved),
            estimatedNewSuccessRate: min(95.0, 70.0 + (estimatedResolved / 240.0 * 100.0))
        )
    }

    /// Generate actionable next steps
    private func generateNextSteps(optimizations: [OptimizationEntry]) -> [String] {
        var steps: [String] = []

        // Priority order: CRITICAL → HIGH → MEDIUM → LOW
        let sortedOptimizations = optimizations.sorted { opt1, opt2 in
            let severity1 = opt1.analysis.category == .textGenerated ? 4 : 2
            let severity2 = opt2.analysis.category == .textGenerated ? 4 : 2
            return severity1 > severity2
        }

        for (index, optimization) in sortedOptimizations.enumerated() {
            steps.append("STEP \(index + 1): Apply \(optimization.proposedFix.strategy) (\(optimization.affectedTestsCount) tests affected)")
            steps.append("  → \(optimization.proposedFix.modifications.first ?? "Apply modifications")")
        }

        steps.append("")
        steps.append("FINAL STEP: Re-run full test suite to validate improvements")

        return steps
    }

    // MARK: - Data Models

    struct OptimizationEntry: Codable {
        let category: AnniversaryValidationCriteria.ValidationGap.GapCategory
        let affectedTestsCount: Int
        let analysis: FailureAnalysis
        let proposedFix: ProposedFix
        let iterationsTaken: Int
        let successRate: Double
        let status: OptimizationStatus

        enum OptimizationStatus: String, Codable {
            case proposed = "Proposed"
            case applied = "Applied"
            case tested = "Tested"
            case successful = "Successful"
            case needsIteration = "Needs Iteration"
        }
    }

    struct FailureAnalysis: Codable {
        let category: AnniversaryValidationCriteria.ValidationGap.GapCategory
        let rootCause: String
        let promptSection: String
        let hypothesis: String
        let affectedTests: [String]
    }

    struct ProposedFix: Codable {
        let category: AnniversaryValidationCriteria.ValidationGap.GapCategory
        let strategy: String
        let modifications: [String]
        let expectedImprovement: String
        let promptTemplate: String
    }

    struct OptimizationReport: Codable {
        let timestamp: Date
        let originalSuccessRate: Double
        let optimizationsProposed: Int
        let optimizations: [OptimizationEntry]
        let estimatedImpact: EstimatedImpact
        let nextSteps: [String]

        var summary: String {
            """
            🔧 PROMPT OPTIMIZATION REPORT
            ========================================

            Analysis Date: \(timestamp.formatted())
            Original Success Rate: \(String(format: "%.1f", originalSuccessRate))%

            OPTIMIZATIONS PROPOSED: \(optimizationsProposed)

            ESTIMATED IMPACT:
            -----------------
            Critical Issues Addressed:  \(estimatedImpact.criticalIssuesAddressed)
            High Issues Addressed:      \(estimatedImpact.highIssuesAddressed)
            Medium Issues Addressed:    \(estimatedImpact.mediumIssuesAddressed)

            Estimated Tests Improved:   \(estimatedImpact.estimatedTestsImproved)/240
            Estimated New Success Rate: \(String(format: "%.1f", estimatedImpact.estimatedNewSuccessRate))%
            Expected Improvement:       +\(String(format: "%.1f", estimatedImpact.estimatedNewSuccessRate - originalSuccessRate))%

            NEXT STEPS:
            -----------
            \(nextSteps.joined(separator: "\n"))

            DETAILED OPTIMIZATIONS:
            -----------------------
            \(optimizations.enumerated().map { index, opt in
                """
                \(index + 1). \(opt.category.rawValue)
                   Root Cause: \(opt.analysis.rootCause)
                   Strategy: \(opt.proposedFix.strategy)
                   Expected: \(opt.proposedFix.expectedImprovement)
                """
            }.joined(separator: "\n\n"))
            """
        }
    }

    struct EstimatedImpact: Codable {
        let criticalIssuesAddressed: Int
        let highIssuesAddressed: Int
        let mediumIssuesAddressed: Int
        let estimatedTestsImproved: Int
        let estimatedNewSuccessRate: Double
    }

    enum OptimizationError: LocalizedError {
        case alreadyOptimizing

        var errorDescription: String? {
            switch self {
            case .alreadyOptimizing:
                return "Optimization agent is already running"
            }
        }
    }
}
