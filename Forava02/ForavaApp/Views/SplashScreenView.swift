import SwiftUI

/// Splash screen displayed during app initialization
/// Shows Forava branding with loading animation while services initialize
struct SplashScreenView: View {
    var body: some View {
        ZStack {
            // Background gradient matching main app
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(hex: "#FF8A00"), location: 0.00),
                    .init(color: Color(hex: "#FFC170"), location: 0.52),
                    .init(color: Color(hex: "#E05A00"), location: 1.00)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {
                // App name
                Text("Forava")
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)

                VStack(spacing: 12) {
                    // Loading indicator
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)

                    // Loading text
                    Text("Initializing...")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.white.opacity(0.9))
                }
                .padding(.top, 32)
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
