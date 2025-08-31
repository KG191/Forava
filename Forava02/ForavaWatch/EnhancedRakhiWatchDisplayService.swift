import SwiftUI
import WatchKit
import Combine

// MARK: - Enhanced Apple Watch Rakhi Display Service

@MainActor
class EnhancedRakhiWatchDisplayService: ObservableObject {
    static let shared = EnhancedRakhiWatchDisplayService()

    // MARK: - Published Properties
    @Published var displayedRakhis: [WatchRakhiDisplay] = []
    @Published var currentRakhi: WatchRakhiDisplay?
    @Published var displayMode: WatchDisplayMode = .gallery
    @Published var isAnimating = false
    @Published var batteryOptimizationEnabled = true

    // MARK: - Watch Optimization
    @Published var watchDisplaySettings: WatchDisplaySettings
    private let watchCapabilities: WatchCapabilities

    private var cancellables = Set<AnyCancellable>()
    private let maxWatchRakhis = 10 // Limit for watch storage

    private init() {
        self.watchCapabilities = WatchCapabilities.current
        self.watchDisplaySettings = WatchDisplaySettings.optimizedForWatch(watchCapabilities)

        setupWatchOptimizations()
        loadWatchRakhis()
        setupBatteryMonitoring()
    }

    // MARK: - Rakhi Display Management

    func addRakhiToWatch(_ rakhi: GeneratedRakhi) {
        let watchDisplay = createWatchOptimizedDisplay(from: rakhi)

        // Remove oldest if at capacity
        if displayedRakhis.count >= maxWatchRakhis {
            displayedRakhis.removeFirst()
        }

        displayedRakhis.append(watchDisplay)
        saveWatchRakhis()

        // Set as current if first rakhi
        if displayedRakhis.count == 1 {
            currentRakhi = watchDisplay
        }
    }

    func removeRakhiFromWatch(_ id: UUID) {
        displayedRakhis.removeAll { $0.id == id }

        // Update current if removed
        if currentRakhi?.id == id {
            currentRakhi = displayedRakhis.first
        }

        saveWatchRakhis()
    }

    func selectRakhi(_ rakhi: WatchRakhiDisplay) {
        currentRakhi = rakhi

        // Animate selection if not in battery saving mode
        if !batteryOptimizationEnabled {
            animateRakhiSelection()
        }
    }

    // MARK: - Watch-Optimized Display Creation

    private func createWatchOptimizedDisplay(from rakhi: GeneratedRakhi) -> WatchRakhiDisplay {
        // Create watch-optimized version
        let optimizedImage = optimizeImageForWatch(rakhi.mainImage)
        let simplifiedAnimation = createWatchAnimation(rakhi)
        let culturalElements = extractCulturalElements(rakhi)

        return WatchRakhiDisplay(
            id: rakhi.id,
            title: generateWatchTitle(rakhi),
            optimizedImage: optimizedImage,
            culturalScore: rakhi.culturalScore,
            colors: extractDominantColors(rakhi),
            culturalElements: culturalElements,
            createdAt: rakhi.createdAt,
            animation: simplifiedAnimation,
            watchOptimized: true
        )
    }

    private func optimizeImageForWatch(_ image: AIImageResult) -> WatchOptimizedImage {
        // In production, this would resize and optimize the image
        return WatchOptimizedImage(
            thumbnailData: Data(), // Placeholder - would contain actual optimized image data
            displaySize: watchCapabilities.optimalImageSize,
            compressionQuality: watchDisplaySettings.imageQuality,
            optimizedForBattery: batteryOptimizationEnabled
        )
    }

    private func createWatchAnimation(_ rakhi: GeneratedRakhi) -> WatchAnimation? {
        guard !batteryOptimizationEnabled else { return nil }

        // Create simple animation suitable for watch
        switch rakhi.designSpec.genre {
        case .traditional:
            return WatchAnimation(
                type: .pulse,
                duration: 2.0,
                intensity: 0.6,
                culturalElement: .mandala
            )
        case .spiritual:
            return WatchAnimation(
                type: .glow,
                duration: 3.0,
                intensity: 0.4,
                culturalElement: .lotus
            )
        case .modern:
            return WatchAnimation(
                type: .shimmer,
                duration: 1.5,
                intensity: 0.8,
                culturalElement: .geometric
            )
        default:
            return WatchAnimation(
                type: .subtle,
                duration: 2.5,
                intensity: 0.5,
                culturalElement: .general
            )
        }
    }

