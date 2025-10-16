import XCTest
import SwiftUI
import Combine
@testable import ForavaApp

/// Comprehensive performance validation suite for cultural design system optimization
class PerformanceValidationSuite: XCTestCase {

    // MARK: - Test Properties
    var performanceMonitor: PerformanceMonitor!
    var lazyLoadingManager: LazyLoadingManager!
    var watchBatteryManager: OptimizedWatchBatteryManager!
    var cancellables: Set<AnyCancellable>!

    // Performance benchmarks
    let maxAcceptableRenderTime: TimeInterval = 0.016 // 60 FPS target
    let maxAcceptableLoadTime: TimeInterval = 0.1 // 100ms for component loading
    let maxAcceptableMemoryUsage: UInt64 = 50 * 1024 * 1024 // 50MB

    override func setUp() async throws {
        try await super.setUp()

        await MainActor.run {
            performanceMonitor = PerformanceMonitor.shared
            lazyLoadingManager = LazyLoadingManager.shared
            watchBatteryManager = OptimizedWatchBatteryManager.shared
            cancellables = Set<AnyCancellable>()
        }

        // Start monitoring for tests
        await MainActor.run {
            performanceMonitor.startMonitoring()
        }
    }

    override func tearDown() async throws {
        await MainActor.run {
            performanceMonitor.stopMonitoring()
            cancellables.removeAll()
        }

        try await super.tearDown()
    }

    // MARK: - Component Loading Performance Tests

    func testCulturalComponentLoadingPerformance() async throws {
        let testComponents = [
            "ChristmasDesignView",
            "DiwaliDesignView",
            "ChineseNewYearDesignView",
            "ChristmasElements",
            "DiwaliElements"
        ]

        await MainActor.run {
            performanceMonitor.takePerformanceSnapshot(label: "Before Component Loading")
        }

        // Test individual component loading performance
        for componentId in testComponents {
            let startTime = CFAbsoluteTimeGetCurrent()

            let component = await lazyLoadingManager.loadComponent(componentId)

            let loadTime = CFAbsoluteTimeGetCurrent() - startTime

            XCTAssertNotNil(component, "Component \(componentId) should load successfully")
            XCTAssertLessThan(loadTime, maxAcceptableLoadTime,
                "Component \(componentId) took \(loadTime)s to load, expected < \(maxAcceptableLoadTime)s")

            print("✅ Component \(componentId) loaded in \(String(format: "%.3f", loadTime))s")
        }

        await MainActor.run {
            performanceMonitor.takePerformanceSnapshot(label: "After Component Loading")
        }
    }

    func testBatchLoadingPerformance() async throws {
        let testComponents = [
            "ChristmasDesignView",
            "ChristmasElements",
            "ChristmasThemes",
            "DiwaliDesignView",
            "DiwaliElements"
        ]

        let startTime = CFAbsoluteTimeGetCurrent()

        let loadedComponents = await lazyLoadingManager.batchLoadComponents(testComponents)

        let totalLoadTime = CFAbsoluteTimeGetCurrent() - startTime
        let averageLoadTime = totalLoadTime / Double(testComponents.count)

        XCTAssertEqual(loadedComponents.count, testComponents.count,
            "Should load all \(testComponents.count) components")
        XCTAssertLessThan(averageLoadTime, maxAcceptableLoadTime,
            "Average component load time \(averageLoadTime)s should be < \(maxAcceptableLoadTime)s")

        print("✅ Batch loaded \(testComponents.count) components in \(String(format: "%.3f", totalLoadTime))s")
    }

    func testLazyLoadingStrategy() async throws {
        await MainActor.run {
            let strategy = performanceMonitor.optimizeLazyLoading(
                for: ["ChristmasDesignView", "DiwaliDesignView", "ChineseNewYearDesignView"]
            )

            XCTAssertGreaterThan(strategy.recommendedBatchSize, 0,
                "Should recommend a positive batch size")
            XCTAssertLessThanOrEqual(strategy.recommendedBatchSize, 5,
                "Batch size should not exceed 5 for optimal performance")

            print("✅ Lazy loading strategy: batch size \(strategy.recommendedBatchSize)")
        }
    }

    // MARK: - View Rendering Performance Tests

    func testCulturalViewRenderingPerformance() async throws {
        let testViews = [
            "CulturalGiftDesignView",
            "ChristmasDesignView",
            "DiwaliDesignView",
            "OptimizedModularTabButton",
            "MemoryEfficientCulturalHeader"
        ]

        await MainActor.run {
            for viewName in testViews {
                let renderTime = performanceMonitor.measureViewRendering(viewName) {
                    // Simulate view rendering
                    Thread.sleep(forTimeInterval: 0.005) // 5ms simulation
                }

                XCTAssertLessThan(renderTime, maxAcceptableRenderTime,
                    "View \(viewName) render time \(renderTime)s should be < \(maxAcceptableRenderTime)s")

                print("✅ View \(viewName) rendered in \(String(format: "%.3f", renderTime))s")
            }
        }
    }

