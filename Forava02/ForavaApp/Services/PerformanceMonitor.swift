import Foundation
import SwiftUI
import Combine
import os.log

@MainActor
class PerformanceMonitor: ObservableObject {
    static let shared = PerformanceMonitor()

    // MARK: - Published Properties
    @Published var isMonitoring = false
    @Published var currentMetrics: PerformanceMetrics = PerformanceMetrics()
    @Published var historicalData: [PerformanceSnapshot] = []

    // MARK: - Private Properties
    private let logger = Logger(subsystem: "com.forava.performance", category: "CulturalDesigns")
    private var cancellables = Set<AnyCancellable>()
    private var viewRenderingTimer: Timer?
    private var memoryTimer: Timer?

    // Performance tracking
    private var renderingStartTimes: [String: CFTimeInterval] = [:]
    private var componentLoadTimes: [String: CFTimeInterval] = [:]
    private var memoryBaseline: UInt64 = 0

    private init() {
        setupMemoryBaseline()
    }

    // MARK: - Public Interface

    func startMonitoring() {
        guard !isMonitoring else { return }

        isMonitoring = true
        logger.info("🚀 Performance monitoring started")

        startMemoryMonitoring()
        startRenderingMetrics()

        // Create initial snapshot
        takePerformanceSnapshot(label: "Monitoring Started")
    }

    func stopMonitoring() {
        guard isMonitoring else { return }

        isMonitoring = false
        logger.info("🛑 Performance monitoring stopped")

        stopMemoryMonitoring()
        stopRenderingMetrics()

        // Final snapshot
        takePerformanceSnapshot(label: "Monitoring Stopped")
    }

    // MARK: - Cultural Design Specific Metrics

    func measureCulturalComponentLoad<T>(_ componentName: String, operation: () -> T) -> T {
        let startTime = CFAbsoluteTimeGetCurrent()
        logger.info("⏱️ Loading cultural component: \(componentName)")

        let result = operation()

        let loadTime = CFAbsoluteTimeGetCurrent() - startTime
        componentLoadTimes[componentName] = loadTime

        logger.info("✅ Cultural component '\(componentName)' loaded in \(String(format: "%.3f", loadTime))s")

        // Update current metrics
        currentMetrics.culturalComponentLoadTimes[componentName] = loadTime

        return result
    }

    func measureCulturalComponentLoad<T>(_ componentName: String, operation: () async -> T) async -> T {
        let startTime = CFAbsoluteTimeGetCurrent()
        logger.info("⏱️ Loading cultural component: \(componentName)")

        let result = await operation()

        let loadTime = CFAbsoluteTimeGetCurrent() - startTime
        componentLoadTimes[componentName] = loadTime

        logger.info("✅ Cultural component '\(componentName)' loaded in \(String(format: "%.3f", loadTime))s")

        // Update current metrics
        currentMetrics.culturalComponentLoadTimes[componentName] = loadTime

        return result
    }

    func measureViewRendering<T>(_ viewName: String, operation: () -> T) -> T {
        let startTime = CFAbsoluteTimeGetCurrent()
        logger.debug("🎨 Rendering view: \(viewName)")

        let result = operation()

        let renderTime = CFAbsoluteTimeGetCurrent() - startTime
        logger.debug("🎨 View '\(viewName)' rendered in \(String(format: "%.3f", renderTime))s")

        // Track rendering performance
        currentMetrics.viewRenderTimes[viewName] = renderTime

        // Alert on slow renders
        if renderTime > 0.016 { // 60 FPS threshold
            logger.warning("⚠️ Slow render detected for \(viewName): \(String(format: "%.3f", renderTime))s")
            currentMetrics.slowRenderCount += 1
        }

        return result
    }

