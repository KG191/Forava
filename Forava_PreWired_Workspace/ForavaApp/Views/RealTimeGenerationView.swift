import SwiftUI
import Combine

struct RealTimeGenerationView: View {
    let designSpec: RakhiDesignSpec
    let advancedPrompt: AdvancedPrompt

    @StateObject private var realTimeService = RealTimeGenerationService.shared
    @State private var generationStream: AsyncThrowingStream<GenerationUpdate, Error>?
    @State private var currentUpdate: GenerationUpdate?
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var generatedRakhi: GeneratedRakhi?

    var body: some View {
        VStack(spacing: 20) {
            // Header with status
            GenerationHeaderView(
                status: realTimeService.currentGenerationStatus,
                timeRemaining: realTimeService.estimatedTimeRemaining
            )

            // Main generation area
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.regularMaterial)
                    .frame(height: 400)

                if let generatedRakhi = generatedRakhi {
                    // Show completed result
                    CompletedGenerationView(rakhi: generatedRakhi)
                } else {
                    // Show progress
                    VStack(spacing: 30) {
                        // Progress visualization
                        if let progress = realTimeService.realTimeProgress {
                            RealTimeProgressView(progress: progress)
                        } else {
                            InitialGenerationView()
                        }

                        // Quality metrics
                        if let metrics = realTimeService.qualityMetrics {
                            QualityMetricsView(metrics: metrics)
                        }
                    }
                    .padding(20)
                }
            }

            // Controls
            GenerationControlsView(
                status: realTimeService.currentGenerationStatus,
                onStart: startGeneration,
                onCancel: cancelGeneration
            )
        }
        .padding()
        .alert("Generation Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }

    private func startGeneration() {
        Task {
            do {
                generationStream = try await realTimeService.startRealTimeGeneration(
                    with: advancedPrompt,
                    designSpec: designSpec
                )

                await processGenerationUpdates()

            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showingError = true
                }
            }
        }
    }

    private func processGenerationUpdates() async {
        guard let stream = generationStream else { return }

        do {
            for try await update in stream {
                await MainActor.run {
                    currentUpdate = update

                    switch update {
                    case .statusUpdate:
                        // Status is handled by the service's @Published property
                        break

                    case .progressUpdate:
                        // Progress is handled by the service's @Published property
                        break

                    case .completed(let rakhi):
                        generatedRakhi = rakhi
                        playCompletionFeedback()
                    }
                }
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                showingError = true
            }
        }
    }

    private func cancelGeneration() {
        Task {
            await realTimeService.cancelGeneration()
        }
    }

    private func playCompletionFeedback() {
        #if os(iOS)
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        #endif
    }
}

struct GenerationHeaderView: View {
    let status: GenerationStatus
    let timeRemaining: TimeInterval

    var body: some View {
        HStack {
            HStack(spacing: 12) {
                Circle()
                    .fill(status.color)
                    .frame(width: 12, height: 12)
                    .animation(.easeInOut(duration: 0.3), value: status.color)

                Text(status.displayName)
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)
            }

            Spacer()

            if timeRemaining > 0 && status == .processing {
                Text("~\(Int(timeRemaining))s remaining")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.orange.opacity(0.1), in: Capsule())
            }
        }
    }
}

struct RealTimeProgressView: View {
    let progress: GenerationProgress

    var body: some View {
        VStack(spacing: 20) {
            // Stage indicator
            Text(progress.stage.displayName)
                .font(.system(.title2, design: .rounded).weight(.bold))
                .foregroundStyle(.primary)

            // Progress ring
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                    .frame(width: 120, height: 120)

                Circle()
                    .trim(from: 0, to: CGFloat(progress.progress))
                    .stroke(
                        LinearGradient(
                            colors: [.orange, .red.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 0.6), value: progress.progress)

                VStack(spacing: 4) {
                    Text("\(Int(progress.progress * 100))%")
                        .font(.system(.title, design: .rounded).weight(.bold))
                        .foregroundStyle(.primary)

                    Text("Step \(progress.currentStep)")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                }
            }

            // Current step description
            Text(progress.currentStep)
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}

struct InitialGenerationView: View {
    @State private var pulseOpacity: Double = 0.6

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "wand.and.stars")
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.orange, .red.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .opacity(pulseOpacity)
                .animation(
                    .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                    value: pulseOpacity
                )

            Text("Ready to Create Your Rakhi")
                .font(.system(.title2, design: .rounded).weight(.bold))
                .foregroundStyle(.primary)

            Text("Tap Start Generation to begin creating your personalized Rakhi with AI")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .onAppear {
            pulseOpacity = 1.0
        }
    }
}

