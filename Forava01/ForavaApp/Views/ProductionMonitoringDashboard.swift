import SwiftUI
import Charts

struct ProductionMonitoringDashboard: View {
    @StateObject private var performanceOptimizer = PerformanceOptimizer.shared
    @State private var selectedTimeRange: TimeRange = .last24Hours
    @State private var showingDetailedMetrics = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header with status overview
                    SystemStatusOverview(metrics: performanceOptimizer.currentMetrics)
                    
                    // Time range selector
                    TimeRangeSelector(selectedRange: $selectedTimeRange)
                    
                    // Performance metrics charts
                    PerformanceChartsSection(
                        metrics: performanceOptimizer.currentMetrics,
                        timeRange: selectedTimeRange
                    )
                    
                    // Optimization recommendations
                    OptimizationRecommendationsSection(
                        recommendations: performanceOptimizer.optimizationRecommendations
                    )
                    
                    // System health indicators
                    SystemHealthSection(metrics: performanceOptimizer.currentMetrics)
                    
                    // AI & Animation Performance
                    AIPerformanceSection(metrics: performanceOptimizer.currentMetrics)
                }
                .padding()
            }
            .navigationTitle("Production Monitoring")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Details") {
                        showingDetailedMetrics = true
                    }
                }
            }
            .sheet(isPresented: $showingDetailedMetrics) {
                DetailedMetricsView(metrics: performanceOptimizer.currentMetrics)
            }
        }
    }
}

struct SystemStatusOverview: View {
    let metrics: PerformanceMetrics
    
    var systemStatus: SystemStatus {
        if metrics.memoryUsage > 85 || metrics.cpuUsage > 80 || metrics.batteryLevel < 15 {
            return .critical
        } else if metrics.memoryUsage > 70 || metrics.cpuUsage > 60 || metrics.batteryLevel < 30 {
            return .warning
        } else {
            return .healthy
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("System Status")
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)
                
                Spacer()
                
                StatusIndicator(status: systemStatus)
            }
            
            HStack(spacing: 20) {
                MetricCard(
                    title: "Memory",
                    value: "\(Int(metrics.memoryUsage))%",
                    status: metrics.memoryUsage > 85 ? .critical : metrics.memoryUsage > 70 ? .warning : .healthy,
                    icon: "memorychip"
                )
                
                MetricCard(
                    title: "CPU",
                    value: "\(Int(metrics.cpuUsage))%",
                    status: metrics.cpuUsage > 80 ? .critical : metrics.cpuUsage > 60 ? .warning : .healthy,
                    icon: "cpu"
                )
                
                MetricCard(
                    title: "Battery",
                    value: "\(Int(metrics.batteryLevel))%",
                    status: metrics.batteryLevel < 15 ? .critical : metrics.batteryLevel < 30 ? .warning : .healthy,
                    icon: "battery.100"
                )
            }
        }
        .padding(20)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

struct StatusIndicator: View {
    let status: SystemStatus
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(status.color)
                .frame(width: 8, height: 8)
            
            Text(status.rawValue)
                .font(.system(.subheadline, design: .rounded).weight(.medium))
                .foregroundStyle(status.color)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(status.color.opacity(0.1), in: Capsule())
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let status: SystemStatus
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(.title2))
                .foregroundStyle(status.color)
            
            Text(value)
                .font(.system(.title3, design: .rounded).weight(.bold))
                .foregroundStyle(.primary)
            
            Text(title)
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(status.color.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(status.color.opacity(0.2), lineWidth: 1)
        }
    }
}

struct TimeRangeSelector: View {
    @Binding var selectedRange: TimeRange
    
    var body: some View {
        HStack {
            Text("Time Range")
                .font(.system(.subheadline, design: .rounded).weight(.semibold))
                .foregroundStyle(.primary)
            
            Spacer()
            
            Picker("Time Range", selection: $selectedRange) {
                ForEach(TimeRange.allCases, id: \.self) { range in
                    Text(range.displayName).tag(range)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 200)
        }
        .padding(.horizontal, 20)
    }
}

struct PerformanceChartsSection: View {
    let metrics: PerformanceMetrics
    let timeRange: TimeRange
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Performance Trends")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            // Memory Usage Chart
            ChartCard(
                title: "Memory Usage",
                currentValue: "\(Int(metrics.memoryUsage))%",
                chart: AnyView(MemoryUsageChart(timeRange: timeRange))
            )
            
