import SwiftUI

struct AdvancedCustomizationView: View {
    let baseRakhi: GeneratedRakhi
    @StateObject private var customizationService = AdvancedCustomizationService.shared
    @State private var customizationSession: CustomizationSession?
    @State private var selectedTab: CustomizationTab = .patterns
    @State private var showingPresets = false
    @State private var showingSavePreset = false
    @State private var presetName = ""
    @State private var presetDescription = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header with Progress
                CustomizationHeaderView(
                    progress: customizationService.customizationProgress,
                    isCustomizing: customizationService.isCustomizing
                )

                // Real-time Preview
                RealTimePreviewSection(
                    previewRakhi: customizationService.previewRakhi ?? baseRakhi,
                    baseRakhi: baseRakhi
                )

                // Customization Tabs
                CustomizationTabBar(selectedTab: $selectedTab)

                // Customization Content
                TabView(selection: $selectedTab) {
                    PatternCustomizationView(session: customizationSession)
                        .tag(CustomizationTab.patterns)

                    TextureCustomizationView(session: customizationSession)
                        .tag(CustomizationTab.textures)

                    MaterialCustomizationView(session: customizationSession)
                        .tag(CustomizationTab.materials)

                    ColorGradingView(session: customizationSession)
                        .tag(CustomizationTab.colors)

                    CulturalEnhancementView(session: customizationSession)
                        .tag(CustomizationTab.cultural)

                    FineTuningView(session: customizationSession)
                        .tag(CustomizationTab.fineTune)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .navigationTitle("Advanced Customization")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        customizationService.endCustomizationSession()
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Load Preset") {
                            showingPresets = true
                        }

                        Button("Save Preset") {
                            showingSavePreset = true
                        }

                        if let session = customizationSession, !session.customizations.isEmpty {
                            Divider()

                            Button("Reset All") {
                                resetAllCustomizations()
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .sheet(isPresented: $showingPresets) {
                CustomizationPresetsView(session: customizationSession)
            }
            .sheet(isPresented: $showingSavePreset) {
                SavePresetView(
                    session: customizationSession,
                    presetName: $presetName,
                    presetDescription: $presetDescription
                )
            }
        }
        .onAppear {
            startCustomizationSession()
        }
    }

    private func startCustomizationSession() {
        customizationSession = customizationService.startCustomizationSession(from: baseRakhi)
    }

    private func resetAllCustomizations() {
        guard let session = customizationSession else { return }
        session.customizations.removeAll()

        Task {
            try? await customizationService.generateRealTimePreview(for: session)
        }
    }
}

// MARK: - Header View

struct CustomizationHeaderView: View {
    let progress: Float
    let isCustomizing: Bool

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Advanced Customization")
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)

                    Text(isCustomizing ? "Applying changes..." : "Ready to customize")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if isCustomizing {
                    ProgressView()
                        .scaleEffect(0.8)
                }
            }

            if isCustomizing {
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .orange))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.regularMaterial)
    }
}

// MARK: - Real-time Preview

struct RealTimePreviewSection: View {
    let previewRakhi: GeneratedRakhi
    let baseRakhi: GeneratedRakhi
    @State private var showingComparison = false

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Live Preview")
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                Spacer()

                Button {
                    showingComparison.toggle()
                } label: {
                    Text(showingComparison ? "Hide Original" : "Compare")
                        .font(.system(.caption, design: .rounded).weight(.medium))
                        .foregroundStyle(.orange)
                }
            }

            GeometryReader { geometry in
                HStack(spacing: showingComparison ? 12 : 0) {
                    // Preview Rakhi
                    RakhiPreviewCard(
                        rakhi: previewRakhi,
                        title: "Enhanced",
                        isComparing: showingComparison
                    )
                    .frame(width: showingComparison ? geometry.size.width * 0.5 - 6 : geometry.size.width)

                    if showingComparison {
                        // Original Rakhi
                        RakhiPreviewCard(
                            rakhi: baseRakhi,
                            title: "Original",
                            isComparing: true
                        )
                        .frame(width: geometry.size.width * 0.5 - 6)
                    }
                }
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: showingComparison)
            }
            .frame(height: 200)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