    private func extractDominantColors(_ rakhi: GeneratedRakhi) -> [Color] {
        // Extract colors from rakhi design
        return rakhi.designSpec.colorPalette.colors.prefix(3).map { $0 }
    }

    private func extractCulturalElements(_ rakhi: GeneratedRakhi) -> [WatchCulturalElement] {
        return rakhi.designSpec.elements.compactMap { element in
            WatchCulturalElement(
                name: element.displayName,
                significance: element.culturalSignificance,
                category: mapToWatchCategory(element.category)
            )
        }
    }

    private func generateWatchTitle(_ rakhi: GeneratedRakhi) -> String {
        let genre = rakhi.designSpec.genre.displayName
        let blessing = getShortBlessing(for: rakhi.designSpec.genre)
        return "\(genre) • \(blessing)"
    }

    private func getShortBlessing(for genre: RakhiGenre) -> String {
        switch genre {
        case .traditional: return "🙏 Sacred"
        case .spiritual: return "✨ Divine"
        case .modern: return "💫 Contemporary"
        case .elegant: return "👑 Refined"
        default: return "❤️ Love"
        }
    }

    // MARK: - Display Modes

    func switchDisplayMode(to mode: WatchDisplayMode) {
        displayMode = mode

        // Animate mode transition if battery allows
        if !batteryOptimizationEnabled {
            animateModeTransition()
        }
    }

    // MARK: - Watch Animations

