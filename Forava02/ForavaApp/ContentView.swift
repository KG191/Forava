import SwiftUI

struct ContentView: View {
    @State private var selectedEvent: CulturalEvent?
    @State private var navigateToContact = false

    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: Background gradient — orange → light‑orange → deeper orange
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
                    // Push content toward the top area
                    Spacer().frame(height: 24)

                    // MARK: Large, centered Rakhi hero
                    Image("rakhi_hero")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 280, height: 200) // Reduced size to make room for carousel
                        .shadow(color: .black.opacity(0.18), radius: 16, y: 6)
                        .frame(maxWidth: .infinity, alignment: .center) // ensure horizontal centering
                        .padding(.top, 6)

                    // MARK: Header text above title
                    Text("Connect With Loved Ones...")
                        .font(.system(.title2, design: .rounded).weight(.bold))
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
                        .padding(.top, 20)

                    // MARK: Title with dynamic color glance effect
                    AnimatedTitleView()
                        .padding(.top, 16)

                    // Small spacer
                    Spacer().frame(height: 20)

                    // MARK: Cultural Events Carousel
                    CulturalCarouselView { event in
                        selectedEvent = event
                        navigateToContact = true
                    }
                    .padding(.bottom, 32)

                    // Bottom spacer
                    Spacer()
                }
            }
            .toolbar(.hidden, for: .navigationBar) // clean landing page
            .navigationDestination(isPresented: $navigateToContact) {
                if let event = selectedEvent {
                    ContactSelectionView(selectedEvent: event)
                }
            }
        }
    }
}

// Button styles are now defined in SharedUIComponents.swift

// MARK: - Clean Title View (No Animation)
struct AnimatedTitleView: View {
    var body: some View {
        Text("Forava")
            .font(.system(size: 99, weight: .semibold, design: .serif))
            .kerning(0.5)
            .foregroundStyle(.white)
            .shadow(color: .black.opacity(0.15), radius: 8, y: 3)
    }
}


#Preview {
    ContentView()
}