struct RakhiPreviewCard: View {
    let rakhi: GeneratedRakhi
    let title: String
    let isComparing: Bool

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.regularMaterial)
                    .frame(height: isComparing ? 140 : 160)

                VStack(spacing: 6) {
                    Image(systemName: "gift.circle.fill")
                        .font(.system(size: isComparing ? 40 : 50))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.orange, .red],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    if !isComparing {
                        HStack(spacing: 8) {
                            ScoreIndicator(
                                label: "Cultural",
                                score: rakhi.culturalScore,
                                color: .green
                            )

                            ScoreIndicator(
                                label: "Quality",
                                score: rakhi.qualityScore,
                                color: .blue
                            )
                        }
                    }
                }
            }

            Text(title)
                .font(.system(.caption, design: .rounded).weight(.medium))
                .foregroundStyle(.primary)
        }
    }
}

struct ScoreIndicator: View {
    let label: String
    let score: Double
    let color: Color

    var body: some View {
        VStack(spacing: 2) {
            Text("\(score, specifier: "%.1f")")
                .font(.system(.caption2, design: .rounded).weight(.bold))
                .foregroundStyle(color)

            Text(label)
                .font(.system(.caption2, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 4)
        .background(color.opacity(0.1), in: RoundedRectangle(cornerRadius: 6))
    }
}

// MARK: - Customization Tabs

enum CustomizationTab: String, CaseIterable {
    case patterns = "Patterns"
    case textures = "Textures"
    case materials = "Materials"
    case colors = "Colors"
    case cultural = "Cultural"
    case fineTune = "Fine-tune"

    var icon: String {
        switch self {
        case .patterns: return "circle.grid.cross.fill"
        case .textures: return "textformat.abc"
        case .materials: return "cube.fill"
        case .colors: return "paintpalette.fill"
        case .cultural: return "star.circle.fill"
        case .fineTune: return "slider.horizontal.3"
        }
    }
}

struct CustomizationTabBar: View {
    @Binding var selectedTab: CustomizationTab

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 24) {
                ForEach(CustomizationTab.allCases, id: \.self) { tab in
                    CustomizationTabButton(
                        tab: tab,
                        isSelected: selectedTab == tab
                    ) {
                        withAnimation(.spring(response: 0.3)) {
                            selectedTab = tab
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .background(.regularMaterial)
        .frame(height: 60)
    }
}

struct CustomizationTabButton: View {
    let tab: CustomizationTab
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 6) {
                Image(systemName: tab.icon)
                    .font(.system(.subheadline))
                    .foregroundStyle(isSelected ? .orange : .secondary)

                Text(tab.rawValue)
                    .font(.system(.caption, design: .rounded).weight(.medium))
                    .foregroundStyle(isSelected ? .orange : .secondary)
            }
            .frame(width: 70)
            .padding(.vertical, 8)
            .background(
                isSelected ? .orange.opacity(0.1) : .clear,
                in: RoundedRectangle(cornerRadius: 8)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Pattern Customization

struct PatternCustomizationView: View {
    let session: CustomizationSession?
    @StateObject private var customizationService = AdvancedCustomizationService.shared

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(customizationService.availablePatterns) { pattern in
                    PatternCard(
                        pattern: pattern,
                        session: session
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 100)
        }
    }
}

struct PatternCard: View {
    let pattern: DesignPattern
    let session: CustomizationSession?
    @StateObject private var customizationService = AdvancedCustomizationService.shared
    @State private var intensity: Float = 0.8
    @State private var scale: Float = 1.0
    @State private var isApplying = false

    var body: some View {
        VStack(spacing: 16) {
            // Pattern Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(pattern.name)
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)

                    Text(pattern.category.rawValue)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.orange)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(.orange.opacity(0.1), in: Capsule())
                }

                Spacer()

                VStack(spacing: 4) {
                    Text("Cultural")
                        .font(.system(.caption2, design: .rounded))
                        .foregroundStyle(.secondary)

                    Text("\(pattern.culturalRelevance, specifier: "%.1f")")
                        .font(.system(.caption, design: .rounded).weight(.bold))
                        .foregroundStyle(.green)
                }
            }

            // Pattern Preview
            PatternPreview(pattern: pattern)

            // Controls
            VStack(spacing: 12) {
                SliderControl(
                    label: "Intensity",
                    value: $intensity,
                    range: 0...1,
                    icon: "slider.horizontal.3"
                )

                SliderControl(
                    label: "Scale",
                    value: $scale,
                    range: 0.5...2.0,
                    icon: "arrow.up.left.and.arrow.down.right"
                )
            }

            // Apply Button
            Button {
                applyPattern()
            } label: {
                HStack {
                    if isApplying {
                        ProgressView()
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "plus.circle.fill")
                    }

                    Text(isApplying ? "Applying..." : "Apply Pattern")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(.orange, in: RoundedRectangle(cornerRadius: 10))
                .foregroundStyle(.white)
            }
            .disabled(isApplying || session == nil)
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private func applyPattern() {
        guard let session = session else { return }

        isApplying = true

        Task {
            do {
                _ = try await customizationService.applyCustomPattern(
                    pattern,
                    to: session,
                    intensity: intensity
                )
            } catch {
                print("Failed to apply pattern: \(error)")
            }

            await MainActor.run {
                isApplying = false
            }
        }
    }
}

struct PatternPreview: View {
    let pattern: DesignPattern

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.regularMaterial)
                .frame(height: 100)

            // Pattern visualization based on type
            Group {
                switch pattern.category {
                case .geometric:
                    GeometricPatternPreview()
                case .cultural:
                    CulturalPatternPreview()
                case .spiritual:
                    SpiritualPatternPreview()
                default:
                    DefaultPatternPreview()
                }
            }
            .foregroundStyle(.orange.opacity(0.6))
        }
    }
}

