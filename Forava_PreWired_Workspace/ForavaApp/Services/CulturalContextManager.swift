import Foundation
import SwiftUI
import Combine

// MARK: - Cultural Context Manager
@MainActor
class CulturalContextManager: ObservableObject {
    static let shared = CulturalContextManager()

    @Published private(set) var availableContexts: [String: CulturalContext] = [:]
    @Published var currentContext: CulturalContext? {
        didSet {
            if let context = currentContext {
                UserDefaults.standard.set(context.identifier, forKey: "selectedCulturalContext")
                objectWillChange.send()
            }
        }
    }

    private init() {
        loadAvailableContexts()
        loadCurrentContext()
    }

    // MARK: - Context Management

    func registerContext(_ context: CulturalContext) {
        availableContexts[context.identifier] = context

        // If this is the first context or no current context is set, make it current
        if currentContext == nil {
            currentContext = context
        }
    }

    func switchContext(to identifier: String) {
        guard let context = availableContexts[identifier] else {
            print("[CulturalContextManager] Context '\(identifier)' not found")
            return
        }

        currentContext = context
        print("[CulturalContextManager] Switched to cultural context: \(context.displayName)")
    }

    func getContext(for identifier: String) -> CulturalContext? {
        return availableContexts[identifier]
    }

    // MARK: - Design Spec Helpers

    func createDesignSpec(
        genre: CulturalGenre,
        elements: [CulturalDesignElement] = [],
        colorPalette: CulturalColorPalette,
        personalMessage: String? = nil,
        targetAgeGroup: CulturalAgeGroup
    ) -> CulturalDesignSpec? {
        guard let context = currentContext else {
            print("[CulturalContextManager] No current cultural context set")
            return nil
        }

        return CulturalDesignSpec(
            culturalContext: context.identifier,
            genre: genre,
            elements: elements,
            colorPalette: colorPalette,
            personalMessage: personalMessage,
            targetAgeGroup: targetAgeGroup
        )
    }

    func validateDesignSpec(_ spec: CulturalDesignSpec) -> CulturalValidationResult? {
        guard availableContexts[spec.culturalContext] != nil else {
            print("[CulturalContextManager] Context '\(spec.culturalContext)' not found for validation")
            return nil
        }

        // For now, create a simple validation result since validator expects RakhiDesignSpec
        // TODO: Update validator to accept CulturalDesignSpec or create conversion
        return CulturalValidationResult(
            isValid: !spec.elements.isEmpty,
            accuracy: 0.8,
            culturalAuthenticity: 0.8,
            appropriateness: 0.9,
            issues: [],
            suggestions: []
        )
    }

    // MARK: - Element Helpers

    func getCompatibleElements(for genre: CulturalGenre) -> [CulturalDesignElement] {
        guard let context = currentContext else { return [] }

        return context.designElements.filter { element in
            element.compatibleGenreIds.isEmpty || element.compatibleGenreIds.contains(genre.id)
        }
    }

    func getElementsForCategory(_ category: CulturalElementCategory) -> [CulturalDesignElement] {
        guard let context = currentContext else { return [] }

        return context.designElements.compactMap { element in
            element.category == category ? element : nil
        }
    }

    func getAgeAppropriateElements(for ageGroup: CulturalAgeGroup) -> [CulturalDesignElement] {
        guard let context = currentContext else { return [] }

        return context.designElements.filter { element in
            element.ageAppropriate.contains { $0.id == ageGroup.id || $0.id == "any" }
        }
    }

    // MARK: - AI Integration Helpers

    func buildCulturalPrompt(from spec: CulturalDesignSpec) -> (positive: String, negative: String) {
        guard let context = availableContexts[spec.culturalContext] else {
            return ("", "")
        }

        var positivePrompts: [String] = []
        var negativePrompts: [String] = []

        // Add cultural context enhancers
        positivePrompts.append(contentsOf: context.basePromptEnhancers)

        // Add genre-specific prompts
        positivePrompts.append(spec.genre.basePrompt)

        // Add element prompts
        for element in spec.elements {
            positivePrompts.append(contentsOf: element.promptTokens)
        }

        // Add color palette prompts
        positivePrompts.append(contentsOf: spec.colorPalette.promptTokens)

        // Add age-appropriate styling
        positivePrompts.append(contentsOf: spec.targetAgeGroup.preferences)

        // Add cultural negative prompts
        negativePrompts.append(contentsOf: context.culturalNegativePrompts)

        return (
            positive: positivePrompts.joined(separator: ", "),
            negative: negativePrompts.joined(separator: ", ")
        )
    }

    func getPreferredAIModel() -> String {
        return currentContext?.preferredAIModel ?? "default-model"
    }

    func getAnimationStyle() -> CulturalAnimationStyle {
        return currentContext?.animationStyle ?? CulturalAnimationStyle()
    }

    func validateOccasionContext(occasion: String, context: String) -> CulturalValidationResult {
        guard let culturalContext = availableContexts[context] else {
            return CulturalValidationResult(
                isValid: false,
                accuracy: 0.0,
                culturalAuthenticity: 0.0,
                appropriateness: 0.0,
                issues: [CulturalValidationIssue(severity: .critical, description: "Cultural context '\(context)' not found", category: .contextMismatch, suggestedFix: "Use a valid cultural context")],
                suggestions: []
            )
        }

        // Simple validation - could be enhanced with more sophisticated matching
        let isValid = occasion.lowercased() == context.lowercased() ||
                     context.contains(occasion.lowercased()) ||
                     occasion.contains(context.lowercased())

        return CulturalValidationResult(
            isValid: isValid,
            accuracy: isValid ? 0.9 : 0.6,
            culturalAuthenticity: isValid ? 0.9 : 0.6,
            appropriateness: isValid ? 0.9 : 0.6,
            issues: isValid ? [] : [CulturalValidationIssue(severity: .minor, description: "Occasion '\(occasion)' may not align with context '\(context)'", category: .contextMismatch, suggestedFix: nil)],
            suggestions: []
        )
    }

    // MARK: - Private Methods

    private func loadAvailableContexts() {
        // Contexts will be registered by their respective implementation files
        print("[CulturalContextManager] Initialized context manager")
    }

    private func loadCurrentContext() {
        if let savedContextId = UserDefaults.standard.string(forKey: "selectedCulturalContext"),
           let savedContext = availableContexts[savedContextId] {
            currentContext = savedContext
        }
    }
}

// MARK: - Cultural Validation Result
// NOTE: CulturalValidationResult is now defined in CulturalDesignAgentService.swift
// This file uses that authoritative definition

// MARK: - Enhanced Cultural Validator Protocol
protocol CulturalValidatorProtocol {
    func validateDesignSpec(_ spec: CulturalDesignSpec) -> CulturalValidationResult
    func isAppropriate(_ element: CulturalDesignElement, for context: CulturalContext) -> Bool
    func getCulturalScore(for spec: CulturalDesignSpec, in context: CulturalContext) -> Double
    func getRecommendations(for spec: CulturalDesignSpec, in context: CulturalContext) -> [String]
}
