import Foundation
import WatchKit
import SwiftUI
import Combine

/// Advanced battery optimization manager for Apple Watch cultural animations
@MainActor
class OptimizedWatchBatteryManager: ObservableObject {
    static let shared = OptimizedWatchBatteryManager()

    // MARK: - Published Properties
    @Published var batteryLevel: Float = 1.0
    @Published var batteryState: WKInterfaceDeviceBatteryState = .unknown
    @Published var optimizationMode: BatteryOptimizationMode = .adaptive
    @Published var energyBudget: EnergyBudget = EnergyBudget()
    @Published var performanceProfile: WatchPerformanceProfile = .balanced

    // MARK: - Battery Optimization Settings
    @Published var animationsEnabled = true
    @Published var hapticFeedbackEnabled = true
    @Published var refreshRate: RefreshRate = .normal
    @Published var displayBrightness: DisplayBrightness = .auto

    // MARK: - Private Properties
    private let device = WKInterfaceDevice.current()
    private var cancellables = Set<AnyCancellable>()
    private var energyConsumptionHistory: [EnergyConsumption] = []
    private let maxHistorySize = 100

    // Energy tracking
    private var lastEnergyMeasurement: Date = Date()
    private var totalEnergyConsumed: Double = 0
    private var operationEnergyTracker: [String: Double] = [:]

    private init() {
        setupBatteryMonitoring()
        initializeOptimizationProfile()
    }

    // MARK: - Battery Monitoring Setup

    private func setupBatteryMonitoring() {
        // Enable battery monitoring
        device.batteryMonitoringEnabled = true

        // Initial battery state
        updateBatteryState()

        // Monitor battery level changes
        NotificationCenter.default.publisher(for: NSNotification.Name.WKInterfaceDeviceBatteryLevelDidChange)
            .sink { [weak self] _ in
                self?.updateBatteryState()
                self?.adjustOptimizationMode()
            }
            .store(in: &cancellables)

        // Monitor battery state changes (charging/unplugged)
        NotificationCenter.default.publisher(for: NSNotification.Name.WKInterfaceDeviceBatteryStateDidChange)
            .sink { [weak self] _ in
                self?.updateBatteryState()
                self?.handleBatteryStateChange()
            }
            .store(in: &cancellables)

        // Periodic energy budget recalculation
        Timer.publish(every: 60, on: .main, in: .common) // Every minute
            .autoconnect()
            .sink { [weak self] _ in
                self?.recalculateEnergyBudget()
            }
            .store(in: &cancellables)
    }

    private func updateBatteryState() {
        batteryLevel = device.batteryLevel
        batteryState = device.batteryState
    }

    // MARK: - Optimization Mode Management

    private func adjustOptimizationMode() {
        let previousMode = optimizationMode

        switch batteryLevel {
        case 0.0...0.10: // Critical battery (0-10%)
            optimizationMode = .critical
            performanceProfile = .energySaver

        case 0.10...0.20: // Low battery (10-20%)
            optimizationMode = .aggressive
            performanceProfile = .lowPower

        case 0.20...0.40: // Medium battery (20-40%)
            optimizationMode = .moderate
            performanceProfile = .balanced

        case 0.40...1.0: // Good battery (40-100%)
            if batteryState == .charging {
                optimizationMode = .minimal
                performanceProfile = .performance
            } else {
                optimizationMode = .adaptive
                performanceProfile = .balanced
            }

        default:
            optimizationMode = .adaptive
            performanceProfile = .balanced
        }

        if previousMode != optimizationMode {
            applyOptimizationMode()
        }
    }

