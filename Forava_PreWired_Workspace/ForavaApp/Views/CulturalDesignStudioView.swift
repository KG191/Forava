import SwiftUI
import Combine

// MARK: - Multi-Cultural Design Studio
// Replaces the mock implementation with full cultural framework integration

struct CulturalDesignStudioView: View {
    let selectedContact: RakhiModel.Contact

    @StateObject private var culturalConfig = CulturalConfiguration.shared
    @StateObject private var contextManager = CulturalContextManager.shared
    @StateObject private var terminologyService = DynamicCulturalTerminologyService.shared
    @StateObject private var designService = CulturalDesignAgentService.shared
    @StateObject private var subscriptionManager = SubscriptionManager.shared

    @State private var currentStep = 0
    @State private var designSpec = CulturalDesignSpec(
        culturalContext: "rakhi_indian",
        genre: CulturalGenre(id: "", displayName: "", icon: "", basePrompt: "", culturalContext: "rakhi_indian"),
        colorPalette: CulturalColorPalette(id: "", displayName: "", colors: [], culturalContext: "rakhi_indian"),
        targetAgeGroup: CulturalAgeGroup(id: "", displayName: "", ageRange: "", culturalContext: "rakhi_indian")
    )

    @State private var isGenerating = false
    @State private var generatedGift: CulturalGift?
    @State private var showingPreview = false
    @State private var showingSubscriptionSheet = false

    @Environment(\.dismiss) private var dismiss

    init(selectedContact: RakhiModel.Contact) {
        self.selectedContact = selectedContact
    }