    private func animateRakhiSelection() {
        guard !isAnimating else { return }

        isAnimating = true

        // Simple haptic feedback
        WKInterfaceDevice.current().play(.click)

        // End animation after short duration
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isAnimating = false
        }
    }

    private func animateModeTransition() {
        guard !isAnimating else { return }

        isAnimating = true

        // Provide haptic feedback for mode change
        WKInterfaceDevice.current().play(.success)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isAnimating = false
        }
    }

    // MARK: - Battery Optimization

    private func setupBatteryMonitoring() {
        // Monitor battery level and adjust settings
        let device = WKInterfaceDevice.current()

        // Enable battery optimization if battery is low
        if device.batteryLevel < 0.20 && device.batteryState != .charging {
            enableBatteryOptimization()
        }

        // Monitor battery changes
        NotificationCenter.default.publisher(for: .batteryLevelDidChange)
            .sink { [weak self] _ in
                self?.adjustForBatteryLevel()
            }
            .store(in: &cancellables)
    }

    private func enableBatteryOptimization() {
        batteryOptimizationEnabled = true
        watchDisplaySettings.animationsEnabled = false
        watchDisplaySettings.imageQuality = 0.6
        watchDisplaySettings.refreshRate = .low

        // Remove animations from existing rakhis
        for index in displayedRakhis.indices {
            displayedRakhis[index].animation = nil
        }
    }

    private func disableBatteryOptimization() {
        batteryOptimizationEnabled = false
        watchDisplaySettings.animationsEnabled = true
        watchDisplaySettings.imageQuality = 0.8
        watchDisplaySettings.refreshRate = .normal

        // Restore animations
        reloadRakhiAnimations()
    }

    private func adjustForBatteryLevel() {
        let device = WKInterfaceDevice.current()

        if device.batteryLevel < 0.15 && !batteryOptimizationEnabled {
            enableBatteryOptimization()
        } else if device.batteryLevel > 0.50 && batteryOptimizationEnabled && device.batteryState == .charging {
            disableBatteryOptimization()
        }
    }

    // MARK: - Watch Complications Support

    func getComplicationData() -> WatchComplicationData? {
        guard let current = currentRakhi else { return nil }

        return WatchComplicationData(
            rakhiId: current.id,
            title: current.title,
            culturalScore: current.culturalScore,
            primaryColor: current.colors.first ?? .orange,
            createdDate: current.createdAt
        )
    }

    func getTimelineEntries(for date: Date) -> [WatchTimelineEntry] {
        var entries: [WatchTimelineEntry] = []

        // Create entries for each rakhi
        for (index, rakhi) in displayedRakhis.enumerated() {
            let entryDate = Calendar.current.date(byAdding: .hour, value: index, to: date) ?? date

            let entry = WatchTimelineEntry(
                date: entryDate,
                rakhi: rakhi,
                displayConfiguration: createDisplayConfiguration(for: rakhi)
            )

            entries.append(entry)
        }

        return entries
    }

    private func createDisplayConfiguration(for rakhi: WatchRakhiDisplay) -> WatchDisplayConfiguration {
        return WatchDisplayConfiguration(
            showTitle: true,
            showScore: watchCapabilities.supportsComplications,
            animationEnabled: !batteryOptimizationEnabled,
            culturalElementsVisible: true,
            colorScheme: .adaptive
        )
    }

    // MARK: - Watch Optimization Helpers

    private func setupWatchOptimizations() {
        // Adjust settings based on watch capabilities
        if watchCapabilities.screenSize.width < 44 { // Smaller watches
            watchDisplaySettings.maxVisibleElements = 3
            watchDisplaySettings.fontSize = .small
        } else {
            watchDisplaySettings.maxVisibleElements = 5
            watchDisplaySettings.fontSize = .regular
        }

        // Enable always-on display optimizations if supported
        if watchCapabilities.supportsAlwaysOn {
            watchDisplaySettings.alwaysOnOptimization = true
        }
    }

    private func reloadRakhiAnimations() {
        // Recreate animations for all rakhis when battery optimization is disabled
        for index in displayedRakhis.indices {
            // This would recreate the animation based on the original rakhi data
            // For now, we'll create a placeholder
            if let originalRakhi = getOriginalRakhi(for: displayedRakhis[index].id) {
                displayedRakhis[index].animation = createWatchAnimation(originalRakhi)
            }
        }
    }

    private func getOriginalRakhi(for id: UUID) -> GeneratedRakhi? {
        // In a real implementation, this would fetch the original rakhi data
        // For now, return nil as we don't have access to the full rakhi data on watch
        return nil
    }

    // MARK: - Data Persistence

    private func loadWatchRakhis() {
        // Load from watch-specific storage
        if let data = UserDefaults.standard.data(forKey: "watch_rakhis"),
           let rakhis = try? JSONDecoder().decode([WatchRakhiDisplay].self, from: data) {
            displayedRakhis = rakhis
            currentRakhi = rakhis.first
        }
    }

    private func saveWatchRakhis() {
        if let data = try? JSONEncoder().encode(displayedRakhis) {
            UserDefaults.standard.set(data, forKey: "watch_rakhis")
        }
    }

    // MARK: - Helper Methods

    private func mapToWatchCategory(_ category: ElementCategory) -> WatchElementCategory {
        switch category {
        case .centerPiece: return .focal
        case .decorative: return .ornamental
        case .thread: return .binding
        case .bead: return .accent
        case .charm: return .symbolic
        case .cultural: return .sacred
        }
    }
}

// MARK: - Supporting Types

struct WatchRakhiDisplay: Identifiable, Codable {
    let id: UUID
    let title: String
    let optimizedImage: WatchOptimizedImage
    let culturalScore: Double
    let colors: [Color]
    let culturalElements: [WatchCulturalElement]
    let createdAt: Date
    var animation: WatchAnimation?
    let watchOptimized: Bool
}

struct WatchOptimizedImage: Codable {
    let thumbnailData: Data
    let displaySize: CGSize
    let compressionQuality: Double
    let optimizedForBattery: Bool
}

struct WatchAnimation: Codable {
    let type: AnimationType
    let duration: Double
    let intensity: Double
    let culturalElement: CulturalElement

    enum AnimationType: String, Codable {
        case pulse
        case glow
        case shimmer
        case subtle
    }

    enum CulturalElement: String, Codable {
        case mandala
        case lotus
        case geometric
        case general
    }
}