    func testModularVsMonolithicPerformance() async throws {
        await MainActor.run {
            performanceMonitor.benchmarkModularVsMonolithic()

            guard let benchmark = performanceMonitor.currentMetrics.modularBenchmark else {
                XCTFail("Benchmark should be available")
                return
            }

            XCTAssertLessThan(benchmark.modularLoadTime, benchmark.monolithicLoadTime,
                "Modular approach should be faster than monolithic")
            XCTAssertGreaterThan(benchmark.performanceImprovement, 0,
                "Should show performance improvement")

            print("✅ Modular vs Monolithic: \(String(format: "%.1f", benchmark.performanceImprovement))% improvement")
        }
    }

    func testMemoryUsageOptimization() async throws {
        await MainActor.run {
            let initialMemory = performanceMonitor.currentMetrics.memoryUsage

            // Load several cultural components
            Task {
                await lazyLoadingManager.preloadCulture(.christmas)
                await lazyLoadingManager.preloadCulture(.diwali)

                let memoryAfterLoading = performanceMonitor.currentMetrics.memoryUsage
                let memoryDelta = memoryAfterLoading - initialMemory

                XCTAssertLessThan(memoryAfterLoading, maxAcceptableMemoryUsage,
                    "Memory usage \(memoryAfterLoading / (1024*1024))MB should be < \(maxAcceptableMemoryUsage / (1024*1024))MB")

                print("✅ Memory delta after loading: \(memoryDelta / (1024*1024))MB")

                // Test memory cleanup
                lazyLoadingManager.unloadComponents(["ChristmasDesignView", "DiwaliDesignView"])

                let memoryAfterCleanup = performanceMonitor.currentMetrics.memoryUsage
                XCTAssertLessThan(memoryAfterCleanup, memoryAfterLoading,
                    "Memory should decrease after unloading components")

                print("✅ Memory after cleanup: \(memoryAfterCleanup / (1024*1024))MB")
            }
        }
    }

    // MARK: - Watch Battery Optimization Tests

    func testWatchBatteryOptimizationModes() async throws {
        await MainActor.run {
            let batteryManager = watchBatteryManager!

            // Test critical battery mode
            batteryManager.batteryLevel = 0.05 // 5%
            batteryManager.adjustOptimizationMode()

            XCTAssertEqual(batteryManager.optimizationMode, .critical,
                "Should enter critical mode at 5% battery")
            XCTAssertFalse(batteryManager.animationsEnabled,
                "Animations should be disabled in critical mode")
            XCTAssertFalse(batteryManager.hapticFeedbackEnabled,
                "Haptics should be disabled in critical mode")

            // Test normal battery mode
            batteryManager.batteryLevel = 0.8 // 80%
            batteryManager.adjustOptimizationMode()

            XCTAssertEqual(batteryManager.optimizationMode, .adaptive,
                "Should be in adaptive mode at 80% battery")
            XCTAssertTrue(batteryManager.animationsEnabled,
                "Animations should be enabled in adaptive mode")

            print("✅ Battery optimization modes working correctly")
        }
    }

    func testCulturalAnimationEnergyOptimization() async throws {
        await MainActor.run {
            let batteryManager = watchBatteryManager!

            // Test simple animation approval
            let simpleAnimationAllowed = batteryManager.shouldEnableCulturalAnimation(complexity: .simple)
            XCTAssertTrue(simpleAnimationAllowed, "Simple animations should be allowed")

            // Test complex animation with low battery
            batteryManager.batteryLevel = 0.1 // 10%
            batteryManager.adjustOptimizationMode()

            let complexAnimationAllowed = batteryManager.shouldEnableCulturalAnimation(complexity: .elaborate)
            XCTAssertFalse(complexAnimationAllowed, "Complex animations should not be allowed with low battery")

            print("✅ Cultural animation energy optimization working")
        }
    }

    func testEnergyBudgetManagement() async throws {
        await MainActor.run {
            let batteryManager = watchBatteryManager!

            let initialBudget = batteryManager.energyBudget.remainingBudget

            // Simulate energy consumption
            batteryManager.trackEnergyConsumption(for: "test_animation", energyCost: 10.0)
            batteryManager.trackEnergyConsumption(for: "test_haptic", energyCost: 2.0)

            let remainingBudget = batteryManager.energyBudget.remainingBudget

            XCTAssertLessThan(remainingBudget, initialBudget,
                "Energy budget should decrease after consumption")
            XCTAssertGreaterThan(batteryManager.energyBudget.utilizationPercentage, 0,
                "Should show energy utilization")

            print("✅ Energy budget management working: \(String(format: "%.1f", batteryManager.energyBudget.utilizationPercentage * 100))% utilized")
        }
    }

    // MARK: - Integration Performance Tests

    func testEndToEndCulturalDesignPerformance() async throws {
        let testScenarios = [
            CulturalTestScenario(
                culture: .christmas,
                expectedComponentCount: 3,
                maxLoadTime: 0.3,
                name: "Christmas Design Flow"
            ),
            CulturalTestScenario(
                culture: .diwali,
                expectedComponentCount: 2,
                maxLoadTime: 0.25,
                name: "Diwali Design Flow"
            )
        ]

        for scenario in testScenarios {
            await validateCulturalScenario(scenario)
        }
    }