    private func applyOptimizationMode() {
        switch optimizationMode {
        case .minimal:
            animationsEnabled = true
            hapticFeedbackEnabled = true
            refreshRate = .high
            displayBrightness = .auto

        case .adaptive:
            animationsEnabled = true
            hapticFeedbackEnabled = true
            refreshRate = .normal
            displayBrightness = .auto

        case .moderate:
            animationsEnabled = batteryLevel > 0.25
            hapticFeedbackEnabled = true
            refreshRate = .normal
            displayBrightness = .medium

        case .aggressive:
            animationsEnabled = false
            hapticFeedbackEnabled = batteryLevel > 0.15
            refreshRate = .low
            displayBrightness = .low

        case .critical:
            animationsEnabled = false
            hapticFeedbackEnabled = false
            refreshRate = .minimal
            displayBrightness = .minimal
        }

        updateEnergyBudget()
        notifyOptimizationChange()
    }

    private func handleBatteryStateChange() {
        if batteryState == .charging {
            // More permissive settings when charging
            if batteryLevel > 0.3 {
                animationsEnabled = true
                refreshRate = .normal
            }
        } else {
            // More conservative when on battery
            adjustOptimizationMode()
        }
    }

    // MARK: - Energy Budget Management

    private func initializeOptimizationProfile() {
        energyBudget = EnergyBudget(
            totalBudget: calculateTotalEnergyBudget(),
            animationBudget: 0.3,
            hapticBudget: 0.1,
            renderingBudget: 0.4,
            networkBudget: 0.2
        )
    }

    private func calculateTotalEnergyBudget() -> Double {
        // Base energy budget calculation based on battery level and expected usage
        let baseEnergyUnits = Double(batteryLevel) * 100.0

        // Adjust based on time of day (less budget at night)
        let hour = Calendar.current.component(.hour, from: Date())
        let timeMultiplier = (hour >= 22 || hour <= 6) ? 0.7 : 1.0

        // Adjust based on performance profile
        let profileMultiplier: Double
        switch performanceProfile {
        case .energySaver: profileMultiplier = 0.5
        case .lowPower: profileMultiplier = 0.7
        case .balanced: profileMultiplier = 1.0
        case .performance: profileMultiplier = 1.3
        }

        return baseEnergyUnits * timeMultiplier * profileMultiplier
    }

    private func recalculateEnergyBudget() {
        let newBudget = calculateTotalEnergyBudget()

        // Adjust budget allocations based on usage patterns
        analyzeEnergyConsumptionPatterns()

        energyBudget.totalBudget = newBudget
        updateBudgetAllocations()
    }

    private func updateBudgetAllocations() {
        // Dynamic budget allocation based on actual usage
        let recentConsumption = energyConsumptionHistory.suffix(20)

        if !recentConsumption.isEmpty {
            let totalOperations = Double(recentConsumption.count)
            let animationUsage = recentConsumption.filter { $0.operation.contains("animation") }.count
            let hapticUsage = recentConsumption.filter { $0.operation.contains("haptic") }.count

            // Adjust budgets based on actual usage patterns
            energyBudget.animationBudget = min(0.5, Double(animationUsage) / totalOperations + 0.1)
            energyBudget.hapticBudget = min(0.3, Double(hapticUsage) / totalOperations + 0.05)
        }
    }

    private func updateEnergyBudget() {
        energyBudget.remainingBudget = max(0, energyBudget.totalBudget - totalEnergyConsumed)
        energyBudget.utilizationPercentage = energyBudget.totalBudget > 0 ?
            totalEnergyConsumed / energyBudget.totalBudget : 0
    }

    // MARK: - Energy Consumption Tracking

    func trackEnergyConsumption(for operation: String, energyCost: Double) {
        let consumption = EnergyConsumption(
            operation: operation,
            energyCost: energyCost,
            timestamp: Date(),
            batteryLevelAtTime: batteryLevel
        )

        energyConsumptionHistory.append(consumption)

        // Maintain history size limit
        if energyConsumptionHistory.count > maxHistorySize {
            energyConsumptionHistory.removeFirst()
        }

        // Update total energy consumed
        totalEnergyConsumed += energyCost
        operationEnergyTracker[operation, default: 0] += energyCost

        updateEnergyBudget()

        // Check if we're exceeding budget
        if energyBudget.utilizationPercentage > 0.8 {
            handleEnergyBudgetExceeded()
        }
    }

