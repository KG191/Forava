import SwiftUI
import Foundation

struct ModularTabButton: View {
    let tab: GiftDesignTab
    let isSelected: Bool
    let culturalColor: Color
    let namespace: Namespace.ID
    let onTap: () -> Void

    // Vibrant iOS-standard orange for ALL tabs (master theme color)
    private let masterOrange = Color(hex: "#FF9500")

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 6) {
                // Tab number indicator
                ZStack {
                    Circle()
                        .fill(masterOrange)
                        .frame(width: 24, height: 24)
                        .shadow(
                            color: masterOrange.opacity(0.6),
                            radius: 8,
                            x: 0,
                            y: 0
                        )

                    Text("\(tab.tabNumber)")
                        .font(.system(.caption, design: .rounded).weight(.bold))
                        .foregroundStyle(.white)
                }

                // Tab icon
                Image(systemName: tab.icon)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(isSelected ? .white : masterOrange)

                // Tab label
                Text(tab.rawValue)
                    .font(.system(.caption2, design: .rounded).weight(.medium))
                    .foregroundStyle(isSelected ? .white : masterOrange)
            }
            .frame(width: 60)
            .padding(.vertical, 8)
            .padding(.horizontal, 4)
            .background(
                // Vertical glass indicator for selected tab (Apple HIG standard)
                Group {
                    if isSelected {
                        Capsule()
                            .fill(Color(hex: "#FFC170").opacity(0.7))  // Orange base
                            .overlay(
                                Capsule()
                                    .fill(.white.opacity(0.3))  // White frost (no material desaturation)
                            )
                            .overlay(
                                Capsule()
                                    .stroke(.white.opacity(0.6), lineWidth: 1.5)
                            )
                            .matchedGeometryEffect(id: "tabSelection", in: namespace)
                    }
                }
            )
        }
        .buttonStyle(.plain)
    }
}

struct ModularElementSelectionCard<Element: CaseIterable & RawRepresentable & Hashable>: View
where Element.RawValue == String {
    let element: Element
    let isSelected: Bool
    let culturalColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? culturalColor : Color(.systemGray5))
                    .frame(height: 80)
                    .overlay(
                        Text(element.rawValue)
                            .font(.system(.caption, design: .rounded).weight(.medium))
                            .foregroundStyle(isSelected ? .white : .primary)
                            .multilineTextAlignment(.center)
                            .padding(8)
                    )
            }
        }
        .buttonStyle(.plain)
    }
}

struct ModularColorPaletteCard<ColorPalette: CaseIterable & RawRepresentable & Hashable>: View
where ColorPalette.RawValue == String {
    let palette: ColorPalette
    let isSelected: Bool
    let culturalColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? culturalColor : Color(.systemGray5))
                    .frame(height: 80)
                    .overlay(
                        Text(palette.rawValue)
                            .font(.system(.caption, design: .rounded).weight(.medium))
                            .foregroundStyle(isSelected ? .white : .primary)
                            .multilineTextAlignment(.center)
                            .padding(8)
                    )
            }
        }
        .buttonStyle(.plain)
    }
}

struct ModularThemeSelectionCard<Theme: CaseIterable & RawRepresentable & Hashable>: View
where Theme.RawValue == String {
    let theme: Theme
    let description: String
    let primaryColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(primaryColor.gradient)
                    .frame(height: 120)
                    .overlay(
                        VStack(spacing: 8) {
                            Text(theme.rawValue)
                                .font(.system(.title3, design: .rounded).weight(.bold))
                                .foregroundStyle(.white)
                            Text(description)
                                .font(.system(.caption, design: .rounded))
                                .foregroundStyle(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                    )
            }
        }
        .buttonStyle(.plain)
    }
}

struct ModularPersonalTouchCard<PersonalTouch: CaseIterable & RawRepresentable & Hashable>: View
where PersonalTouch.RawValue == String {
    let message: PersonalTouch
    let isSelected: Bool
    let culturalColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? culturalColor : Color(.systemGray5))
                    .frame(height: 80)
                    .overlay(
                        Text(message.rawValue)
                            .font(.system(.caption, design: .rounded).weight(.medium))
                            .foregroundStyle(isSelected ? .white : .primary)
                            .multilineTextAlignment(.center)
                            .padding(8)
                    )
            }
        }
        .buttonStyle(.plain)
    }
}