struct QualityMetricsView: View {
    let metrics: QualityMetrics

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Quality Metrics")
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                Spacer()

                Text("Grade: \(metrics.grade)")
                    .font(.system(.subheadline, design: .rounded).weight(.bold))
                    .foregroundStyle(metrics.color)
            }

            VStack(spacing: 8) {
                QualityBar(label: "Cultural Authenticity", value: metrics.culturalAuthenticity)
                QualityBar(label: "Visual Quality", value: metrics.visualQuality)
                QualityBar(label: "Element Coherence", value: metrics.elementCoherence)
            }
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct QualityBar: View {
    let label: String
    let value: Double

    var body: some View {
        HStack(spacing: 12) {
            Text(label)
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(.secondary)
                .frame(width: 100, alignment: .leading)

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 6)

                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: value > 0.8 ? [.green] : value > 0.6 ? [.orange] : [.red],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * CGFloat(value), height: 6)
                        .animation(.spring(response: 0.6), value: value)
                }
            }
            .frame(height: 6)

            Text("\(Int(value * 100))%")
                .font(.system(.caption, design: .rounded).weight(.medium))
                .foregroundStyle(.primary)
                .frame(width: 35, alignment: .trailing)
        }
    }
}

struct CompletedGenerationView: View {
    let rakhi: GeneratedRakhi

    var body: some View {
        VStack(spacing: 20) {
            // Success indicator
            VStack(spacing: 12) {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.green)

                Text("Rakhi Generated Successfully!")
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)
            }

            // Generated image placeholder
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.regularMaterial)
                    .frame(width: 200, height: 200)

                VStack(spacing: 12) {
                    Image(systemName: "photo")
                        .font(.system(size: 40))
                        .foregroundStyle(.secondary)

                    VStack(spacing: 4) {
                        Text("Generated Rakhi")
                            .font(.system(.body, design: .rounded).weight(.medium))
                            .foregroundStyle(.secondary)

                        Text("Quality: \(rakhi.qualityScore, specifier: "%.1f")/1.0")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.green)
                    }
                }
            }

            // Action buttons
            HStack(spacing: 12) {
                Button("Preview Animation") {
                    // Preview action
                }
                .font(.system(.subheadline, design: .rounded).weight(.medium))
                .foregroundStyle(.orange)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(.orange.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))

                Button("Send Rakhi") {
                    // Send action
                }
                .font(.system(.subheadline, design: .rounded).weight(.semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(.orange, in: RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}

struct GenerationControlsView: View {
    let status: GenerationStatus
    let onStart: () -> Void
    let onCancel: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            if status == .idle || status == .failed {
                Button("Start Generation") {
                    onStart()
                }
                .font(.system(.body, design: .rounded).weight(.semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(.orange, in: RoundedRectangle(cornerRadius: 16))

            } else if status == .processing || status == .submitting {
                Button("Cancel") {
                    onCancel()
                }
                .font(.system(.body, design: .rounded).weight(.medium))
                .foregroundStyle(.red)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(.red.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))

            } else if status == .completed {
                HStack(spacing: 12) {
                    Button("Generate Another") {
                        onStart()
                    }
                    .font(.system(.subheadline, design: .rounded).weight(.medium))
                    .foregroundStyle(.orange)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(.orange.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))

                    Button("Continue") {
                        // Continue to next step
                    }
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(.green, in: RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }
}

#Preview {
    RealTimeGenerationView(
        designSpec: RakhiDesignSpec(
            genre: .traditional,
            elements: Array(DesignElementsDatabase.shared.getAllElements().prefix(3)),
            colorPalette: .traditional,
            personalMessage: "With love and blessings",
            targetAgeGroup: .adult
        ),
        advancedPrompt: AdvancedPrompt(
            positive: "traditional Indian rakhi, beautiful design",
            negative: "blurry, low quality",
            loraModels: ["rakhi_traditional_v2"],
            culturalWeight: 0.8,
            qualityEnhancers: ["high resolution"],
            technicalParameters: TechnicalParameters(
                cfg_scale: 7.5,
                steps: 30,
                sampler: "DPMSolverMultistep",
                clip_skip: 2,
                strength: 0.75
            )
        )
    )
    .background(Color(.systemGroupedBackground))
}
