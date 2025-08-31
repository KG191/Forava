import Foundation
import SwiftUI

// Animation functionality removed - static images only
// This stub file exists to satisfy Xcode project references

@MainActor
class AdvancedAnimationService: ObservableObject {
    static let shared = AdvancedAnimationService()
    
    @Published var generatingAnimation = false
    @Published var animationProgress: Float = 0.0
    
    private init() {}
    
    func resetAnimation() {
        // Stub method
    }
    
    // All animation functionality has been removed - app uses static images only
}