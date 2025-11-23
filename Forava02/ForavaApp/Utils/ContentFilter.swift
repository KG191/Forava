//
//  ContentFilter.swift
//  Forava
//
//  Created for App Store Compliance
//  Enhanced content filtering for UGC moderation (per Apple Guideline 1.2.1)
//
//  REQUIREMENT: Filter inappropriate content before AI generation
//  COMPLIANCE: SAFETY-002 in ACTION_ITEMS_BACKLOG.md
//

import Foundation

/// Comprehensive content filtering for user-generated text inputs
/// Detects profanity, hate speech, violence, sexual content, and other inappropriate material
class ContentFilter {

    // MARK: - Singleton

    static let shared = ContentFilter()
    private init() {}

    // MARK: - Filter Categories

    /// Profanity and vulgar language patterns
    private let profanityPatterns: [String] = [
        // Common profanity (partial list - add more as needed)
        "damn", "hell", "crap", "piss", "bastard",
        "bitch", "ass", "asshole", "shit", "fuck",
        "motherfuck", "dickhead", "cock", "pussy",
        "whore", "slut"
    ]

    /// Hate speech and discriminatory language
    private let hateSpeechPatterns: [String] = [
        // Racial slurs (partial list)
        "chink", "gook", "spic", "wetback", "raghead",
        // Religious hate
        "infidel attack", "terrorist", "jihad attack",
        // General hate
        "nazi", "hitler worship", "genocide", "ethnic cleansing"
    ]

    /// Violence and threats
    private let violencePatterns: [String] = [
        // Direct threats
        "kill you", "murder you", "assassinate", "execute you",
        "bomb", "explode", "attack you", "terrorize",
        "shoot you", "stab you", "hurt you badly",
        // Weapons in threatening context
        "gun attack", "knife attack", "weapon threat",
        // Violent acts
        "torture", "mutilate", "dismember", "decapitate",
        "lynch", "strangle"
    ]

    /// Sexual and inappropriate content
    private let sexualPatterns: [String] = [
        // Explicit sexual terms
        "porn", "pornography", "xxx content",
        "nude photo", "naked picture",
        // Inappropriate acts
        "rape", "molest", "sexual assault", "abuse children"
    ]

    // MARK: - Public Methods

    /// Check if text contains inappropriate content
    /// - Parameter text: User input to validate
    /// - Returns: FilterResult with detected violations
    func validateContent(_ text: String) -> FilterResult {
        let normalizedText = text.lowercased()

        var detectedCategories: [ViolationCategory] = []
        var matchedTerms: [String] = []

        // Check profanity
        for pattern in profanityPatterns {
            if normalizedText.contains(pattern) {
                if !detectedCategories.contains(.profanity) {
                    detectedCategories.append(.profanity)
                }
                matchedTerms.append(pattern)
            }
        }

        // Check hate speech
        for pattern in hateSpeechPatterns {
            if normalizedText.contains(pattern) {
                if !detectedCategories.contains(.hateSpeech) {
                    detectedCategories.append(.hateSpeech)
                }
                matchedTerms.append(pattern)
            }
        }

        // Check violence
        for pattern in violencePatterns {
            if normalizedText.contains(pattern) {
                if !detectedCategories.contains(.violence) {
                    detectedCategories.append(.violence)
                }
                matchedTerms.append(pattern)
            }
        }

        // Check sexual content
        for pattern in sexualPatterns {
            if normalizedText.contains(pattern) {
                if !detectedCategories.contains(.sexualContent) {
                    detectedCategories.append(.sexualContent)
                }
                matchedTerms.append(pattern)
            }
        }

        let isClean = detectedCategories.isEmpty

        return FilterResult(
            isClean: isClean,
            violationCategories: detectedCategories,
            matchedTerms: matchedTerms,
            originalText: text
        )
    }

    /// Sanitize text by removing/replacing inappropriate content
    /// - Parameter text: User input to sanitize
    /// - Returns: Sanitized text with inappropriate content removed
    func sanitizeContent(_ text: String) -> String {
        var sanitized = text

        // Replace profanity with asterisks
        for pattern in profanityPatterns {
            let replacement = String(repeating: "*", count: pattern.count)
            sanitized = sanitized.replacingOccurrences(
                of: pattern,
                with: replacement,
                options: .caseInsensitive
            )
        }

        // Replace hate speech, violence, and sexual content
        let allPatterns = hateSpeechPatterns + violencePatterns + sexualPatterns
        for pattern in allPatterns {
            sanitized = sanitized.replacingOccurrences(
                of: pattern,
                with: "[FILTERED]",
                options: .caseInsensitive
            )
        }

        return sanitized
    }
}

// MARK: - Supporting Types

/// Result of content filtering validation
struct FilterResult {
    /// Whether the content passed all filters
    let isClean: Bool

    /// Categories of violations detected
    let violationCategories: [ViolationCategory]

    /// Specific terms that triggered the filter
    let matchedTerms: [String]

    /// Original input text
    let originalText: String

    /// User-friendly error message
    var errorMessage: String {
        if isClean {
            return ""
        }

        let categories = violationCategories.map { $0.rawValue }.joined(separator: ", ")
        return "Your message contains inappropriate content (\(categories)). Please revise your message and try again."
    }
}

/// Categories of content violations
enum ViolationCategory: String, Equatable {
    case profanity = "Profanity"
    case hateSpeech = "Hate Speech"
    case violence = "Violence"
    case sexualContent = "Sexual Content"
}
