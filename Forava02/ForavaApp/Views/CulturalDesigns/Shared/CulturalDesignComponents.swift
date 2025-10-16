import SwiftUI
import Foundation

struct ModularTabButton: View {
    let tab: GiftDesignTab
    let isSelected: Bool
    let culturalColor: Color
    let onTap: () -> Void

    // Light orange color for unselected tabs (matching landing page)
    private let unselectedColor = Color(hex: "#FFC170")

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 6) {
                // Tab number indicator
                ZStack {
                    Circle()
                        .fill(isSelected ? culturalColor : unselectedColor.opacity(0.6))
                        .frame(width: 24, height: 24)

                    Text("\(tab.tabNumber)")
                        .font(.system(.caption, design: .rounded).weight(.bold))
                        .foregroundStyle(isSelected ? .white : .white.opacity(0.8))
                }

                // Tab icon
                Image(systemName: tab.icon)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(isSelected ? culturalColor : unselectedColor.opacity(0.8))

                // Tab label
                Text(tab.rawValue)
                    .font(.system(.caption2, design: .rounded).weight(.medium))
                    .foregroundStyle(isSelected ? culturalColor : unselectedColor.opacity(0.8))
            }
            .frame(width: 60)
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

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(GiftDesignTab.allCases, id: \.self) { tab in
                    ModularTabButton(
                        tab: tab,
                        isSelected: currentTab == tab,
                        culturalColor: culturalColor
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            currentTab = tab
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
        }
        .padding(.top, 20)
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
                    .fill(isSelected ? primaryColor.gradient : Color(.systemGray5).gradient)
                    .frame(height: 120)
                    .overlay(
                        VStack(spacing: 8) {
                            Text(theme.rawValue)
                                .font(.system(.title3, design: .rounded).weight(.bold))
                                .foregroundStyle(isSelected ? .white : .primary)
                            Text(description)
                                .font(.system(.caption, design: .rounded))
                                .foregroundStyle(isSelected ? .white.opacity(0.8) : .secondary)
                                .multilineTextAlignment(.center)
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