    private func analyzeEnergyConsumptionPatterns() {
        let recentConsumption = energyConsumptionHistory.suffix(50)

        // Identify energy-hungry operations
        let operationCosts = Dictionary(grouping: recentConsumption, by: { $0.operation })
            .mapValues { consumptions in
                consumptions.reduce(0) { $0 + $1.energyCost }
            }

        // Log high-consumption operations
        let highConsumptionOperations = operationCosts.filter { $0.value > 5.0 }
        for (operation, cost) in highConsumptionOperations {
            print("⚠️ High energy consumption detected: \(operation) - \(String(format: "%.2f", cost)) units")
        }
    }

    private func handleEnergyBudgetExceeded() {
        // Automatically reduce performance when budget is exceeded
        if optimizationMode != .critical {
            let currentModeIndex = BatteryOptimizationMode.allCases.firstIndex(of: optimizationMode) ?? 0
            let nextModeIndex = min(currentModeIndex + 1, BatteryOptimizationMode.allCases.count - 1)
            optimizationMode = BatteryOptimizationMode.allCases[nextModeIndex]

            applyOptimizationMode()
        }
    }

    // MARK: - Cultural Animation Optimization

    func shouldEnableCulturalAnimation(complexity: AnimationComplexity) -> Bool {
        guard animationsEnabled else { return false }

        let energyCost = complexity.energyCost
        let available = energyBudget.animationBudget * energyBudget.totalBudget

        return energyCost <= available && energyBudget.remainingBudget >= energyCost
    }

    func optimizedCulturalAnimation(for culture: CulturalContext, complexity: AnimationComplexity) -> OptimizedAnimation {
        let baseAnimation = CulturalAnimationDefinitions.animation(for: culture, complexity: complexity)

        // Apply battery optimizations
        var optimizedAnimation = baseAnimation

        switch optimizationMode {
        case .minimal, .adaptive:
            // Keep original animation
            break

        case .moderate:
            optimizedAnimation.duration *= 0.8
            optimizedAnimation.frameRate = min(optimizedAnimation.frameRate, 30)

        case .aggressive:
            optimizedAnimation.duration *= 0.6
            optimizedAnimation.frameRate = 15
            optimizedAnimation.complexity = .simple

        case .critical:
            return OptimizedAnimation.staticDisplay(for: culture)
        }

        return optimizedAnimation
    }

    func measureAnimationEnergyImpact<T>(operation: String, animation: () -> T) -> T {
        let startTime = Date()
        let startBattery = batteryLevel

        let result = animation()

        let duration = Date().timeIntervalSince(startTime)
        let batteryDelta = Double(startBattery - batteryLevel)

        // Estimate energy cost based on duration and battery consumption
        let estimatedEnergyCost = duration * 2.0 + batteryDelta * 100.0

        trackEnergyConsumption(for: operation, energyCost: estimatedEnergyCost)

        return result
    }

    // MARK: - Haptic Feedback Optimization

    func performOptimizedHaptic(_ hapticType: WKHapticType, intensity: Float = 1.0) {
        guard hapticFeedbackEnabled else { return }

        let energyCost = calculateHapticEnergyCost(hapticType, intensity: intensity)
        guard energyBudget.remainingBudget >= energyCost else { return }

        let optimizedIntensity = min(intensity, Float(energyBudget.hapticBudget))
        device.play(hapticType, options: [.volume: optimizedIntensity])

        trackEnergyConsumption(for: "haptic_\(hapticType)", energyCost: energyCost)
    }

    private func calculateHapticEnergyCost(_ hapticType: WKHapticType, intensity: Float) -> Double {
        let baseEnergyCosts: [WKHapticType: Double] = [
            .notification: 1.0,
            .directionUp: 0.8,
            .directionDown: 0.8,
            .success: 1.2,
            .failure: 1.5,
            .retry: 1.0,
            .start: 0.6,
            .stop: 0.4,
            .click: 0.3
        ]

        return (baseEnergyCosts[hapticType] ?? 1.0) * Double(intensity)
    }

