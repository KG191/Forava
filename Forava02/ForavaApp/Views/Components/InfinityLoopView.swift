import SwiftUI

/// Animated infinity loop component with heartbeat-style pulsing
/// Used on the welcome/onboarding screen
struct InfinityLoopView: View {
    @State private var isAnimating = false

    var body: some View {
        Image("rakhi_hero")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 280, height: 160)
            .scaleEffect(isAnimating ? 1.05 : 1.0)
            .animation(
                Animation.easeInOut(duration: 2.0)
                    .repeatForever(autoreverses: true),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [Color.orange.opacity(0.15), Color.white],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()

        InfinityLoopView()
    }
}
