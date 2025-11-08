import SwiftUI

struct CulturalCarouselView: View {
    @State private var selectedEventIndex: Int = 0
    @State private var scrolledID: Int? = 0  // Track scroll position for programmatic scrolling

    let events = CulturalEvent.allEvents
    let onEventSelected: (CulturalEvent) -> Void

    private let cardWidth: CGFloat = 210  // 75% of 280
    private let cardSpacing: CGFloat = 15  // Slightly smaller spacing too

    var body: some View {
        VStack(spacing: 20) {
            // Main Carousel with smooth scrolling
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: cardSpacing) {
                    ForEach(Array(events.enumerated()), id: \.offset) { index, event in
                        CulturalEventCard(
                            event: event,
                            isSelected: selectedEventIndex == index,
                            onTap: {
                                handleCardTap(at: index, event: event)
                            }
                        )
                        .frame(width: cardWidth, alignment: .top)
                        .padding(.bottom, 10) // Extra padding to prevent label cutoff
                        .id(index)
                    }
                }
                .padding(.horizontal, max(20, (UIScreen.main.bounds.width - cardWidth) / 2))
            }
            .scrollPosition(id: $scrolledID, anchor: .center)
            .scrollTargetBehavior(.paging)

            // Page Indicators with tap functionality
            HStack(spacing: 8) {
                ForEach(0..<events.count, id: \.self) { index in
                    Circle()
                        .fill(selectedEventIndex == index ? .white : .white.opacity(0.4))
                        .frame(width: selectedEventIndex == index ? 8 : 6, height: selectedEventIndex == index ? 8 : 6)
                        .scaleEffect(selectedEventIndex == index ? 1.2 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedEventIndex)
                        .onTapGesture {
                            handleIndicatorTap(at: index)
                        }
                }
            }
            .padding(.top, 12)

            // Selected Event Action
            VStack(spacing: 10) {
                if selectedEventIndex < events.count {
                    Button {
                        onEventSelected(events[selectedEventIndex])
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: events[selectedEventIndex].category.icon)
                                .font(.system(.body, design: .rounded).weight(.semibold))

                            Text("Create/Send a \(events[selectedEventIndex].name) Gratitude Gift")
                                .font(.system(.body, design: .rounded).weight(.semibold))
                        }
                        .foregroundStyle(Color(hex: "#C9431A"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(Color(hex: "#FFF0DC"))
                        )
                        .shadow(color: .black.opacity(0.15), radius: 12, y: 6)
                    }
                    .buttonStyle(ScaleButtonStyle())
                    .padding(.horizontal, 24)

                    // Cultural context hint
                    Text(events[selectedEventIndex].culturalContext)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .shadow(color: .black.opacity(0.2), radius: 2, y: 1)
                }
            }
            .padding(.top, 16)
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

    // Unified handler for page indicator tap
    private func handleIndicatorTap(at index: Int) {
        withAnimation(.easeInOut(duration: 0.3)) {
            selectedEventIndex = index
            scrolledID = index
        }

        // Provide haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
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

        CulturalCarouselView { event in
            print("Selected: \(event.name)")
        }
    }
}