            // AI Generation Performance Chart
            ChartCard(
                title: "AI Generation Time",
                currentValue: "\(metrics.aiGenerationTime, specifier: "%.1f")s",
                chart: AnyView(AIPerformanceChart(timeRange: timeRange))
            )
            
            // Network Latency Chart
            ChartCard(
                title: "Network Latency",
                currentValue: "\(Int(metrics.networkLatency))ms",
                chart: AnyView(NetworkLatencyChart(timeRange: timeRange))
            )
        }
    }
}

struct ChartCard: View {
    let title: String
    let currentValue: String
    let chart: AnyView
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(.subheadline, design: .rounded).weight(.medium))
                        .foregroundStyle(.secondary)
                    
                    Text(currentValue)
                        .font(.system(.title2, design: .rounded).weight(.bold))
                        .foregroundStyle(.primary)
                }
                
                Spacer()
            }
            
            chart
                .frame(height: 120)
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct MemoryUsageChart: View {
    let timeRange: TimeRange
    
    var sampleData: [ChartDataPoint] {
        // Generate sample data for demonstration
        (0..<timeRange.dataPoints).map { i in
            ChartDataPoint(
                timestamp: Date().addingTimeInterval(-Double(i) * timeRange.interval),
                value: Double.random(in: 40...85)
            )
        }.reversed()
    }
    
    var body: some View {
        Chart(sampleData) { dataPoint in
            LineMark(
                x: .value("Time", dataPoint.timestamp),
                y: .value("Memory %", dataPoint.value)
            )
            .foregroundStyle(.blue)
            
            AreaMark(
                x: .value("Time", dataPoint.timestamp),
                y: .value("Memory %", dataPoint.value)
            )
            .foregroundStyle(.blue.opacity(0.1))
        }
        .chartYScale(domain: 0...100)
        .chartXAxis {
            AxisMarks(values: .stride(by: .hour, count: timeRange.hourStride)) { _ in
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: .dateTime.hour())
            }
        }
    }
}

struct AIPerformanceChart: View {
    let timeRange: TimeRange
    
    var sampleData: [ChartDataPoint] {
        (0..<timeRange.dataPoints).map { i in
            ChartDataPoint(
                timestamp: Date().addingTimeInterval(-Double(i) * timeRange.interval),
                value: Double.random(in: 5...25)
            )
        }.reversed()
    }
    
    var body: some View {
        Chart(sampleData) { dataPoint in
            LineMark(
                x: .value("Time", dataPoint.timestamp),
                y: .value("Generation Time", dataPoint.value)
            )
            .foregroundStyle(.orange)
        }
        .chartYScale(domain: 0...30)
        .chartXAxis {
            AxisMarks(values: .stride(by: .hour, count: timeRange.hourStride)) { _ in
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: .dateTime.hour())
            }
        }
    }
}

struct NetworkLatencyChart: View {
    let timeRange: TimeRange
    
    var sampleData: [ChartDataPoint] {
        (0..<timeRange.dataPoints).map { i in
            ChartDataPoint(
                timestamp: Date().addingTimeInterval(-Double(i) * timeRange.interval),
                value: Double.random(in: 50...500)
            )
        }.reversed()
    }
    
    var body: some View {
        Chart(sampleData) { dataPoint in
            LineMark(
                x: .value("Time", dataPoint.timestamp),
                y: .value("Latency", dataPoint.value)
            )
            .foregroundStyle(.green)
        }
        .chartYScale(domain: 0...1000)
        .chartXAxis {
            AxisMarks(values: .stride(by: .hour, count: timeRange.hourStride)) { _ in
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: .dateTime.hour())
            }
        }
    }
}