struct ModularGenerateGiftButton: View {
    let isEnabled: Bool
    let culturalColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "wand.and.stars")
                Text("Generate Your Personal Designer Gift")
            }
            .font(.system(.headline, design: .rounded).weight(.semibold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isEnabled ? culturalColor : Color(.systemGray4))
            )
        }
        .disabled(!isEnabled)
    }
}

struct ModularCulturalHeaderView: View {
    let selectedContact: Contact
    let selectedEvent: CulturalEvent

    var body: some View {
        VStack(spacing: 12) {
            // Main title centered with icon
            HStack(spacing: 8) {
                Image(systemName: selectedEvent.category.icon)
                    .foregroundStyle(selectedEvent.category.primaryColor)
                    .font(.title2)

                Text(selectedEvent.selectionTitle)
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)

            Text("for \(selectedContact.name)")
                .font(.system(.body, design: .rounded).weight(.medium))
                .foregroundStyle(selectedEvent.category.primaryColor)
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
    }
}

struct ModularCulturalTabNavigationView: View {
    @Binding var currentTab: GiftDesignTab
    let culturalColor: Color

    @State private var scrollOffset: CGFloat = 0
    @State private var contentWidth: CGFloat = 0
    @State private var visibleWidth: CGFloat = 0
    @Namespace private var tabSelection

    private var canScrollLeft: Bool {
        scrollOffset > 10
    }

    private var canScrollRight: Bool {
        // More conservative threshold to prevent chevron from blocking last tab
        // Require at least 80 points of hidden content before showing indicator
        contentWidth > 0 && visibleWidth > 0 && (scrollOffset + visibleWidth < contentWidth - 80)
    }

    var body: some View {
        GeometryReader { outerGeometry in
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    ZStack(alignment: .leading) {
                        // Hidden view to track scroll offset
                        GeometryReader { scrollGeometry in
                            Color.clear.preference(
                                key: ScrollOffsetPreferenceKey.self,
                                value: scrollGeometry.frame(in: .named("scroll")).minX
                            )
                        }
                        .frame(height: 0)

                        HStack(spacing: 16) {
                            ForEach(GiftDesignTab.allCases, id: \.self) { tab in
                                ModularTabButton(
                                    tab: tab,
                                    isSelected: currentTab == tab,
                                    culturalColor: culturalColor,
                                    namespace: tabSelection
                                ) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        currentTab = tab
                                    }
                                }
                                .id(tab)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            GeometryReader { contentGeometry in
                                Color.clear.onAppear {
                                    contentWidth = contentGeometry.size.width
                                }
                                .onChange(of: contentGeometry.size.width) { _, newWidth in
                                    contentWidth = newWidth
                                }
                            }
                        )
                    }
                }
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    scrollOffset = -value
                }
                .onAppear {
                    visibleWidth = outerGeometry.size.width
                }
                .onChange(of: outerGeometry.size.width) { _, newWidth in
                    visibleWidth = newWidth
                }
                .onChange(of: currentTab) { _, newTab in
                    withAnimation(.easeInOut(duration: 0.3)) {
                        proxy.scrollTo(newTab, anchor: .center)
                    }
                }
            }
            // Left edge gradient with chevron
            .overlay(alignment: .leading) {
                if canScrollLeft {
                    HStack(spacing: 0) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(8)
                            .background(culturalColor.opacity(0.9))
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)

                        LinearGradient(
                            colors: [.white.opacity(0.9), .white.opacity(0)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: 50)
                    }
                    .padding(.leading, 8)
                }
            }
            // Right edge - no chevron (removed to prevent blocking Tab 7)
            // Auto-scroll behavior preserved through ScrollViewReader
        }
        .frame(height: 100)
        .padding(.top, 20)
    }
}

// MARK: - Scroll Offset Preference Key
private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Commonly Used Components Referenced by Cultural Design Views

