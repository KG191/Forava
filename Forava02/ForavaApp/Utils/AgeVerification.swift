//
//  AgeVerification.swift
//  Forava
//
//  Created for App Store Compliance
//  Implements age gate requirement per Apple Guideline 1.2.1 (AI-generated content)
//
//  REQUIREMENT: Users must be 12+ to access AI generation features
//  PRIVACY: Birthdate stored locally only (never transmitted)
//

import Foundation

/// Manages age verification for compliance with App Store Guideline 1.2.1
/// AI-generated content apps require age-appropriate access controls
class AgeVerification: ObservableObject {

    // MARK: - Constants

    /// Minimum age required to use Forava (per Age Rating Justification: 12+)
    static let minimumAge = 12

    /// UserDefaults key for storing age verification status
    private static let ageVerifiedKey = "forava_age_verified"

    /// UserDefaults key for storing verified birthdate (for audit/debugging)
    private static let birthdateKey = "forava_birthdate"

    // MARK: - Published Properties

    /// Whether the user has completed age verification
    @Published var isAgeVerified: Bool {
        didSet {
            UserDefaults.standard.set(isAgeVerified, forKey: Self.ageVerifiedKey)
        }
    }

    /// Error message to display if verification fails
    @Published var errorMessage: String?

    // MARK: - Initialization

    init() {
        // Check if user has already verified their age
        self.isAgeVerified = UserDefaults.standard.bool(forKey: Self.ageVerifiedKey)
    }

    // MARK: - Age Verification

    /// Verify if user meets minimum age requirement
    /// - Parameter birthdate: User's date of birth
    /// - Returns: True if user is 12+, false otherwise
    func verifyAge(birthdate: Date) -> Bool {
        // Calculate user's age
        let age = calculateAge(from: birthdate)

        // Check if user meets minimum age
        if age >= Self.minimumAge {
            // Store verification status
            isAgeVerified = true

            // Store birthdate for audit purposes (local only)
            UserDefaults.standard.set(birthdate, forKey: Self.birthdateKey)

            errorMessage = nil
            return true
        } else {
            // User is under minimum age
            errorMessage = "You must be \(Self.minimumAge) or older to use Forava's AI-generated content features."
            return false
        }
    }

    /// Validate birthdate input
    /// - Parameter birthdate: Date to validate
    /// - Returns: True if valid, false with error message if invalid
    func validateBirthdate(_ birthdate: Date) -> Bool {
        let now = Date()

        // Check if birthdate is in the future
        if birthdate > now {
            errorMessage = "Birthdate cannot be in the future. Please enter a valid date."
            return false
        }

        // Check if birthdate is reasonable (not more than 120 years ago)
        let calendar = Calendar.current
        if let minDate = calendar.date(byAdding: .year, value: -120, to: now),
           birthdate < minDate {
            errorMessage = "Please enter a valid birthdate."
            return false
        }

        // Clear error message if validation passes
        errorMessage = nil
        return true
    }

    /// Calculate age from birthdate
    /// - Parameter birthdate: Date of birth
    /// - Returns: Age in years
    func calculateAge(from birthdate: Date) -> Int {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: birthdate, to: now)
        return ageComponents.year ?? 0
    }

    // MARK: - Reset (for testing/debugging)

    /// Reset age verification status (useful for testing)
    /// WARNING: Only use for development/testing
    func resetVerification() {
        isAgeVerified = false
        UserDefaults.standard.removeObject(forKey: Self.ageVerifiedKey)
        UserDefaults.standard.removeObject(forKey: Self.birthdateKey)
        errorMessage = nil
    }

    // MARK: - Privacy Compliance

    /// Check if user can access AI generation features
    /// - Returns: True if age verified, false otherwise
    func canAccessAIGeneration() -> Bool {
        return isAgeVerified
    }

    /// Get stored birthdate (for audit purposes only)
    /// Note: This is local storage only, never transmitted
    func getStoredBirthdate() -> Date? {
        return UserDefaults.standard.object(forKey: Self.birthdateKey) as? Date
    }
}

// MARK: - Preview Helper

#if DEBUG
extension AgeVerification {
    /// Create instance with pre-verified age (for previews/testing)
    static func previewVerified() -> AgeVerification {
        let verification = AgeVerification()
        verification.isAgeVerified = true
        return verification
    }

    /// Create instance with unverified age (for previews/testing)
    static func previewUnverified() -> AgeVerification {
        let verification = AgeVerification()
        verification.isAgeVerified = false
        return verification
    }
}
#endif
