import SwiftUI
import Charts

struct UsageDashboardView: View {
    @StateObject private var usageService = UsageTrackingService.shared
    @StateObject private var subscriptionManager = SubscriptionManager.shared
    @State private var selectedPeriod: AnalyticsPeriod = .month
    @State private var showingSubscriptionView = false

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    // Header with current status
                    currentStatusSection

                    // Usage analytics period selector
                    periodSelectorSection

                    // Usage charts
                    usageChartsSection

                    // Cultural breakdown
                    culturalBreakdownSection

                    // Recent activity
                    recentActivitySection

                    // Monthly report
                    if let monthlyReport = usageService.monthlyReport {
                        monthlyReportSection(report: monthlyReport)
                    }
                }
                .padding()
            }
            .navigationTitle("Usage Analytics")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Manage Plan") {
                        showingSubscriptionView = true
                    }
                }
            }
        }
        .sheet(isPresented: $showingSubscriptionView) {
            SubscriptionTierView()
        }
        .task {
            usageService.monthlyReport = usageService.getMonthlyReport()
        }
    }

    // MARK: - Current Status Section
    private var currentStatusSection: some View {
        VStack(spacing: 16) {
            // Plan status
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Current Plan")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text(subscriptionManager.subscriptionStatus.tier.displayName)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(subscriptionManager.subscriptionStatus.tier.primaryColor)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("Next Renewal")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text(subscriptionManager.subscriptionStatus.renewalDate.formatted(date: .abbreviated, time: .omitted))
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
            }

            // Usage progress
            let remaining = subscriptionManager.subscriptionStatus.generationsRemaining
            let total = subscriptionManager.subscriptionStatus.tier.monthlyGenerationsIncluded
            let used = total - remaining
            let usagePercentage = total > 0 ? Double(used) / Double(total) : 0.0

            VStack(spacing: 12) {
                HStack {
                    Text("AI Generations This Month")
                        .font(.headline)
                        .fontWeight(.semibold)
                    Spacer()
                    Text("\(used)/\(total)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(usagePercentage > 0.8 ? .orange : .primary)
                }

                ProgressView(value: usagePercentage)
                    .tint(usagePercentage > 0.8 ? .orange : subscriptionManager.subscriptionStatus.tier.primaryColor)

                HStack {
                    Text("\(remaining) generations remaining")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Spacer()

                    if remaining == 0 {
                        Text("$\(String(format: "%.2f", subscriptionManager.subscriptionStatus.tier.regenerationCost)) per additional")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    // MARK: - Period Selector
    private var periodSelectorSection: some View {
        Picker("Analytics Period", selection: $selectedPeriod) {
            ForEach(AnalyticsPeriod.allCases, id: \.self) { period in
                Text(period.displayName).tag(period)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    // MARK: - Usage Charts
    private var usageChartsSection: some View {
        let analytics = usageService.getUsageAnalytics(for: selectedPeriod)

        return VStack(spacing: 16) {
            // Generation count chart
            VStack(alignment: .leading, spacing: 12) {
                Text("Generation Activity")
                    .font(.headline)
                    .fontWeight(.semibold)

                if !usageService.dailyUsage.isEmpty {
                    Chart {
                        ForEach(usageService.dailyUsage.prefix(selectedPeriod.days).reversed(), id: \.id) { day in
                            BarMark(
                                x: .value("Date", day.date, unit: .day),
                                y: .value("Generations", day.generationsCount)
                            )
                            .foregroundStyle(Color.blue)

                            if day.regenerationsCount > 0 {
                                BarMark(
                                    x: .value("Date", day.date, unit: .day),
                                    y: .value("Regenerations", day.regenerationsCount)
                                )
                                .foregroundStyle(Color.orange)
                            }
                        }
                    }
                    .frame(height: 120)
                } else {
                    VStack(spacing: 8) {
                        Image(systemName: "chart.bar")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        Text("No generation data yet")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(height: 120)
                }

                HStack {
                    HStack(spacing: 8) {
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: 12, height: 12)
                            .cornerRadius(2)
                        Text("Generations")
                            .font(.caption)
                    }

                    HStack(spacing: 8) {
                        Rectangle()
                            .fill(Color.orange)
                            .frame(width: 12, height: 12)
                            .cornerRadius(2)
                        Text("Regenerations")
                            .font(.caption)
                    }

                    Spacer()

                    Text("Avg: \(String(format: "%.1f", analytics.averageGenerationsPerDay))/day")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    // MARK: - Cultural Breakdown
    private var culturalBreakdownSection: some View {
        let analytics = usageService.getUsageAnalytics(for: selectedPeriod)

        return VStack(alignment: .leading, spacing: 12) {
            Text("Cultural Context Usage")
                .font(.headline)
                .fontWeight(.semibold)

            if !analytics.cultureBreakdown.isEmpty {
                ForEach(Array(analytics.cultureBreakdown.sorted { $0.value > $1.value }), id: \.key) { culture, count in
                    HStack {
                        HStack(spacing: 8) {
                            Image(systemName: culture.icon)
                                .foregroundColor(culture.primaryColor)
                            Text(culture.displayName)
                                .font(.subheadline)
                        }

                        Spacer()

                        VStack(alignment: .trailing, spacing: 2) {
                            Text("\(count)")
                                .font(.subheadline)
                                .fontWeight(.semibold)

                            let percentage = analytics.totalGenerations > 0 ?
                                Double(count) / Double(analytics.totalGenerations) * 100 : 0
                            Text("\(String(format: "%.0f", percentage))%")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 2)
                }
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "globe.americas")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    Text("No cultural usage data yet")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    // MARK: - Recent Activity
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Activity")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Text("Last 7 days")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            if !usageService.generationHistory.isEmpty {
                ForEach(Array(usageService.generationHistory.prefix(5)), id: \.id) { record in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            HStack(spacing: 8) {
                                Image(systemName: record.culturalContext.icon)
                                    .foregroundColor(record.culturalContext.primaryColor)
                                    .font(.caption)

                                Text(record.culturalContext.displayName)
                                    .font(.caption)
                                    .fontWeight(.medium)

                                if let pack = record.premiumPack {
                                    Image(systemName: pack.icon)
                                        .foregroundColor(.purple)
                                        .font(.caption2)
                                }

                                if record.wasRegeneration {
                                    Text("Regeneration")
                                        .font(.caption2)
                                        .fontWeight(.medium)
                                        .foregroundColor(.orange)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.orange.opacity(0.15))
                                        .cornerRadius(4)
                                }
                            }

                            Text(record.timestamp.formatted(date: .omitted, time: .shortened))
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        if record.cost > 0 {
                            Text("$\(String(format: "%.2f", record.cost))")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.orange)
                        }
                    }
                    .padding(.vertical, 4)
                }
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "clock")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    Text("No recent activity")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    // MARK: - Monthly Report Section
    private func monthlyReportSection(report: MonthlyReport) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Monthly Report")
                .font(.headline)
                .fontWeight(.semibold)

            VStack(spacing: 12) {
                // Generation summary
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Total Generations")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(report.totalGenerations)")
                            .font(.title3)
                            .fontWeight(.bold)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Additional Generations")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(report.additionalGenerations)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                    }
                }

                // Spending summary
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Total Spent")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("$\(String(format: "%.2f", report.totalSpent))")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(report.totalSpent > 0 ? .orange : .primary)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Estimated Savings")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("$\(String(format: "%.2f", report.estimatedSavings))")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                }

                // Top cultures
                if !report.topCultures.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Most Used Cultures")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        HStack {
                            ForEach(report.topCultures.prefix(3), id: \.self) { culture in
                                HStack(spacing: 4) {
                                    Image(systemName: culture.icon)
                                        .foregroundColor(culture.primaryColor)
                                        .font(.caption2)
                                    Text(culture.displayName)
                                        .font(.caption2)
                                        .fontWeight(.medium)
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color(.systemGray5))
                                .cornerRadius(8)
                            }
                            Spacer()
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    UsageDashboardView()
}