struct GeometricPatternPreview: View {
    var body: some View {
        ZStack {
            ForEach(0..<3) { i in
                Circle()
                    .stroke(lineWidth: 2)
                    .frame(width: CGFloat(30 + i * 20))
                    .rotationEffect(.degrees(Double(i * 15)))
            }
        }
    }
}

struct CulturalPatternPreview: View {
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<5) { i in
                RoundedRectangle(cornerRadius: 4)
                    .frame(width: 6, height: CGFloat(20 + i * 8))
                    .opacity(0.7)
            }
        }
    }
}

struct SpiritualPatternPreview: View {
    var body: some View {
        VStack(spacing: 4) {
            ForEach(0..<3) { _ in
                HStack(spacing: 4) {
                    ForEach(0..<5) { _ in
                        Circle()
                            .frame(width: 8)
                            .opacity(0.7)
                    }
                }
            }
        }
    }
}

struct DefaultPatternPreview: View {
    var body: some View {
        Image(systemName: "paintbrush.pointed.fill")
            .font(.system(size: 40))
    }
}

// MARK: - Texture Customization

struct TextureCustomizationView: View {
    let session: CustomizationSession?
    @StateObject private var customizationService = AdvancedCustomizationService.shared

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(customizationService.availableTextures) { texture in
                    TextureCard(
                        texture: texture,
                        session: session
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 100)
        }
    }
}

struct TextureCard: View {
    let texture: TextureOption
    let session: CustomizationSession?
    @StateObject private var customizationService = AdvancedCustomizationService.shared
    @State private var coverage: Float = 1.0
    @State private var roughness: Float = 0.5
    @State private var isApplying = false

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(texture.name)
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)

                    Text(texture.category.rawValue)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.blue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(.blue.opacity(0.1), in: Capsule())
                }

                Spacer()

                TexturePreview(texture: texture)
            }

            VStack(spacing: 12) {
                SliderControl(
                    label: "Coverage",
                    value: $coverage,
                    range: 0...1,
                    icon: "square.grid.3x3.fill"
                )

                SliderControl(
                    label: "Roughness",
                    value: $roughness,
                    range: 0...1,
                    icon: "waveform"
                )
            }

            Button {
                applyTexture()
            } label: {
                HStack {
                    if isApplying {
                        ProgressView()
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "textformat.abc")
                    }

                    Text(isApplying ? "Applying..." : "Apply Texture")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(.blue, in: RoundedRectangle(cornerRadius: 10))
                .foregroundStyle(.white)
            }
            .disabled(isApplying || session == nil)
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private func applyTexture() {
        guard let session = session else { return }

        isApplying = true

        Task {
            do {
                _ = try await customizationService.applyCustomTexture(
                    texture,
                    to: session,
                    coverage: coverage,
                    roughness: roughness
                )
            } catch {
                print("Failed to apply texture: \(error)")
            }

            await MainActor.run {
                isApplying = false
            }
        }
    }
}