    // MARK: - Notification

    private func notifyOptimizationChange() {
        NotificationCenter.default.post(
            name: .watchBatteryOptimizationChanged,
            object: nil,
            userInfo: [
                "mode": optimizationMode.rawValue,
                "profile": performanceProfile.rawValue,
                "batteryLevel": batteryLevel
            ]
        )
    }
}

// MARK: - Supporting Types

enum BatteryOptimizationMode: String, CaseIterable {
    case minimal = "minimal"
    case adaptive = "adaptive"
    case moderate = "moderate"
    case aggressive = "aggressive"
    case critical = "critical"

    var displayName: String {
        switch self {
        case .minimal: return "Minimal"
        case .adaptive: return "Adaptive"
        case .moderate: return "Moderate"
        case .aggressive: return "Aggressive"
        case .critical: return "Critical"
        }
    }
}

enum WatchPerformanceProfile: String, CaseIterable {
    case energySaver = "energy_saver"
    case lowPower = "low_power"
    case balanced = "balanced"
    case performance = "performance"
}

enum RefreshRate {
    case minimal // 10 Hz
    case low     // 15 Hz
    case normal  // 30 Hz
    case high    // 60 Hz

    var hertz: Int {
        switch self {
        case .minimal: return 10
        case .low: return 15
        case .normal: return 30
        case .high: return 60
        }
    }
}

enum DisplayBrightness {
    case minimal
    case low
    case medium
    case auto

    var multiplier: Double {
        switch self {
        case .minimal: return 0.3
        case .low: return 0.5
        case .medium: return 0.7
        case .auto: return 1.0
        }
    }
}

struct EnergyBudget {
    var totalBudget: Double = 100.0
    var remainingBudget: Double = 100.0
    var utilizationPercentage: Double = 0.0

    var animationBudget: Double = 0.3
    var hapticBudget: Double = 0.1
    var renderingBudget: Double = 0.4
    var networkBudget: Double = 0.2
}

struct EnergyConsumption {
    let operation: String
    let energyCost: Double
    let timestamp: Date
    let batteryLevelAtTime: Float
}

enum AnimationComplexity {
    case simple
    case moderate
    case complex
    case elaborate

    var energyCost: Double {
        switch self {
        case .simple: return 1.0
        case .moderate: return 2.5
        case .complex: return 5.0
        case .elaborate: return 10.0
        }
    }
}

struct OptimizedAnimation {
    var duration: TimeInterval
    var frameRate: Int
    var complexity: AnimationComplexity
    var culturalElements: [String]

    static func staticDisplay(for culture: CulturalContext) -> OptimizedAnimation {
        return OptimizedAnimation(
            duration: 0,
            frameRate: 0,
            complexity: .simple,
            culturalElements: []
        )
    }
}

// MARK: - Cultural Animation Definitions

enum CulturalAnimationDefinitions {
    static func animation(for culture: CulturalContext, complexity: AnimationComplexity) -> OptimizedAnimation {
        switch culture {
        case .christmas:
            return OptimizedAnimation(
                duration: complexity == .simple ? 1.0 : 2.0,
                frameRate: 30,
                complexity: complexity,
                culturalElements: ["snowflake", "star", "tree"]
            )
        case .diwali:
            return OptimizedAnimation(
                duration: complexity == .simple ? 1.5 : 3.0,
                frameRate: 30,
                complexity: complexity,
                culturalElements: ["diya", "rangoli", "firework"]
            )
        case .chineseNewYear:
            return OptimizedAnimation(
                duration: complexity == .simple ? 1.2 : 2.5,
                frameRate: 30,
                complexity: complexity,
                culturalElements: ["dragon", "lantern", "firework"]
            )
        default:
            return OptimizedAnimation(
                duration: 1.0,
                frameRate: 30,
                complexity: .simple,
                culturalElements: []
            )
        }
    }
}

// MARK: - Notification Names

extension Notification.Name {
    static let watchBatteryOptimizationChanged = Notification.Name("WatchBatteryOptimizationChanged")
}