    func benchmarkModularVsMonolithic() {
        logger.info("🔄 Starting modular vs monolithic benchmark")

        let modularStartTime = CFAbsoluteTimeGetCurrent()

        // Simulate modular component loading
        let modularComponents = [
            "CulturalDesignProtocol",
            "CulturalDesignComponents",
            "ChristmasDesignView",
            "DiwaliDesignView",
            "ChineseNewYearDesignView"
        ]

        for _ in modularComponents {
            // Simulate component initialization
            Thread.sleep(forTimeInterval: 0.001) // 1ms per component
        }

        let modularTime = CFAbsoluteTimeGetCurrent() - modularStartTime

        // Compare with monolithic approach (simulated)
        let monolithicStartTime = CFAbsoluteTimeGetCurrent()
        Thread.sleep(forTimeInterval: 0.010) // Simulate single large component
        let monolithicTime = CFAbsoluteTimeGetCurrent() - monolithicStartTime

        let benchmarkResult = ModularVsMonolithicBenchmark(
            modularLoadTime: modularTime,
            monolithicLoadTime: monolithicTime,
            modularComponentCount: modularComponents.count,
            performanceImprovement: ((monolithicTime - modularTime) / monolithicTime) * 100,
            timestamp: Date()
        )

        currentMetrics.modularBenchmark = benchmarkResult

        logger.info("📊 Benchmark completed - Modular: \(String(format: "%.3f", modularTime))s, Monolithic: \(String(format: "%.3f", monolithicTime))s")
    }

    // MARK: - Battery Usage Optimization

    func measureWatchBatteryImpact(for operation: String, action: () -> Void) {
        let startEnergy = getCurrentEnergyUsage()
        let startTime = CFAbsoluteTimeGetCurrent()

        action()

        let endTime = CFAbsoluteTimeGetCurrent()
        let endEnergy = getCurrentEnergyUsage()

        let batteryImpact = WatchBatteryImpact(
            operation: operation,
            duration: endTime - startTime,
            energyDelta: endEnergy - startEnergy,
            timestamp: Date()
        )

        currentMetrics.watchBatteryMetrics.append(batteryImpact)

        logger.info("🔋 Watch operation '\(operation)' - Duration: \(String(format: "%.3f", batteryImpact.duration))s, Energy: \(batteryImpact.energyDelta)")
    }

    // MARK: - Memory Management