struct WatchCulturalElement: Codable {
    let name: String
    let significance: Double
    let category: WatchElementCategory
}

enum WatchElementCategory: String, Codable {
    case focal
    case ornamental
    case binding
    case accent
    case symbolic
    case sacred
}

enum WatchDisplayMode: String, CaseIterable {
    case gallery
    case single
    case carousel
    case minimal

    var displayName: String {
        switch self {
        case .gallery: return "Gallery"
        case .single: return "Focus"
        case .carousel: return "Carousel"
        case .minimal: return "Minimal"
        }
    }
}

struct WatchCapabilities {
    let screenSize: CGSize
    let supportsComplications: Bool
    let supportsAlwaysOn: Bool
    let batteryCapacity: BatteryCapacity
    let processingPower: ProcessingPower
    let optimalImageSize: CGSize

    static var current: WatchCapabilities {
        let device = WKInterfaceDevice.current()
        let screenSize = device.screenBounds.size

        // Determine capabilities based on screen size (approximation)
        let supportsComplications = screenSize.width >= 40
        let supportsAlwaysOn = screenSize.width >= 44 // Series 5+

        return WatchCapabilities(
            screenSize: screenSize,
            supportsComplications: supportsComplications,
            supportsAlwaysOn: supportsAlwaysOn,
            batteryCapacity: screenSize.width >= 45 ? .large : .standard,
            processingPower: supportsAlwaysOn ? .high : .standard,
            optimalImageSize: CGSize(width: screenSize.width * 0.8, height: screenSize.height * 0.8)
        )
    }

    enum BatteryCapacity {
        case large
        case standard
        case compact
    }

    enum ProcessingPower {
        case high
        case standard
        case limited
    }
}

struct WatchDisplaySettings {
    var animationsEnabled: Bool
    var imageQuality: Double
    var refreshRate: RefreshRate
    var maxVisibleElements: Int
    var fontSize: FontSize
    var alwaysOnOptimization: Bool

    static func optimizedForWatch(_ capabilities: WatchCapabilities) -> WatchDisplaySettings {
        return WatchDisplaySettings(
            animationsEnabled: capabilities.processingPower == .high,
            imageQuality: capabilities.batteryCapacity == .large ? 0.8 : 0.6,
            refreshRate: capabilities.supportsAlwaysOn ? .normal : .low,
            maxVisibleElements: capabilities.screenSize.width >= 44 ? 5 : 3,
            fontSize: capabilities.screenSize.width >= 44 ? .regular : .small,
            alwaysOnOptimization: capabilities.supportsAlwaysOn
        )
    }

    enum RefreshRate {
        case high
        case normal
        case low
    }

    enum FontSize {
        case small
        case regular
        case large
    }
}

struct WatchComplicationData {
    let rakhiId: UUID
    let title: String
    let culturalScore: Double
    let primaryColor: Color
    let createdDate: Date
}

struct WatchTimelineEntry {
    let date: Date
    let rakhi: WatchRakhiDisplay
    let displayConfiguration: WatchDisplayConfiguration
}

struct WatchDisplayConfiguration {
    let showTitle: Bool
    let showScore: Bool
    let animationEnabled: Bool
    let culturalElementsVisible: Bool
    let colorScheme: ColorScheme

    enum ColorScheme {
        case light
        case dark
        case adaptive
    }
}

// MARK: - Color Codable Extension

extension Color: Codable {
    enum CodingKeys: String, CodingKey {
        case red, green, blue, alpha
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let red = try container.decode(Double.self, forKey: .red)
        let green = try container.decode(Double.self, forKey: .green)
        let blue = try container.decode(Double.self, forKey: .blue)
        let alpha = try container.decode(Double.self, forKey: .alpha)

        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        // Convert color to components (simplified)
        let components = self.cgColor?.components ?? [0, 0, 0, 1]

        try container.encode(Double(components[0]), forKey: .red)
        try container.encode(Double(components[1]), forKey: .green)
        try container.encode(Double(components[2]), forKey: .blue)
        try container.encode(Double(components.count > 3 ? components[3] : 1), forKey: .alpha)
    }
}