struct StyleCard<Theme: CaseIterable & RawRepresentable & Hashable>: View where Theme.RawValue == String {
    let theme: Theme
    let description: String
    let primaryColor: Color
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: isSelected ?
                                [primaryColor.opacity(0.9), primaryColor.opacity(0.7)] :  // Stronger opacity for readability
                                [primaryColor.opacity(0.15), primaryColor.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 120)
                    .overlay(
                        VStack(spacing: 8) {
                            Text(theme.rawValue)
                                .font(.system(.title3, design: .rounded).weight(.bold))
                                .foregroundStyle(.white)  // Always white for maximum contrast
                                .shadow(color: .black.opacity(isSelected ? 0.3 : 0), radius: 2, x: 0, y: 1)  // Text shadow when selected
                            Text(description)
                                .font(.system(.caption, design: .rounded))
                                .foregroundStyle(isSelected ? .white.opacity(0.95) : .secondary)
                                .multilineTextAlignment(.center)
                                .shadow(color: .black.opacity(isSelected ? 0.2 : 0), radius: 1, x: 0, y: 1)
                        }
                        .padding()
                    )
            }
        }
        .buttonStyle(.plain)
    }
}

struct SelectionSummaryCard: View {
    let title: String
    let content: String
    let isComplete: Bool
    let culturalColor: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: isComplete ? "checkmark.circle.fill" : "circle")
                .font(.title2)
                .foregroundStyle(isComplete ? culturalColor : .secondary)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
                Text(content)
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    .foregroundStyle(isComplete ? .primary : .secondary)
            }

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isComplete ? culturalColor.opacity(0.1) : Color(.systemGray6))
        )
    }
}

struct CheckTabContent: View {
    let selectedEvent: CulturalEvent
    let selectedContact: Contact

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 16) {
                Text("Review Your Design")
                    .font(.system(.title2, design: .rounded).weight(.bold))

                Text("Your personalized \(selectedEvent.name.lowercased()) design is ready for \(selectedContact.name)")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Spacer()

            Button("Generate Gift") {
                // Generation action handled by parent view
            }
            .font(.system(.headline, design: .rounded).weight(.semibold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(selectedEvent.category.primaryColor)
            .cornerRadius(12)
        }
        .padding()
    }
}

struct SendTabContent: View {
    let selectedEvent: CulturalEvent
    let selectedContact: Contact

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 16) {
                Text("Send Your Gift")
                    .font(.system(.title2, design: .rounded).weight(.bold))

                Text("Share your personalized \(selectedEvent.name.lowercased()) gift with \(selectedContact.name)")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Spacer()

            VStack(spacing: 12) {
                Button("Share via Messages") {
                    // Share action handled by parent view
                }
                .font(.system(.headline, design: .rounded).weight(.semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(selectedEvent.category.primaryColor)
                .cornerRadius(12)

                Button("Save to Photos") {
                    // Save action handled by parent view
                }
                .font(.system(.headline, design: .rounded).weight(.semibold))
                .foregroundStyle(selectedEvent.category.primaryColor)
                .frame(maxWidth: .infinity)
                .padding()
                .background(selectedEvent.category.primaryColor.opacity(0.1))
                .cornerRadius(12)
            }
        }
        .padding()
    }
}

// MARK: - Placeholder Cultural View
struct PlaceholderCulturalView: View {
    let selectedContact: Contact
    let selectedEvent: CulturalEvent
    let cultureName: String

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "calendar.badge.plus")
                .font(.largeTitle)
                .foregroundColor(.blue)

            Text("\(cultureName) Design Studio")
                .font(.title)
                .fontWeight(.semibold)

            Text("Creating personalized \(cultureName.lowercased()) gifts for \(selectedContact.name)")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)

            VStack(spacing: 12) {
                Text("Coming Soon:")
                    .font(.headline)
                    .foregroundColor(.primary)

                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Image(systemName: "paintbrush.fill")
                        Text("Cultural design templates")
                    }
                    HStack {
                        Image(systemName: "wand.and.rays")
                        Text("AI-powered personalization")
                    }
                    HStack {
                        Image(systemName: "heart.fill")
                        Text("Traditional cultural elements")
                    }
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .padding()
        .navigationTitle("\(cultureName) Design")
        .navigationBarTitleDisplayMode(.inline)
    }
}
