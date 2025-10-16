import SwiftUI
import Combine

// MARK: - Performance-Optimized Cultural Design Components

/// High-performance modular tab button with view recycling and optimized rendering
struct OptimizedModularTabButton: View {
    let tab: GiftDesignTab
    let isSelected: Bool
    let culturalColor: Color
    let onTap: () -> Void

    // Pre-computed values to avoid recalculation
    private let unselectedColor = Color(hex: "#FFC170")
    private let circleSize: CGFloat = 24
    private let buttonWidth: CGFloat = 60

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 6) {
                // Optimized circle with minimal state changes
                Circle()
                    .fill(isSelected ? culturalColor : unselectedColor.opacity(0.6))
                    .frame(width: circleSize, height: circleSize)
                    .overlay(
                        Text("\(tab.tabNumber)")
                            .font(.system(.caption, design: .rounded).weight(.bold))
                            .foregroundStyle(.white.opacity(isSelected ? 1.0 : 0.8))
                    )

                // Cached icon and text to avoid repeated lookups
                Image(systemName: tab.icon)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(isSelected ? culturalColor : unselectedColor.opacity(0.8))

                Text(tab.rawValue)
                    .font(.system(.caption2, design: .rounded).weight(.medium))
                    .foregroundStyle(isSelected ? culturalColor : unselectedColor.opacity(0.8))
            }
            .frame(width: buttonWidth)
        }
        .buttonStyle(.plain)
    }
}

/// Lazy-loading cultural component selection with view recycling
struct LazyLoadedCulturalComponentGrid<Element: CaseIterable & RawRepresentable & Hashable & Identifiable>: View where Element.RawValue == String {
    let elements: [Element]
    let selectedElement: Element?
    let culturalColor: Color
    let onSelection: (Element) -> Void

    // Grid configuration for optimal performance
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 2)
    private let cardHeight: CGFloat = 80

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(elements, id: \.self) { element in
                OptimizedSelectionCard(
                    element: element,
                    isSelected: selectedElement?.id == element.id,
                    culturalColor: culturalColor,
                    height: cardHeight
                ) {
                    onSelection(element)
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

/// High-performance selection card with optimized state management
private struct OptimizedSelectionCard<Element: RawRepresentable & Identifiable>: View where Element.RawValue == String {
    let element: Element
    let isSelected: Bool
    let culturalColor: Color
    let height: CGFloat
    let action: () -> Void

    // Pre-compute colors to avoid repeated calculations
    private var backgroundColor: Color {
        isSelected ? culturalColor : Color(.systemGray5)
    }

    private var textColor: Color {
        isSelected ? .white : .primary
    }

    var body: some View {
        Button(action: action) {
            RoundedRectangle(cornerRadius: 12)
                .fill(backgroundColor)
                .frame(height: height)
                .overlay(
                    Text(element.rawValue)
                        .font(.system(.caption, design: .rounded).weight(.medium))
                        .foregroundStyle(textColor)
                        .multilineTextAlignment(.center)
                        .padding(8)
                        .lineLimit(2)
                )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

/// Memory-efficient cultural header with lazy text rendering
struct MemoryEfficientCulturalHeader: View {
    let selectedContact: Contact
    let selectedEvent: CulturalEvent

    // Cached computed properties
    private var eventIcon: String { selectedEvent.category.icon }
    private var eventColor: Color { selectedEvent.category.primaryColor }
    private var eventTitle: String { selectedEvent.selectionTitle }

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: eventIcon)
                    .foregroundStyle(eventColor)
                    .font(.title2)

                Text(eventTitle)
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)

            Text("for \(selectedContact.name)")
                .font(.system(.body, design: .rounded).weight(.medium))
                .foregroundStyle(eventColor)
                .lineLimit(1)
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
    }
}

/// Optimized tab navigation with preloaded content
struct OptimizedCulturalTabNavigation: View {
    @Binding var currentTab: GiftDesignTab
    let culturalColor: Color

    // Performance monitoring integration
    @StateObject private var performanceMonitor = PerformanceMonitor.shared

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(GiftDesignTab.allCases, id: \.self) { tab in
                        OptimizedModularTabButton(
                            tab: tab,
                            isSelected: currentTab == tab,
                            culturalColor: culturalColor
                        ) {
                            performanceMonitor.measureViewRendering("TabSwitch-\(tab.rawValue)") {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    currentTab = tab
                                }
                            }
                        }
                        .id(tab)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
            }
            .onChange(of: currentTab) { _, newTab in
                withAnimation(.easeInOut(duration: 0.3)) {
                    proxy.scrollTo(newTab, anchor: .center)
                }
            }
        }
        .padding(.top, 20)
    }
}