struct OptimizationRecommendationsSection: View {
    let recommendations: [OptimizationRecommendation]
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Optimization Recommendations")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)
                
                Spacer()
                
                if recommendations.isEmpty {
                    Text("All systems optimal")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.green)
                } else {
                    Text("\(recommendations.count) recommendations")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.orange)
                }
            }
            .padding(.horizontal, 20)
            
            if recommendations.isEmpty {
                OptimalStateView()
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(recommendations) { recommendation in
                        RecommendationCard(recommendation: recommendation)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct RecommendationCard: View {
    let recommendation: OptimizationRecommendation
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(recommendation.severity.color)
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(recommendation.description)
                    .font(.system(.subheadline, design: .rounded).weight(.medium))
                    .foregroundStyle(.primary)
                
                Text(recommendation.action)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text(recommendation.severity.rawValue.capitalized)
                .font(.system(.caption2, design: .rounded).weight(.medium))
                .foregroundStyle(recommendation.severity.color)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(recommendation.severity.color.opacity(0.1), in: Capsule())
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(recommendation.severity.color.opacity(0.3), lineWidth: 1)
        }
    }
}

struct OptimalStateView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 40))
                .foregroundStyle(.green)
            
            Text("System Running Optimally")
                .font(.system(.headline, design: .rounded).weight(.semibold))
                .foregroundStyle(.primary)
            
            Text("All performance metrics are within optimal ranges")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(20)
        .background(.green.opacity(0.05), in: RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.green.opacity(0.2), lineWidth: 1)
        }
        .padding(.horizontal, 20)
    }
}

struct SystemHealthSection: View {
    let metrics: PerformanceMetrics
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("System Health")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                HealthMetricCard(
                    title: "Cache Hit Rate",
                    value: "\(Int(metrics.cacheHitRate * 100))%",
                    isHealthy: metrics.cacheHitRate > 0.7,
                    icon: "externaldrive.fill"
                )
                
                HealthMetricCard(
                    title: "Animation FPS",
                    value: "\(Int(metrics.animationFrameRate))",
                    isHealthy: metrics.animationFrameRate >= 30.0,
                    icon: "play.circle.fill"
                )
                
                HealthMetricCard(
                    title: "Generation Time",
                    value: "\(metrics.aiGenerationTime, specifier: "%.1f")s",
                    isHealthy: metrics.aiGenerationTime < 20.0,
                    icon: "wand.and.stars"
                )
                
                HealthMetricCard(
                    title: "Network Quality",
                    value: metrics.networkLatency < 500 ? "Good" : "Poor",
                    isHealthy: metrics.networkLatency < 500,
                    icon: "network"
                )
            }
            .padding(.horizontal, 20)
        }
    }
}

struct HealthMetricCard: View {
    let title: String
    let value: String
    let isHealthy: Bool
    let icon: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(.title2))
                .foregroundStyle(isHealthy ? .green : .orange)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.system(.title3, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)
                
                Text(title)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(isHealthy ? .green.opacity(0.05) : .orange.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(isHealthy ? .green.opacity(0.2) : .orange.opacity(0.2), lineWidth: 1)
        }
    }
}

struct AIPerformanceSection: View {
    let metrics: PerformanceMetrics
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("AI & Animation Performance")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            VStack(spacing: 12) {
                PerformanceRow(
                    title: "Average Generation Time",
                    value: "\(metrics.aiGenerationTime, specifier: "%.1f")s",
                    target: "< 20s",
                    isOnTarget: metrics.aiGenerationTime < 20.0
                )
                
                PerformanceRow(
                    title: "Animation Frame Rate",
                    value: "\(Int(metrics.animationFrameRate)) FPS",
                    target: "> 30 FPS",
                    isOnTarget: metrics.animationFrameRate >= 30.0
                )
                
                PerformanceRow(
                    title: "Cache Efficiency",
                    value: "\(Int(metrics.cacheHitRate * 100))%",
                    target: "> 70%",
                    isOnTarget: metrics.cacheHitRate > 0.7
                )
                
                PerformanceRow(
                    title: "Network Response",
                    value: "\(Int(metrics.networkLatency))ms",
                    target: "< 500ms",
                    isOnTarget: metrics.networkLatency < 500
                )
            }
            .padding(16)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 20)
        }
    }
}