struct TexturePreview: View {
    let texture: TextureOption

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(
                LinearGradient(
                    colors: textureColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 60, height: 60)
            .overlay {
                texturePattern
            }
    }

    private var textureColors: [Color] {
        switch texture.category {
        case .fabric:
            return [.purple.opacity(0.3), .blue.opacity(0.3)]
        case .metallic:
            return [.yellow.opacity(0.6), .orange.opacity(0.4)]
        case .decorative:
            return [.pink.opacity(0.3), .red.opacity(0.3)]
        case .natural:
            return [.green.opacity(0.3), .brown.opacity(0.3)]
        }
    }

    @ViewBuilder
    private var texturePattern: some View {
        switch texture.category {
        case .fabric:
            VStack(spacing: 2) {
                ForEach(0..<8) { _ in
                    Rectangle()
                        .frame(height: 1)
                        .opacity(0.3)
                }
            }
        case .metallic:
            Circle()
                .stroke(lineWidth: 1)
                .opacity(0.5)
        default:
            EmptyView()
        }
    }
}

// MARK: - Supporting Views

struct SliderControl: View {
    let label: String
    @Binding var value: Float
    let range: ClosedRange<Float>
    let icon: String

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(.caption))
                    .foregroundStyle(.secondary)

                Text(label)
                    .font(.system(.caption, design: .rounded).weight(.medium))
                    .foregroundStyle(.primary)

                Spacer()

                Text("\(value, specifier: "%.2f")")
                    .font(.system(.caption, design: .rounded).weight(.bold))
                    .foregroundStyle(.orange)
                    .monospacedDigit()
            }

            Slider(value: $value, in: range)
                .tint(.orange)
        }
    }
}

// MARK: - Placeholder Views

struct MaterialCustomizationView: View {
    let session: CustomizationSession?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Material Customization")
                    .font(.title2)
                Text("Advanced material options coming soon")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
    }
}

struct ColorGradingView: View {
    let session: CustomizationSession?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Color Grading")
                    .font(.title2)
                Text("Color adjustment tools coming soon")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
    }
}

struct CulturalEnhancementView: View {
    let session: CustomizationSession?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Cultural Enhancement")
                    .font(.title2)
                Text("Cultural authenticity tools coming soon")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
    }
}

struct FineTuningView: View {
    let session: CustomizationSession?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Fine-tuning")
                    .font(.title2)
                Text("Advanced parameter controls coming soon")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
    }
}

struct CustomizationPresetsView: View {
    let session: CustomizationSession?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                Text("Customization Presets")
                    .font(.title2)
                Text("Preset management coming soon")
                    .foregroundStyle(.secondary)
            }
            .navigationTitle("Presets")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct SavePresetView: View {
    let session: CustomizationSession?
    @Binding var presetName: String
    @Binding var presetDescription: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                TextField("Preset Name", text: $presetName)
                TextField("Description (Optional)", text: $presetDescription, axis: .vertical)
                    .lineLimit(3)
            }
            .navigationTitle("Save Preset")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Save preset logic
                        dismiss()
                    }
                    .disabled(presetName.isEmpty)
                }
            }
        }
    }
}

#Preview {
    AdvancedCustomizationView(
        baseRakhi: GeneratedRakhi(
            id: UUID(),
            designSpec: RakhiDesignSpec(genre: .traditional),
            mainImage: AIImageResult(
                imageURL: "test://image.jpg",
                metadata: GenerationMetadata(
                    seed: 12345,
                    cfg_scale: 7.5,
                    steps: 30,
                    model: "sdxl_base_1.0",
                    timestamp: Date()
                ),
                processingTime: 1.0
            ),
            prompt: AIPrompt(
                positive: "traditional rakhi",
                negative: "blurry",
                cfg_scale: 7.5,
                steps: 30,
                seed: 12345,
                width: 1024,
                height: 1024
            ),
            createdAt: Date(),
            culturalScore: 0.8,
            qualityScore: 0.9
        )
    )
}