    private func startMemoryMonitoring() {
        memoryTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            Task { @MainActor in
                let memoryUsage = self.getCurrentMemoryUsage()
                self.currentMetrics.memoryUsage = memoryUsage

                // Alert on high memory usage
                if memoryUsage > 100 * 1024 * 1024 { // 100MB threshold
                    self.logger.warning("⚠️ High memory usage detected: \(memoryUsage / (1024 * 1024))MB")
                }
            }
        }
    }

    private func stopMemoryMonitoring() {
        memoryTimer?.invalidate()
        memoryTimer = nil
    }

    private func startRenderingMetrics() {
        // Setup render time tracking
        viewRenderingTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.updateRenderingMetrics()
            }
        }
    }

    private func stopRenderingMetrics() {
        viewRenderingTimer?.invalidate()
        viewRenderingTimer = nil
    }

    private func updateRenderingMetrics() {
        // Calculate average render times
        if !currentMetrics.viewRenderTimes.isEmpty {
            let averageRenderTime = currentMetrics.viewRenderTimes.values.reduce(0, +) / Double(currentMetrics.viewRenderTimes.count)
            currentMetrics.averageRenderTime = averageRenderTime
        }

        // Calculate FPS estimate
        let _ = 1.0 / 60.0 // 60 FPS target frame time
        currentMetrics.estimatedFPS = currentMetrics.averageRenderTime > 0 ? min(60, 1.0 / currentMetrics.averageRenderTime) : 60
    }

    // MARK: - Performance Snapshots

    func takePerformanceSnapshot(label: String) {
        let snapshot = PerformanceSnapshot(
            label: label,
            timestamp: Date(),
            memoryUsage: getCurrentMemoryUsage(),
            averageRenderTime: currentMetrics.averageRenderTime,
            estimatedFPS: currentMetrics.estimatedFPS,
            slowRenderCount: currentMetrics.slowRenderCount,
            culturalComponentsLoaded: currentMetrics.culturalComponentLoadTimes.count
        )

        historicalData.append(snapshot)

        // Keep only last 100 snapshots
        if historicalData.count > 100 {
            historicalData.removeFirst()
        }

        logger.info("📸 Performance snapshot taken: \(label)")
    }

    // MARK: - Lazy Loading Optimization

    func optimizeLazyLoading(for components: [String]) -> LazyLoadingStrategy {
        var strategy = LazyLoadingStrategy(
            priority: .normal,
            batchSize: 3,
            preloadCultures: Set<CulturalContext>()
        )

        for component in components {
            let loadTime = componentLoadTimes[component] ?? 0

            if loadTime > 0.05 { // 50ms threshold
                strategy.lazyLoadComponents.append(component)
            } else {
                strategy.eagerLoadComponents.append(component)
            }
        }

        strategy.recommendedBatchSize = max(3, min(5, components.count / 3))

        logger.info("🚀 Lazy loading strategy created - Lazy: \(strategy.lazyLoadComponents.count), Eager: \(strategy.eagerLoadComponents.count)")

        return strategy
    }

    // MARK: - Performance Recommendations

    func generatePerformanceRecommendations() -> [PerformanceRecommendation] {
        var recommendations: [PerformanceRecommendation] = []

        // Memory recommendations
        let memoryUsageMB = Double(currentMetrics.memoryUsage) / (1024 * 1024)
        if memoryUsageMB > 50 {
            recommendations.append(
                PerformanceRecommendation(
                    category: .memory,
                    severity: memoryUsageMB > 100 ? .high : .medium,
                    title: "High Memory Usage",
                    description: "Current memory usage is \(String(format: "%.1f", memoryUsageMB))MB",
                    solution: "Consider implementing view recycling and image caching"
                )
            )
        }

        // Rendering recommendations
        if currentMetrics.estimatedFPS < 55 {
            recommendations.append(
                PerformanceRecommendation(
                    category: .rendering,
                    severity: currentMetrics.estimatedFPS < 45 ? .high : .medium,
                    title: "Low Frame Rate",
                    description: "Estimated FPS: \(String(format: "%.1f", currentMetrics.estimatedFPS))",
                    solution: "Optimize view hierarchies and reduce complex animations"
                )
            )
        }

        // Component loading recommendations
        let slowComponents = componentLoadTimes.filter { $0.value > 0.1 }
        if !slowComponents.isEmpty {
            recommendations.append(
                PerformanceRecommendation(
                    category: .loading,
                    severity: .medium,
                    title: "Slow Component Loading",
                    description: "\(slowComponents.count) components take >100ms to load",
                    solution: "Implement lazy loading for heavy components"
                )
            )
        }

        // Watch battery recommendations
        let heavyWatchOperations = currentMetrics.watchBatteryMetrics.filter { $0.energyDelta > 10 }
        if !heavyWatchOperations.isEmpty {
            recommendations.append(
                PerformanceRecommendation(
                    category: .battery,
                    severity: .high,
                    title: "High Watch Battery Usage",
                    description: "\(heavyWatchOperations.count) operations consume significant energy",
                    solution: "Enable battery optimization mode and reduce animation complexity"
                )
            )
        }

        return recommendations
    }

    // MARK: - Private Helpers

    private func setupMemoryBaseline() {
        memoryBaseline = getCurrentMemoryUsage()
    }

    private func getCurrentMemoryUsage() -> UInt64 {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4

        let result = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }

        return result == KERN_SUCCESS ? info.resident_size : 0
    }

    private func getCurrentEnergyUsage() -> Double {
        // Simplified energy estimation based on CPU usage
        // In a real implementation, this would use more sophisticated metrics
        return Double.random(in: 1...5)
    }
}

// MARK: - Supporting Types

struct PerformanceMetrics {
    var memoryUsage: UInt64 = 0
    var averageRenderTime: Double = 0
    var estimatedFPS: Double = 60
    var slowRenderCount: Int = 0

    var viewRenderTimes: [String: Double] = [:]
    var culturalComponentLoadTimes: [String: Double] = [:]
    var watchBatteryMetrics: [WatchBatteryImpact] = []
    var modularBenchmark: ModularVsMonolithicBenchmark?
}

struct PerformanceSnapshot {
    let label: String
    let timestamp: Date
    let memoryUsage: UInt64
    let averageRenderTime: Double
    let estimatedFPS: Double
    let slowRenderCount: Int
    let culturalComponentsLoaded: Int
}

struct ModularVsMonolithicBenchmark {
    let modularLoadTime: Double
    let monolithicLoadTime: Double
    let modularComponentCount: Int
    let performanceImprovement: Double
    let timestamp: Date
}

struct WatchBatteryImpact {
    let operation: String
    let duration: Double
    let energyDelta: Double
    let timestamp: Date
}

// Note: LazyLoadingStrategy now defined in SharedCulturalTypes.swift

struct PerformanceRecommendation {
    let category: Category
    let severity: Severity
    let title: String
    let description: String
    let solution: String

    enum Category {
        case memory
        case rendering
        case loading
        case battery
    }

    enum Severity {
        case low
        case medium
        case high
    }
}