    private let designSteps = [
        "Cultural Context",
        "Design Style",
        "Elements",
        "Colors",
        "Personalization",
        "Preview"
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Progress Header
                progressHeader

                // Step Content
                ScrollView {
                    VStack(spacing: 24) {
                        stepContent
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }

                // Navigation Controls
                navigationControls
            }
            .navigationTitle("Create \(terminologyService.digitalGiftTerm)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(.orange)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    culturalContextSwitcher
                }
            }
            .sheet(isPresented: $showingPreview) {
                if let gift = generatedGift {
                    CulturalGiftPreviewView(gift: gift, recipient: selectedContact)
                }
            }
            .sheet(isPresented: $showingSubscriptionSheet) {
                SubscriptionManagementView()
                    .environmentObject(subscriptionManager)
            }
            .task {
                await initializeCulturalFramework()
            }
        }
    }

    // MARK: - Progress Header

    private var progressHeader: some View {
        VStack(spacing: 12) {
            // Cultural Context Display
            if let context = contextManager.currentContext {
                HStack {
                    Text(context.displayName)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)

                    Spacer()

                    Text("\(currentStep + 1) of \(designSteps.count)")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)
                }
            }

            // Progress Bar
            ProgressView(value: Double(currentStep), total: Double(designSteps.count - 1))
                .progressViewStyle(LinearProgressViewStyle(tint: contextManager.currentContext?.colorPalettes.first?.colors.first?.color ?? .orange))

            // Current Step Title
            Text(designSteps[currentStep])
                .font(.title2.weight(.bold))
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(.regularMaterial, in: Rectangle())
    }

    // MARK: - Cultural Context Switcher

    private var culturalContextSwitcher: some View {
        Menu {
            ForEach(DynamicCulturalTerminologyService.supportedOccasions) { occasion in
                Button {
                    switchCulturalContext(to: occasion)
                } label: {
                    HStack {
                        Text(occasion.symbol)
                        Text(occasion.displayName)
                        if terminologyService.selectedOccasion == occasion.id {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            HStack(spacing: 4) {
                Text(terminologyService.getCurrentOccasion()?.symbol ?? "🎁")
                Image(systemName: "chevron.down")
                    .font(.caption)
            }
            .foregroundStyle(.orange)
        }
    }

    // MARK: - Step Content

    @ViewBuilder
    private var stepContent: some View {
        switch currentStep {
        case 0:
            CulturalContextSelectionStep(
                selectedContext: $designSpec.culturalContext,
                terminologyService: terminologyService
            )

        case 1:
            CulturalGenreSelectionStep(designSpec: $designSpec)

        case 2:
            CulturalElementSelectionStep(designSpec: $designSpec)

        case 3:
            CulturalColorSelectionStep(designSpec: $designSpec)

        case 4:
            CulturalPersonalizationStep(
                designSpec: $designSpec,
                recipient: selectedContact
            )

        case 5:
            CulturalPreviewStep(
                designSpec: designSpec,
                recipient: selectedContact,
                onGenerate: generateCulturalGift
            )

        default:
            EmptyView()
        }
    }

    // MARK: - Navigation Controls

    private var navigationControls: some View {
        HStack(spacing: 16) {
            // Back Button
            if currentStep > 0 {
                Button("Back") {
                    withAnimation(.spring(response: 0.4)) {
                        currentStep -= 1
                    }
                }
                .buttonStyle(.bordered)
                .tint(.secondary)
            }

            Spacer()

            // Next/Generate Button
            Button {
                if currentStep < designSteps.count - 1 {
                    withAnimation(.spring(response: 0.4)) {
                        currentStep += 1
                    }
                } else {
                    generateCulturalGift()
                }
            } label: {
                Group {
                    if isGenerating {
                        HStack(spacing: 8) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                            Text("Creating...")
                        }
                    } else {
                        Text(currentStep == designSteps.count - 1 ? "Create Gift" : "Next")
                    }
                }
                .font(.headline.weight(.semibold))
                .foregroundStyle(.white)
                .frame(minWidth: 120)
            }
            .buttonStyle(.borderedProminent)
            .tint(contextManager.currentContext?.colorPalettes.first?.colors.first?.color ?? .orange)
            .disabled(isGenerating || !canProceedToNextStep)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(.regularMaterial, in: Rectangle())
    }

    // MARK: - Step Validation

    private var canProceedToNextStep: Bool {
        switch currentStep {
        case 0: return !designSpec.culturalContext.isEmpty
        case 1: return !designSpec.genre.id.isEmpty
        case 2: return !designSpec.elements.isEmpty
        case 3: return !designSpec.colorPalette.id.isEmpty
        case 4: return true // Personalization is optional
        case 5: return true // Preview step
        default: return false
        }
    }

    // MARK: - Actions

    private func switchCulturalContext(to occasion: CulturalOccasion) {
        terminologyService.updateCulturalSettings(
            occasion: occasion.id,
            context: occasion.culturalContext
        )

        // Update design spec cultural context
        designSpec.culturalContext = occasion.culturalContext

        // Reset design choices when switching contexts
        designSpec.genre = CulturalGenre(id: "", displayName: "", icon: "", basePrompt: "", culturalContext: occasion.culturalContext)
        designSpec.elements = []
        designSpec.colorPalette = CulturalColorPalette(id: "", displayName: "", colors: [], culturalContext: occasion.culturalContext)

        // Go back to style selection
        currentStep = 1
    }

    private func initializeCulturalFramework() async {
        if !culturalConfig.isInitialized {
            await culturalConfig.initialize()
        }

        // Set initial cultural context based on terminology service
        designSpec.culturalContext = terminologyService.culturalContext
    }

    private func generateCulturalGift() {
        guard !isGenerating else { return }

        // Check subscription limits
        if !subscriptionManager.canGenerateMore() {
            showingSubscriptionSheet = true
            return
        }

        isGenerating = true

        Task {
            do {
                let gift = try await designService.generateCulturalGift(
                    designSpec: designSpec,
                    recipient: selectedContact
                )

                DispatchQueue.main.async {
                    self.generatedGift = gift
                    self.isGenerating = false
                    self.showingPreview = true

                    // Track generation for subscription
                    self.subscriptionManager.recordGeneration()
                }
            } catch {
                DispatchQueue.main.async {
                    self.isGenerating = false
                    print("❌ Cultural gift generation failed: \(error)")
                }
            }
        }
    }
}

// MARK: - Cultural Context Selection Step

struct CulturalContextSelectionStep: View {
    @Binding var selectedContext: String
    let terminologyService: DynamicCulturalTerminologyService

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Text("Choose Cultural Tradition")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.primary)

                Text("Select the cultural tradition that best represents your gift")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                ForEach(DynamicCulturalTerminologyService.supportedOccasions) { occasion in
                    CulturalContextCard(
                        occasion: occasion,
                        isSelected: selectedContext == occasion.culturalContext
                    ) {
                        selectedContext = occasion.culturalContext
                        terminologyService.updateCulturalSettings(
                            occasion: occasion.id,
                            context: occasion.culturalContext
                        )
                    }
                }
            }
        }
    }
}

struct CulturalContextCard: View {
    let occasion: CulturalOccasion
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Text(occasion.symbol)
                    .font(.system(size: 40))

                Text(occasion.displayName)
                    .font(.headline.weight(.medium))
                    .foregroundStyle(isSelected ? .white : .primary)
                    .multilineTextAlignment(.center)

                Text("Digital \(occasion.displayName) Gift")
                    .font(.caption)
                    .foregroundStyle(isSelected ? .white.opacity(0.8) : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? occasion.primaryColor : Color(.systemGray6))
            )
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Supporting Types Extension

extension CulturalOccasion {
    var primaryColor: Color {
        switch id {
        case "raksha_bandhan": return .orange
        case "diwali": return Color(red: 1.0, green: 0.42, blue: 0.21) // Festival orange
        case "chinese_new_year": return .red
        case "christmas": return Color(red: 0.77, green: 0.12, blue: 0.23) // Christmas red
        case "eid_al_fitr": return .green
        case "eid_al_adha": return .green
        case "hanukkah": return .blue
        case "vesak_day": return Color(red: 1.0, green: 0.84, blue: 0.0) // Golden
        default: return .orange
        }
    }
}

#Preview {
    NavigationStack {
        CulturalDesignStudioView(selectedContact: RakhiModel.Contact(name: "Sample Contact", phoneNumber: "", relationship: ""))
            .environmentObject(DynamicCulturalTerminologyService.shared)
            .environmentObject(SubscriptionManager.shared)
    }
}
