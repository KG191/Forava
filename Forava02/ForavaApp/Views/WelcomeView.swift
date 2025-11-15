import SwiftUI

/// Welcome/Onboarding screen shown on first app launch
/// Requires user to configure culture preferences before accessing main app
struct WelcomeView: View {
    @EnvironmentObject var preferences: CulturePreferencesManager
    @State private var showPromptText = false
    @State private var showSettings = false

    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: Background gradient (same as ContentView)
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color(hex: "#FF8A00"), location: 0.00),  // vivid orange (top)
                        .init(color: Color(hex: "#FFC170"), location: 0.52),  // light amber (middle)
                        .init(color: Color(hex: "#E05A00"), location: 1.00)   // deeper orange (bottom)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    // MARK: Title Section (top)
                    VStack(spacing: 12) {
                        Text("Forava")
                            .font(.system(size: 96, weight: .semibold, design: .serif))
                            .kerning(0.5)
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.15), radius: 8, y: 3)

                        Text("Connect with Loved Ones...")
                            .font(.system(.title3, design: .rounded).weight(.medium))
                            .foregroundStyle(.white.opacity(0.9))
                            .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
                    }

                    // MARK: Centered Infinity Loop Section
                    Spacer()

                    VStack(spacing: 24) {
                        InfinityLoopView()

                        // MARK: Prompt Text (fades in after 1 second)
                        if showPromptText {
                            Text("Go to Settings to get started")
                                .font(.system(.body, design: .rounded))
                                .foregroundStyle(.white)
                                .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
                                .transition(.opacity)
                        }
                    }

                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                }
            }
            .fullScreenCover(isPresented: $showSettings) {
                // Full screen presentation on first launch (not dismissible sheet)
                OnboardingSettingsView()
            }
            .onAppear {
                // Fade in prompt text after 1 second
                withAnimation(.easeIn(duration: 0.5).delay(1.0)) {
                    showPromptText = true
                }
            }
        }
    }
}

/// Settings view for onboarding (full screen, requires culture selection)
struct OnboardingSettingsView: View {
    @EnvironmentObject var preferences: CulturePreferencesManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            SettingsView()
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            // Only allow dismissal if at least one culture is selected
                            if !preferences.selectedCultureIDs.isEmpty {
                                preferences.completeOnboarding()
                                dismiss()
                            }
                        }
                        .disabled(preferences.selectedCultureIDs.isEmpty)
                    }
                }
        }
    }
}

#Preview {
    WelcomeView()
        .environmentObject(CulturePreferencesManager())
}
