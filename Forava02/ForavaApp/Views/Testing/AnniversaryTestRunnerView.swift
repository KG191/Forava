import SwiftUI

/// Interactive test runner UI for Anniversary AI generation tests
/// Provides visual progress tracking and detailed results reporting
struct AnniversaryTestRunnerView: View {

    @StateObject private var testingAgent = AnniversaryTestingAgent()
    @State private var selectedConfiguration: ConfigOption = .standard
    @State private var showResults = false
    @State private var testReport: AnniversaryTestingAgent.TestReport?
    @State private var showError = false
    @State private var errorMessage = ""

    enum ConfigOption: String, CaseIterable {
        case quick = "Quick (Baseline Only)"
        case standard = "Standard (All Tests)"

        var configuration: AnniversaryTestingAgent.TestingConfiguration {
            switch self {
            case .quick: return .quick
            case .standard: return .standard
            }
        }

        var description: String {
            switch self {
            case .quick:
                return "Baseline tests only - ~30 tests, no image saving (~2 min)"
            case .standard:
                return "All 240 tests with placeholder scoring, saves images (~8 min)"
            }
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {

                    // Header
                    headerSection

                    // Configuration Selection
                    if !testingAgent.isRunning {
                        configurationSection
                    }

                    // Progress Display
                    if testingAgent.isRunning {
                        progressSection
                    }

                    // Results Summary
                    if let report = testReport {
                        resultsSection(report: report)
                    }

                    // Action Buttons
                    actionButtons
                }
                .padding()
            }
            .navigationTitle("Anniversary AI Tests")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showResults) {
                if let report = testReport {
                    TestReportDetailView(report: report)
                }
            }
            .alert("Test Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }

    // MARK: - Header Section

    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "wand.and.stars")
                .font(.system(size: 48))
                .foregroundColor(.orange)

            Text("Anniversary AI Test Suite")
                .font(.title2)
                .fontWeight(.bold)