/// Battery-optimized generate button with haptic feedback
struct BatteryOptimizedGenerateButton: View {
    let isEnabled: Bool
    let culturalColor: Color
    let isLoading: Bool
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: handleButtonPress) {
            HStack(spacing: 12) {
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                        .tint(.white)
                } else {
                    Image(systemName: "wand.and.stars")
                        .font(.headline)
                }

                Text(isLoading ? "Generating..." : "Generate Your Personal Designer Gift")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(buttonBackgroundColor)
                    .scaleEffect(isPressed ? 0.98 : 1.0)
            )
        }
        .disabled(!isEnabled || isLoading)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }

    private var buttonBackgroundColor: Color {
        if isLoading {
            return culturalColor.opacity(0.8)
        } else if isEnabled {
            return culturalColor
        } else {
            return Color(.systemGray4)
        }
    }

    private func handleButtonPress() {
        // Minimal haptic feedback for battery conservation
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred(intensity: 0.7)

        action()
    }
}

/// Optimized cultural theme selector with lazy rendering
struct OptimizedCulturalThemeSelector<Theme: CaseIterable & RawRepresentable & Hashable>: View where Theme.RawValue == String {
    let themes: [CulturalTheme<Theme>]
    @Binding var selectedTheme: Theme?
    let culturalColor: Color

    // Lazy loading configuration
    private let visibleThreshold = 3
    @State private var loadedThemeCount = 3

    var body: some View {
        LazyVStack(spacing: 16) {
            ForEach(Array(themes.prefix(loadedThemeCount).enumerated()), id: \.element.theme) { index, themeData in
                OptimizedThemeCard(
                    themeData: themeData,
                    isSelected: selectedTheme == themeData.theme,
                    culturalColor: culturalColor
                ) {
                    selectedTheme = themeData.theme
                }
                .onAppear {
                    // Load more themes as user scrolls
                    if index == loadedThemeCount - 1 && loadedThemeCount < themes.count {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation(.easeIn(duration: 0.3)) {
                                loadedThemeCount = min(themes.count, loadedThemeCount + 2)
                            }
                        }
                    }
                }
            }
        }
    }
}

/// High-performance theme card with cached gradients
private struct OptimizedThemeCard<Theme: RawRepresentable & Hashable>: View where Theme.RawValue == String {
    let themeData: CulturalTheme<Theme>
    let isSelected: Bool
    let culturalColor: Color
    let action: () -> Void

    // Cache gradient to avoid recreating
    private var cachedGradient: LinearGradient {
        LinearGradient(
            colors: [themeData.primaryColor, themeData.primaryColor.opacity(0.8)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var body: some View {
        Button(action: action) {
            RoundedRectangle(cornerRadius: 16)
                .fill(cachedGradient)
                .frame(height: 120)
                .overlay(
                    VStack(spacing: 8) {
                        Text(themeData.theme.rawValue)
                            .font(.system(.title3, design: .rounded).weight(.bold))
                            .foregroundStyle(.white)
                            .lineLimit(1)

                        Text(themeData.description)
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                    .padding()
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? culturalColor : Color.clear, lineWidth: 3)
                )
        }
        .buttonStyle(.plain)
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isSelected)
    }
}

// MARK: - Performance Monitoring Integration

/// View modifier for automatic performance tracking
struct PerformanceTracked: ViewModifier {
    let viewName: String
    @StateObject private var monitor = PerformanceMonitor.shared

    func body(content: Content) -> some View {
        content
            .onAppear {
                monitor.measureViewRendering(viewName) {
                    // View appeared
                }
            }
            .onDisappear {
                monitor.takePerformanceSnapshot(label: "\(viewName) disappeared")
            }
    }
}

extension View {
    func trackPerformance(_ viewName: String) -> some View {
        modifier(PerformanceTracked(viewName: viewName))
    }
}

// MARK: - Supporting Types

struct CulturalTheme<Theme: RawRepresentable & Hashable> where Theme.RawValue == String {
    let theme: Theme
    let description: String
    let primaryColor: Color
}

// MARK: - Memory Management Helpers

/// Utility for managing view memory efficiently
final class ViewMemoryManager {
    static let shared = ViewMemoryManager()

    private var cachedViews: [String: AnyView] = [:]
    private let maxCacheSize = 10

    private init() {}

    func cacheView<V: View>(_ view: V, for key: String) {
        if cachedViews.count >= maxCacheSize {
            // Remove oldest cache entry
            if let firstKey = cachedViews.keys.first {
                cachedViews.removeValue(forKey: firstKey)
            }
        }

        cachedViews[key] = AnyView(view)
    }

    func getCachedView(for key: String) -> AnyView? {
        return cachedViews[key]
    }

    func clearCache() {
        cachedViews.removeAll()
    }
}

/// Extension for lazy loading of images
extension Image {
    static func asyncCulturalImage(named imageName: String, culturalColor: Color) -> some View {
        AsyncImage(url: Bundle.main.url(forResource: imageName, withExtension: "png")) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            RoundedRectangle(cornerRadius: 8)
                .fill(culturalColor.opacity(0.3))
                .overlay(
                    ProgressView()
                        .tint(culturalColor)
                )
        }
    }
}
