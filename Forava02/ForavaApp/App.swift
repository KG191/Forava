import SwiftUI

@main
struct ForavaApp: App {
    @StateObject private var preferences = CulturePreferencesManager()
    @StateObject private var ageVerification = AgeVerification()
    @State private var isInitializing = true

    var body: some Scene {
        WindowGroup {
            if isInitializing {
                // Show splash screen during initialization
                SplashScreenView()
                    .onAppear {
                        // Initialize services in background
                        Task {
                            // Give UI time to render splash screen
                            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds

                            // Trigger singleton initialization (this starts StoreKit)
                            _ = ComprehensivePaymentService.shared

                            // CRITICAL FIX: Load IAP products from App Store Connect
                            // This ensures products are available when PaywallView appears
                            await ComprehensivePaymentService.shared.loadAllProducts()

                            // Wait for StoreKit initialization to complete
                            // This prevents the freeze from happening during main UI
                            try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds

                            // Transition to main app
                            await MainActor.run {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    isInitializing = false
                                }
                            }
                        }
                    }
            } else {
                // MARK: Age Gate Flow (Compliance: Apple Guideline 1.2.1)
                // Age verification required before accessing AI-generated content
                if !ageVerification.isAgeVerified {
                    AgeGateView()
                        .environmentObject(ageVerification)
                } else if preferences.isFirstLaunch() {
                    WelcomeView()
                        .environmentObject(preferences)
                        .environmentObject(ageVerification)
                } else {
                    ContentView()
                        .environmentObject(preferences)
                        .environmentObject(ageVerification)
                }
            }
        }
    }
}