            Text("Comprehensive validation of 240 strategic test cases")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical)
    }

    // MARK: - Configuration Section

    private var configurationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Test Configuration")
                .font(.headline)

            ForEach(ConfigOption.allCases, id: \.self) { option in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(option.rawValue)
                            .font(.body)
                            .fontWeight(.medium)

                        Text(option.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    if selectedConfiguration == option {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.orange)
                    } else {
                        Image(systemName: "circle")
                            .foregroundColor(.gray)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedConfiguration = option
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(selectedConfiguration == option ? Color.orange.opacity(0.1) : Color.gray.opacity(0.05))
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemBackground))
        )
    }

    // MARK: - Progress Section

    private var progressSection: some View {
        VStack(spacing: 16) {
            Text(testingAgent.currentPhase)
                .font(.headline)

            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 20)

                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.orange)
                        .frame(width: geometry.size.width * testingAgent.currentProgress, height: 20)
                }
            }
            .frame(height: 20)

            // Progress Stats
            HStack {
                VStack(alignment: .leading) {
                    Text("Current Test")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(testingAgent.currentTestID.isEmpty ? "—" : testingAgent.currentTestID)
                        .font(.body)
                        .fontWeight(.medium)
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text("Progress")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(testingAgent.completedTests)/\(testingAgent.totalTests)")
                        .font(.body)
                        .fontWeight(.medium)
                }
            }

            // Spinning Progress Indicator
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .orange))
                .scaleEffect(1.5)
                .padding()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemBackground))
        )
    }

    // MARK: - Results Section

    private func resultsSection(report: AnniversaryTestingAgent.TestReport) -> some View {
        VStack(spacing: 16) {
            Text("Test Results")
                .font(.headline)

            // Success Rate Gauge
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                    .frame(width: 120, height: 120)

                Circle()
                    .trim(from: 0, to: report.successRate / 100)
                    .stroke(
                        report.successRate >= 80 ? Color.green : report.successRate >= 60 ? Color.orange : Color.red,
                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                    )
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))

                VStack {
                    Text("\(Int(report.successRate))%")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Success")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()

            // Stats Grid
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                statCard(title: "Total Tests", value: "\(report.totalTests)", color: .blue)
                statCard(title: "Passed", value: "\(report.passingTests)", color: .green)
                statCard(title: "Failed", value: "\(report.failingTests)", color: .red)
                statCard(title: "Duration", value: String(format: "%.1f min", report.executionTime / 60), color: .orange)
            }

            // Average Scores
            VStack(alignment: .leading, spacing: 8) {
                Text("Average Scores")
                    .font(.subheadline)
                    .fontWeight(.medium)

                scoreBar(title: "Theme Fidelity", score: report.averageScores.themeFidelity)
                scoreBar(title: "Element Integration", score: report.averageScores.elementIntegration)
                scoreBar(title: "Color Conformance", score: report.averageScores.colorConformance)
                scoreBar(title: "Technical Quality", score: report.averageScores.technicalQuality)
            }
            .padding(.top)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemBackground))
        )
    }

    private func statCard(title: String, value: String, color: Color) -> some View {
        VStack {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.tertiarySystemBackground))
        )
    }

    private func scoreBar(title: String, score: Double) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(.caption)
                Spacer()
                Text(String(format: "%.1f", score))
                    .font(.caption)
                    .fontWeight(.medium)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(score >= 80 ? Color.green : score >= 60 ? Color.orange : Color.red)
                        .frame(width: geometry.size.width * (score / 100), height: 8)
                }
            }
            .frame(height: 8)
        }
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {
        VStack(spacing: 12) {
            if !testingAgent.isRunning {
                Button(action: runTests) {
                    HStack {
                        Image(systemName: "play.fill")
                        Text("Run Tests")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(12)
                }
            }

            if testReport != nil {
                Button(action: { showResults = true }) {
                    HStack {
                        Image(systemName: "doc.text.magnifyingglass")
                        Text("View Detailed Report")
                    }
                    .font(.headline)
                    .foregroundColor(.orange)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
                }

                Button(action: exportReport) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Export Report")
                    }
                    .font(.headline)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                }
            }
        }
    }

    // MARK: - Actions

    private func runTests() {
        Task {
            do {
                let report = try await testingAgent.executeTestSuite(configuration: selectedConfiguration.configuration)
                await MainActor.run {
                    testReport = report
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showError = true
                }
            }
        }
    }

    private func exportReport() {
        guard let report = testReport else { return }

        do {
            try testingAgent.saveReportToFile(report: report)
            // Show success message
            errorMessage = "Report exported successfully to Documents/TestResults/"
            showError = true
        } catch {
            errorMessage = "Failed to export report: \(error.localizedDescription)"
            showError = true
        }
    }
}

// MARK: - Test Report Detail View

struct TestReportDetailView: View {
    let report: AnniversaryTestingAgent.TestReport
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    // Summary
                    Text(report.summary)
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(12)

                    // Failed Tests
                    if !report.allResults.filter({ !$0.isPassing }).isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Failed Tests")
                                .font(.headline)

                            ForEach(report.allResults.filter { !$0.isPassing }, id: \.testID) { result in
                                failedTestCard(result: result)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Test Report")
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

    private func failedTestCard(result: AnniversaryValidationCriteria.ValidationResult) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(result.testID)
                    .font(.subheadline)
                    .fontWeight(.medium)

                Spacer()

                Text(String(format: "%.1f/100", result.overallScore))
                    .font(.caption)
                    .foregroundColor(.red)
            }

            Text("Theme: \(result.theme.rawValue) | Gift: \(result.giftOption)")
                .font(.caption)
                .foregroundColor(.secondary)

            if !result.gaps.isEmpty {
                Text("Issues: \(result.gaps.count)")
                    .font(.caption)
                    .foregroundColor(.red)

                ForEach(result.gaps.prefix(3)) { gap in
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.caption2)
                            .foregroundColor(.orange)
                        Text(gap.description)
                            .font(.caption2)
                    }
                }
            }
        }
        .padding()
        .background(Color(UIColor.tertiarySystemBackground))
        .cornerRadius(8)
    }
}

// MARK: - Preview

struct AnniversaryTestRunnerView_Previews: PreviewProvider {
    static var previews: some View {
        AnniversaryTestRunnerView()
    }
}