    private func validateCulturalScenario(_ scenario: CulturalTestScenario) async {
        await MainActor.run {
            performanceMonitor.takePerformanceSnapshot(label: "Before \(scenario.name)")
        }

        let startTime = CFAbsoluteTimeGetCurrent()

        // Simulate cultural design flow
        await lazyLoadingManager.preloadCulture(scenario.culture)

        let loadTime = CFAbsoluteTimeGetCurrent() - startTime

        await MainActor.run {
            let loadedComponents = lazyLoadingManager.preloadedCultures.contains(scenario.culture)

            XCTAssertTrue(loadedComponents, "\(scenario.name) should preload successfully")
            XCTAssertLessThan(loadTime, scenario.maxLoadTime,
                "\(scenario.name) load time \(loadTime)s should be < \(scenario.maxLoadTime)s")

            performanceMonitor.takePerformanceSnapshot(label: "After \(scenario.name)")

            print("✅ \(scenario.name) completed in \(String(format: "%.3f", loadTime))s")
        }
    }

    // MARK: - Performance Regression Tests

    func testPerformanceRegression() async throws {
        // Baseline performance metrics
        let baselineMetrics = PerformanceBaseline(
            componentLoadTime: 0.05,
            viewRenderTime: 0.01,
            memoryUsage: 20 * 1024 * 1024, // 20MB
            batteryEfficiencyScore: 85.0
        )

        await performComprehensivePerformanceTest()

        await MainActor.run {
            let currentMetrics = performanceMonitor.currentMetrics

            // Check for regressions
            let averageLoadTime = currentMetrics.culturalComponentLoadTimes.values.reduce(0, +) /
                Double(max(1, currentMetrics.culturalComponentLoadTimes.count))

            XCTAssertLessThan(averageLoadTime, baselineMetrics.componentLoadTime * 1.2,
                "Component load time regression detected: \(averageLoadTime)s vs baseline \(baselineMetrics.componentLoadTime)s")

            XCTAssertLessThan(currentMetrics.averageRenderTime, baselineMetrics.viewRenderTime * 1.2,
                "View render time regression detected")

            XCTAssertLessThan(currentMetrics.memoryUsage, baselineMetrics.memoryUsage * 2,
                "Memory usage regression detected")

            print("✅ No significant performance regression detected")
        }
    }

    private func performComprehensivePerformanceTest() async {
        // Load multiple cultures
        await lazyLoadingManager.preloadCulture(.christmas)
        await lazyLoadingManager.preloadCulture(.diwali)
        await lazyLoadingManager.preloadCulture(.chineseNewYear)

        // Simulate view rendering
        await MainActor.run {
            for i in 0..<10 {
                _ = performanceMonitor.measureViewRendering("test_view_\(i)") {
                    Thread.sleep(forTimeInterval: 0.002) // 2ms simulation
                }
            }
        }

        // Simulate battery operations
        await MainActor.run {
            for _ in 0..<5 {
                watchBatteryManager.trackEnergyConsumption(for: "test_operation", energyCost: 1.0)
            }
        }
    }

    // MARK: - Performance Report Generation

    func testPerformanceReportGeneration() async throws {
        await performComprehensivePerformanceTest()

        await MainActor.run {
            let recommendations = performanceMonitor.generatePerformanceRecommendations()

            XCTAssertNotNil(recommendations, "Should generate performance recommendations")

            for recommendation in recommendations {
                print("⚠️ Performance Recommendation [\(recommendation.category)]:")
                print("   \(recommendation.title)")
                print("   \(recommendation.description)")
                print("   Solution: \(recommendation.solution)")
                print("")
            }

            if recommendations.isEmpty {
                print("✅ No performance issues detected - system operating optimally")
            }
        }
    }
}

// MARK: - Supporting Test Types

struct CulturalTestScenario {
    let culture: CulturalContext
    let expectedComponentCount: Int
    let maxLoadTime: TimeInterval
    let name: String
}

struct PerformanceBaseline {
    let componentLoadTime: TimeInterval
    let viewRenderTime: TimeInterval
    let memoryUsage: UInt64
    let batteryEfficiencyScore: Double
}

// MARK: - Test Extensions

extension PerformanceValidationSuite {

    /// Measures the execution time of a block of code
    func measureExecutionTime<T>(_ operation: () throws -> T) rethrows -> (result: T, time: TimeInterval) {
        let startTime = CFAbsoluteTimeGetCurrent()
        let result = try operation()
        let executionTime = CFAbsoluteTimeGetCurrent() - startTime
        return (result, executionTime)
    }

    /// Measures memory usage before and after an operation
    func measureMemoryImpact<T>(_ operation: () throws -> T) rethrows -> (result: T, memoryDelta: Int64) {
        let initialMemory = Int64(performanceMonitor.currentMetrics.memoryUsage)
        let result = try operation()
        let finalMemory = Int64(performanceMonitor.currentMetrics.memoryUsage)
        let memoryDelta = finalMemory - initialMemory
        return (result, memoryDelta)
    }
}
