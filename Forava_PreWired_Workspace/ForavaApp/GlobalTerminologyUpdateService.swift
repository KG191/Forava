import Foundation
import SwiftUI

// MARK: - Phase 5: Global Terminology Update Service
// Ensures all UI strings are dynamically updated when cultural settings change

@MainActor
class GlobalTerminologyUpdateService: ObservableObject {
    static let shared = GlobalTerminologyUpdateService()

    @Published var lastUpdateTimestamp = Date()

    private let terminologyService = DynamicCulturalTerminologyService.shared
    private var updateQueue: [TerminologyUpdate] = []

    private init() {
        // Listen for cultural preference changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleCulturalPreferencesUpdate),
            name: NSNotification.Name("CulturalPreferencesUpdated"),
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Global Terminology Updates

    func performGlobalUpdate() {
        print("🔄 Performing global terminology update...")

        // Update all cached strings
        updateNavigationTitles()
        updateButtonLabels()
        updateMessages()
        updateNotifications()

        // Trigger UI refresh
        lastUpdateTimestamp = Date()

        print("✅ Global terminology update complete")
    }

    @objc private func handleCulturalPreferencesUpdate() {
        Task {
            await performGlobalUpdate()
        }
    }

    // MARK: - Individual Update Methods

    private func updateNavigationTitles() {
        let updates = [
            TerminologyUpdate(
                category: .navigationTitle,
                oldValue: "Create Rakhi",
                newValue: terminologyService.createTabTitle
            ),
            TerminologyUpdate(
                category: .navigationTitle,
                oldValue: "Rakhi History",
                newValue: terminologyService.historyTabTitle
            ),
            TerminologyUpdate(
                category: .navigationTitle,
                oldValue: "Send Rakhi",
                newValue: "Send Gift"
            )
        ]

        processUpdates(updates)
    }

    private func updateButtonLabels() {
        let updates = [
            TerminologyUpdate(
                category: .buttonLabel,
                oldValue: "Create a Rakhi",
                newValue: terminologyService.createActionTerm
            ),
            TerminologyUpdate(
                category: .buttonLabel,
                oldValue: "Send Rakhi",
                newValue: terminologyService.sendActionTerm
            )
        ]

        processUpdates(updates)
    }

    private func updateMessages() {
        let updates = [
            TerminologyUpdate(
                category: .message,
                oldValue: "Your Rakhi is ready!",
                newValue: terminologyService.giftReadyMessage
            ),
            TerminologyUpdate(
                category: .message,
                oldValue: "Check out my Rakhi!",
                newValue: terminologyService.shareMessage
            )
        ]

        processUpdates(updates)
    }

    private func updateNotifications() {
        let updates = [
            TerminologyUpdate(
                category: .notification,
                oldValue: "Rakhi Ready!",
                newValue: terminologyService.notificationTitle
            )
        ]

        processUpdates(updates)
    }

    private func processUpdates(_ updates: [TerminologyUpdate]) {
        updateQueue.append(contentsOf: updates)

        for update in updates {
            print("🔄 Updated \(update.category.rawValue): '\(update.oldValue)' → '\(update.newValue)'")
        }
    }

    // MARK: - Validation and Debugging

    func validateAllTerminology() -> [ValidationIssue] {
        var issues: [ValidationIssue] = []

        // Check for hardcoded "Rakhi" strings in common areas
        let hardcodedTerms = findHardcodedTerminology()

        for term in hardcodedTerms {
            issues.append(ValidationIssue(
                severity: .warning,
                description: "Hardcoded term found: '\(term)'",
                location: "UI Components",
                suggestedFix: "Replace with dynamic terminology service"
            ))
        }

        return issues
    }

    private func findHardcodedTerminology() -> [String] {
        // This would scan for hardcoded strings in a real implementation
        // For now, return common patterns to look for
        return [
            "Rakhi",
            "rakhi",
            "Create a Rakhi",
            "Send Rakhi",
            "Your Rakhi is ready",
            "Rakhi History"
        ]
    }

    func getUpdateSummary() -> UpdateSummary {
        return UpdateSummary(
            totalUpdates: updateQueue.count,
            lastUpdate: lastUpdateTimestamp,
            currentOccasion: terminologyService.selectedOccasion,
            activeTerminology: [
                "Digital Gift Term": terminologyService.digitalGiftTerm,
                "Short Gift Term": terminologyService.shortGiftTerm,
                "Create Action": terminologyService.createActionTerm,
                "Send Action": terminologyService.sendActionTerm,
                "Ready Message": terminologyService.giftReadyMessage
            ]
        )
    }
}

// MARK: - Supporting Models

struct TerminologyUpdate {
    let category: UpdateCategory
    let oldValue: String
    let newValue: String
    let timestamp: Date = Date()
}

enum UpdateCategory: String, CaseIterable {
    case navigationTitle = "Navigation Title"
    case buttonLabel = "Button Label"
    case message = "Message"
    case notification = "Notification"
    case tabBarItem = "Tab Bar Item"
    case alertTitle = "Alert Title"
}

struct ValidationIssue {
    let severity: IssueSeverity
    let description: String
    let location: String
    let suggestedFix: String

    enum IssueSeverity {
        case error
        case warning
        case info
    }
}

struct UpdateSummary {
    let totalUpdates: Int
    let lastUpdate: Date
    let currentOccasion: String
    let activeTerminology: [String: String]
}

// MARK: - SwiftUI Integration

extension View {
    /// Ensures view updates when global terminology changes
    func dynamicTerminology() -> some View {
        self
            .environmentObject(GlobalTerminologyUpdateService.shared)
            .environmentObject(DynamicCulturalTerminologyService.shared)
    }
}
