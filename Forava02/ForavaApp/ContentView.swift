import SwiftUI

struct ContentView: View {
    @EnvironmentObject var preferences: CulturePreferencesManager
    @State private var selectedEvent: CulturalEvent?
    @State private var navigateToContact = false
    @State private var showSettings = false
    @State private var showAllCultures = false

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
                .allowsHitTesting(false)  // Allow touches to pass through to content

                VStack(spacing: 0) {
                    // Push content toward the top area
                    Spacer().frame(height: DeviceInfo.adaptiveSpacing(compact: 4, standard: 12, large: -5))

                    // MARK: Large, centered Rakhi hero
                    Image("rakhi_hero")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 280, height: 160) // Reduced size to make room for carousel
                        .shadow(color: .black.opacity(0.18), radius: 16, y: 6)
                        .frame(maxWidth: .infinity, alignment: .center) // ensure horizontal centering
                        .padding(.top, DeviceInfo.adaptiveSpacing(compact: 2, standard: 6, large: 1))

                    // MARK: Header text above title
                    Text("Connect With Loved Ones...")
                        .font(.system(.title2, design: .rounded).weight(.bold))
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
                        .padding(.top, DeviceInfo.adaptiveSpacing(compact: 8, standard: 20, large: 5))

                    // MARK: Title with dynamic color glance effect
                    AnimatedTitleView()
                        .padding(.top, DeviceInfo.adaptiveSpacing(compact: 6, standard: 16, large: 5))

                    // Small spacer
                    Spacer().frame(height: DeviceInfo.adaptiveSpacing(compact: 2, standard: 4, large: 12))

                    // MARK: Cultural Events Carousel with Badge Overlay
                    ZStack(alignment: .bottom) {
                        CulturalCarouselView(showAllCultures: $showAllCultures) { event in
                            selectedEvent = event
                            navigateToContact = true
                        }
                    }
                    .padding(.bottom, DeviceInfo.adaptiveSpacing(compact: 8, standard: 16, large: 24))

                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            showAllCultures.toggle()
                        }
                    } label: {
                        HStack {
                            Image(systemName: showAllCultures ? "checkmark.circle.fill" : "square.grid.3x3.fill")
                                .font(.headline)

                            Text(showAllCultures ? "View My Cultures" : "View All Cultures")
                                .font(.system(.subheadline, design: .rounded).weight(.semibold))
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.ultraThinMaterial)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color.orange, lineWidth: 1.5)
                        )
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
                    }
                    .padding(.top, 4)
                    .padding(.bottom, 16)

                    // Bottom spacer
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
            .navigationDestination(isPresented: $navigateToContact) {
                if let event = selectedEvent {
                    ContactSelectionView(selectedEvent: event)
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }
    }
}

// Button styles are now defined in SharedUIComponents.swift

// MARK: - Clean Title View (No Animation)
struct AnimatedTitleView: View {
    var body: some View {
        Text("Forava")
            .font(.system(size: DeviceInfo.isIPad ? 85 : 99, weight: .semibold, design: .serif))
            .kerning(0.5)
            .foregroundStyle(.white)
            .shadow(color: .black.opacity(0.15), radius: 8, y: 3)
    }
}


#Preview {
    ContentView()
}
