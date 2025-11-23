import SwiftUI

struct CulturalCarouselView: View {
    @EnvironmentObject var preferences: CulturePreferencesManager
    @Binding var showAllCultures: Bool
    @State private var selectedEventIndex: Int = 0
    @State private var scrolledID: Int? = 0  // Track scroll position for programmatic scrolling

    let onEventSelected: (CulturalEvent) -> Void

    private let cardWidth: CGFloat = DeviceInfo.isIPad ? 260 : 210
    private let cardSpacing: CGFloat = DeviceInfo.isIPad ? 25 : 15

    /// Computed property: Display filtered or all events based on toggle
    var displayedEvents: [CulturalEvent] {
        if showAllCultures {
            return CulturalEvent.allEvents
        } else {
            return CulturalEvent.filtered(by: preferences.selectedCultureIDs)
        }
    }

    var body: some View {
        VStack(spacing: DeviceInfo.verticalSpacing(26)) {
            // Main Carousel with smooth scrolling
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: cardSpacing) {
                    ForEach(Array(displayedEvents.enumerated()), id: \.offset) { index, event in
                        CulturalEventCard(
                            event: event,
                            isSelected: selectedEventIndex == index,
                            onTap: {
                                handleCardTap(at: index, event: event)
                            }
                        )
                        .frame(width: cardWidth, alignment: .top)
                        .id(index)
                    }
                }
                .scrollTargetLayout()
                .padding(.horizontal, max(20, (UIScreen.main.bounds.width - cardWidth) / 2))
            }
            .scrollPosition(id: $scrolledID, anchor: .center)
            .scrollTargetBehavior(.viewAligned)
            .onChange(of: scrolledID) { oldValue, newValue in
                if let newIndex = newValue {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedEventIndex = newIndex
                    }
                }
            }

            // Selected Event Action
            VStack(spacing: DeviceInfo.isIPad ? 8 : 5) {
                if !displayedEvents.isEmpty && selectedEventIndex < displayedEvents.count {
                    Button {
                        onEventSelected(displayedEvents[selectedEventIndex])
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: displayedEvents[selectedEventIndex].category.icon)
                                .font(.system(.body, design: .rounded).weight(.semibold))

                            Text("Create/Send a \(displayedEvents[selectedEventIndex].name) Gratitude Gift")
                                .font(.system(.body, design: .rounded).weight(.semibold))
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                        }
                        .foregroundStyle(Color(hex: "#C9431A"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, DeviceInfo.isIPad ? 8 : 4)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(Color(hex: "#FFF0DC"))
                        )
                        .shadow(color: .black.opacity(0.15), radius: 12, y: 6)
                    }
                    .buttonStyle(ScaleButtonStyle())
                    .padding(.horizontal, 24)

                    // Cultural context hint
                    Text(displayedEvents[selectedEventIndex].culturalContext)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .shadow(color: .black.opacity(0.2), radius: 2, y: 1)
                } else if displayedEvents.isEmpty {
                    // Empty state
                    VStack(spacing: 16) {
                        Image(systemName: "square.grid.3x3")
                            .font(.system(size: 60))
                            .foregroundStyle(.white.opacity(0.5))

                        Text("No Cultures Selected")
                            .font(.system(.title3, design: .rounded).weight(.semibold))
                            .foregroundStyle(.white)

                        Text("Go to Settings to choose which cultures you want to see")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundStyle(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    .padding(.vertical, 40)
                }
            }
            .padding(.top, DeviceInfo.isIPad ? -5 : -10)
        }
        .onAppear {
            // Initialize both selection and scroll position immediately
            selectedEventIndex = 0
            scrolledID = 0
        }
    }

    private func selectEvent(at index: Int) {
        selectedEventIndex = index

        // Provide haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }

    // Unified handler for card tap - consolidates state updates to avoid gesture conflicts
    private func handleCardTap(at index: Int, event: CulturalEvent) {
        if selectedEventIndex != index {
            // Selecting a different card - update selection and scroll
            withAnimation(.easeInOut(duration: 0.3)) {
                selectedEventIndex = index
                scrolledID = index
            }

            // Provide haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
        } else {
            // Already selected - navigate to contact selection
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            onEventSelected(event)
        }
    }

}

// Custom button style for the action button
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var showAllCultures = false

        var body: some View {
            ZStack {
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

                CulturalCarouselView(showAllCultures: $showAllCultures) { event in
                    print("Selected: \(event.name)")
                }
                .environmentObject(CulturePreferencesManager())
            }
        }
    }

    return PreviewWrapper()
}
