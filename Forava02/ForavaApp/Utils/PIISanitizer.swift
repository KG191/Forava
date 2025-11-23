//
//  PIISanitizer.swift
//  Forava
//
//  Created for App Store Compliance
//  PII sanitization for AI prompts (per Apple Privacy Guidelines)
//
//  REQUIREMENT: No personal information in AI prompts
//  COMPLIANCE: LEGAL-004 in ACTION_ITEMS_BACKLOG.md
//  PRIVACY POLICY: "No personal information included in AI prompts"
//

import Foundation

/// Sanitizes personally identifiable information (PII) from text before sending to AI services
/// Ensures compliance with privacy policy and Apple guidelines
class PIISanitizer {

    // MARK: - Singleton

    static let shared = PIISanitizer()
    private init() {}

    // MARK: - Detection Patterns

    /// Email address regex pattern
    private let emailPattern = #"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}"#

    /// Phone number patterns (US and international)
    private let phonePatterns = [
        #"\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}"#,  // US format
        #"\+\d{1,3}[-.\s]?\(?\d{1,4}\)?[-.\s]?\d{1,4}[-.\s]?\d{1,9}"#,  // International
        #"\d{3}[-.\s]?\d{3}[-.\s]?\d{4}"#  // Simple US
    ]

    /// Common name patterns (first, last, full names)
    /// Note: This is conservative - only removes when explicitly marked as names
    private let nameMarkers = [
        "name:", "named", "called", "my name is", "i am", "i'm",
        "from:", "to:", "dear", "hi", "hello", "sincerely"
    ]

    /// Address patterns
    private let addressPatterns = [
        #"\d+\s+[\w\s]+(?:street|st|avenue|ave|road|rd|highway|hwy|square|sq|trail|trl|drive|dr|court|ct|parkway|pkwy|circle|cir|boulevard|blvd)\b"#,
        #"\b\d{5}(?:-\d{4})?\b"#  // ZIP codes
    ]

    /// Social security number pattern
    private let ssnPattern = #"\b\d{3}-\d{2}-\d{4}\b"#

    /// Credit card patterns
    private let creditCardPattern = #"\b\d{4}[-\s]?\d{4}[-\s]?\d{4}[-\s]?\d{4}\b"#

    // MARK: - Public Methods

    /// Sanitize text by removing all PII
    /// - Parameter text: Input text potentially containing PII
    /// - Returns: Sanitized text with PII removed
    func sanitizePrompt(_ text: String) -> String {
        var sanitized = text

        // Remove emails
        sanitized = removePattern(from: sanitized, pattern: emailPattern, replacement: "[EMAIL_REMOVED]")

        // Remove phone numbers
        for phonePattern in phonePatterns {
            sanitized = removePattern(from: sanitized, pattern: phonePattern, replacement: "[PHONE_REMOVED]")
        }

        // Remove addresses
        for addressPattern in addressPatterns {
            sanitized = removePattern(from: sanitized, pattern: addressPattern, replacement: "[ADDRESS_REMOVED]")
        }

        // Remove SSN
        sanitized = removePattern(from: sanitized, pattern: ssnPattern, replacement: "[SSN_REMOVED]")

        // Remove credit cards
        sanitized = removePattern(from: sanitized, pattern: creditCardPattern, replacement: "[CC_REMOVED]")

        // Remove names when explicitly mentioned (conservative approach)
        sanitized = removeExplicitNames(from: sanitized)

        return sanitized
    }

    /// Check if text contains PII
    /// - Parameter text: Input text to check
    /// - Returns: True if PII detected, false otherwise
    func containsPII(_ text: String) -> Bool {
        // Check emails
        if matches(text: text, pattern: emailPattern) {
            return true
        }

        // Check phone numbers
        for phonePattern in phonePatterns {
            if matches(text: text, pattern: phonePattern) {
                return true
            }
        }

        // Check addresses
        for addressPattern in addressPatterns {
            if matches(text: text, pattern: addressPattern) {
                return true
            }
        }

        // Check SSN
        if matches(text: text, pattern: ssnPattern) {
            return true
        }

        // Check credit cards
        if matches(text: text, pattern: creditCardPattern) {
            return true
        }

        return false
    }

    /// Remove PII and return sanitized text with detection info
    /// - Parameter text: Input text to sanitize
    /// - Returns: SanitizationResult with sanitized text and detection details
    func sanitizeWithResult(_ text: String) -> SanitizationResult {
        let original = text
        let sanitized = sanitizePrompt(text)
        let hadPII = original != sanitized

        var detectedTypes: [PIIType] = []

        if matches(text: original, pattern: emailPattern) {
            detectedTypes.append(.email)
        }

        for phonePattern in phonePatterns {
            if matches(text: original, pattern: phonePattern) {
                if !detectedTypes.contains(.phone) {
                    detectedTypes.append(.phone)
                }
            }
        }

        for addressPattern in addressPatterns {
            if matches(text: original, pattern: addressPattern) {
                if !detectedTypes.contains(.address) {
                    detectedTypes.append(.address)
                }
            }
        }

        if matches(text: original, pattern: ssnPattern) {
            detectedTypes.append(.ssn)
        }

        if matches(text: original, pattern: creditCardPattern) {
            detectedTypes.append(.creditCard)
        }

        return SanitizationResult(
            originalText: original,
            sanitizedText: sanitized,
            hadPII: hadPII,
            detectedTypes: detectedTypes
        )
    }

    // MARK: - Private Helper Methods

    /// Remove pattern matches from text
    private func removePattern(from text: String, pattern: String, replacement: String) -> String {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else {
            return text
        }

        let range = NSRange(text.startIndex..., in: text)
        return regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: replacement)
    }

    /// Check if text matches pattern
    private func matches(text: String, pattern: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else {
            return false
        }

        let range = NSRange(text.startIndex..., in: text)
        return regex.firstMatch(in: text, options: [], range: range) != nil
    }

    /// Remove names when explicitly mentioned (e.g., "My name is John")
    private func removeExplicitNames(from text: String) -> String {
        var sanitized = text
        let lowercased = text.lowercased()

        for marker in nameMarkers {
            if let range = lowercased.range(of: marker) {
                // Find the next few words after the marker
                let afterMarker = String(text[range.upperBound...])
                let words = afterMarker.components(separatedBy: .whitespaces)

                // Remove up to 3 words after name markers (conservative)
                if words.count >= 2 {
                    let nameWords = words.prefix(3).joined(separator: " ")
                    sanitized = sanitized.replacingOccurrences(of: marker + " " + nameWords, with: marker + " [NAME_REMOVED]", options: .caseInsensitive)
                }
            }
        }

        return sanitized
    }
}

// MARK: - Supporting Types

/// Result of PII sanitization
struct SanitizationResult {
    /// Original input text
    let originalText: String

    /// Sanitized text with PII removed
    let sanitizedText: String

    /// Whether PII was detected and removed
    let hadPII: Bool

    /// Types of PII detected
    let detectedTypes: [PIIType]

    /// Log message for compliance auditing
    var logMessage: String {
        if hadPII {
            let types = detectedTypes.map { $0.rawValue }.joined(separator: ", ")
            return "PII detected and sanitized: \(types)"
        } else {
            return "No PII detected"
        }
    }
}

/// Types of personally identifiable information
enum PIIType: String, Equatable {
    case email = "Email"
    case phone = "Phone Number"
    case address = "Address"
    case ssn = "Social Security Number"
    case creditCard = "Credit Card"
    case name = "Name"
}