struct PerformanceRow: View {
    let title: String
    let value: String
    let target: String
    let isOnTarget: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(.subheadline, design: .rounded).weight(.medium))
                    .foregroundStyle(.primary)
                
                Text("Target: \(target)")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Text(value)
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)
                
                Image(systemName: isOnTarget ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                    .font(.system(.subheadline))
                    .foregroundStyle(isOnTarget ? .green : .orange)
            }
        }
    }
}

struct DetailedMetricsView: View {
    let metrics: PerformanceMetrics
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    DetailedMetricSection(title: "Memory", metrics: [
                        ("Current Usage", "\(Int(metrics.memoryUsage))%"),
                        ("Physical Memory", "8 GB"),
                        ("Available Memory", "\(Int(100 - metrics.memoryUsage))%")
                    ])
                    
                    DetailedMetricSection(title: "CPU", metrics: [
                        ("Current Load", "\(Int(metrics.cpuUsage))%"),
                        ("Core Count", "8 cores"),
                        ("Architecture", "Apple Silicon")
                    ])
                    
                    DetailedMetricSection(title: "Network", metrics: [
                        ("Latency", "\(Int(metrics.networkLatency))ms"),
                        ("Connection Type", "WiFi"),
                        ("Bandwidth", "High")
                    ])
                    
                    DetailedMetricSection(title: "AI Performance", metrics: [
                        ("Generation Time", "\(metrics.aiGenerationTime, specifier: "%.1f")s"),
                        ("Model", "SDXL"),
                        ("Quality Score", "0.9/1.0")
                    ])
                }
                .padding()
            }
            .navigationTitle("Detailed Metrics")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct DetailedMetricSection: View {
    let title: String
    let metrics: [(String, String)]
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(title)
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)
                
                Spacer()
            }
            
            VStack(spacing: 8) {
                ForEach(Array(metrics.enumerated()), id: \.offset) { _, metric in
                    HStack {
                        Text(metric.0)
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Text(metric.1)
                            .font(.system(.subheadline, design: .rounded).weight(.medium))
                            .foregroundStyle(.primary)
                    }
                }
            }
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Supporting Types

enum SystemStatus: String, CaseIterable {
    case healthy = "Healthy"
    case warning = "Warning"
    case critical = "Critical"
    
    var color: Color {
        switch self {
        case .healthy: return .green
        case .warning: return .orange
        case .critical: return .red
        }
    }
}

enum TimeRange: CaseIterable {
    case lastHour
    case last6Hours
    case last24Hours
    case lastWeek
    
    var displayName: String {
        switch self {
        case .lastHour: return "1H"
        case .last6Hours: return "6H"
        case .last24Hours: return "24H"
        case .lastWeek: return "1W"
        }
    }
    
    var dataPoints: Int {
        switch self {
        case .lastHour: return 12 // Every 5 minutes
        case .last6Hours: return 24 // Every 15 minutes
        case .last24Hours: return 24 // Every hour
        case .lastWeek: return 28 // Every 6 hours
        }
    }
    
    var interval: TimeInterval {
        switch self {
        case .lastHour: return 300 // 5 minutes
        case .last6Hours: return 900 // 15 minutes
        case .last24Hours: return 3600 // 1 hour
        case .lastWeek: return 21600 // 6 hours
        }
    }
    
    var hourStride: Int {
        switch self {
        case .lastHour: return 1
        case .last6Hours: return 2
        case .last24Hours: return 4
        case .lastWeek: return 24
        }
    }
}

struct ChartDataPoint: Identifiable {
    let id = UUID()
    let timestamp: Date
    let value: Double
}

extension OptimizationRecommendation.Severity {
    var rawValue: String {
        switch self {
        case .low: return "low"
        case .medium: return "medium"
        case .high: return "high"
        case .critical: return "critical"
        }
    }
}

#Preview {
    ProductionMonitoringDashboard()
}