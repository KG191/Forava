import Foundation
import SwiftUI
import Combine

// MARK: - Cultural Context Management Service

@MainActor
class CulturalContextManager: ObservableObject {
    static let shared = CulturalContextManager()
    
    @Published var currentCulturalContext: CulturalContext = .rakhi
    @Published var availableCulturalContexts: [CulturalContext] = [.rakhi, .chineseNewYear]
    @Published var isContextSwitching: Bool = false
    
    private let userDefaults = UserDefaults.standard
    private let contextKey = "selected_cultural_context"
    
    private init() {
        loadSavedContext()
    }
    
    // MARK: - Context Management
    
    func switchContext(to context: CulturalContext) {
        guard availableCulturalContexts.contains(context) else {
            print("⚠️ Cultural context not available: \(context.displayName)")
            return
        }
        
        isContextSwitching = true
        
        // Simulate context switching with slight delay for UI feedback
        Task {
            await MainActor.run {
                self.currentCulturalContext = context
                self.saveContext()
                
                // Reset switching state after brief delay
                Task {
                    try await Task.sleep(nanoseconds: 500_000_000) // 0.5 second
                    await MainActor.run {
                        self.isContextSwitching = false
                    }
                }
            }
        }
        
        print("✅ Switched cultural context to: \(context.displayName)")
    }
    
    func addCulturalContext(_ context: CulturalContext) {
        guard !availableCulturalContexts.contains(context) else { return }
        availableCulturalContexts.append(context)
        print("➕ Added cultural context: \(context.displayName)")
    }
    
    // MARK: - Cultural Properties
    
    var currentThemeColors: (primary: Color, secondary: Color, accent: Color) {
        return (
            primary: currentCulturalContext.primaryColor,
            secondary: currentCulturalContext.secondaryColor,
            accent: currentCulturalContext.accentColor
        )
    }
    
    var currentSymbolIcon: String {
        return currentCulturalContext.symbolIcon
    }
    
    var currentDisplayName: String {
        return currentCulturalContext.displayName
    }
    
    // MARK: - Gift Management
    
    func getSampleGifts(for context: CulturalContext? = nil) -> [CulturalGift] {
        let targetContext = context ?? currentCulturalContext
        
        switch targetContext {
        case .rakhi:
            // Convert existing Rakhi samples to CulturalGift
            return Rakhi.sampleRakhis.map { CulturalGift.fromRakhi($0) }
        case .chineseNewYear:
            return CulturalGift.sampleChineseNewYearGifts
        case .christmas, .diwali, .eid, .hanukkah, .vesak:
            // Placeholder - will be implemented as contexts are added
            return []
        }
    }
    
    // MARK: - Backward Compatibility
    
    func getCurrentRakhiSamples() -> [Rakhi] {
        if currentCulturalContext == .rakhi {
            return Rakhi.sampleRakhis
        } else {
            // Convert cultural gifts back to Rakhi for legacy views
            return getSampleGifts().map { $0.toRakhi() }
        }
    }
    
    // MARK: - Persistence
    
    private func saveContext() {
        userDefaults.set(currentCulturalContext.rawValue, forKey: contextKey)
    }
    
    private func loadSavedContext() {
        guard let savedContextString = userDefaults.string(forKey: contextKey),
              let savedContext = CulturalContext(rawValue: savedContextString) else {
            return
        }
        
        if availableCulturalContexts.contains(savedContext) {
            currentCulturalContext = savedContext
        }
    }
    
    // MARK: - Cultural Validation
    
    func validateCulturalAuthenticity(for gift: CulturalGift) -> CulturalValidationResult {
        // Basic cultural authenticity validation
        let authenticity = gift.culturalScore
        
        if authenticity >= 0.95 {
            return .excellent
        } else if authenticity >= 0.80 {
            return .good
        } else if authenticity >= 0.65 {
            return .acceptable
        } else {
            return .needsImprovement
        }
    }
}

// MARK: - Cultural Validation Types

enum CulturalValidationResult {
    case excellent
    case good
    case acceptable
    case needsImprovement
    
    var displayName: String {
        switch self {
        case .excellent: return "Culturally Authentic"
        case .good: return "Good Cultural Representation"
        case .acceptable: return "Acceptable"
        case .needsImprovement: return "Needs Cultural Review"
        }
    }
    
    var icon: String {
        switch self {
        case .excellent: return "checkmark.seal.fill"
        case .good: return "checkmark.circle.fill"
        case .acceptable: return "checkmark.circle"
        case .needsImprovement: return "exclamationmark.triangle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .excellent: return .green
        case .good: return .blue
        case .acceptable: return .orange
        case .needsImprovement: return .red
        }
    }
}