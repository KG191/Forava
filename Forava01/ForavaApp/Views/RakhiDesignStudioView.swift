import SwiftUI
import Combine

struct RakhiDesignStudioView: View {
    let selectedContact: Contact
    
    @StateObject private var aiService = AIRakhiService.shared
    @State private var currentStep: DesignStep = .genre
    @State private var designSpec = RakhiDesignSpec()
    @State private var showingPreview = false
    @State private var showingGenerationError = false
    @State private var showingGeneratedRakhi = false
    @State private var showingCostWarning = false
    @State private var pendingAction: (() -> Void)?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Progress Header
                DesignProgressHeader(currentStep: currentStep, totalSteps: DesignStep.allCases.count)
                
                // Content
                ScrollView {
                    VStack(spacing: 24) {
                        // Header Info
                        VStack(spacing: 12) {
                            Text("Create a Rakhi")
                                .font(.system(.title2, design: .rounded).weight(.bold))
                                .foregroundStyle(.primary)
                            
                            Text("for \(selectedContact.name)")
                                .font(.system(.body, design: .rounded).weight(.medium))
                                .foregroundStyle(.orange)
                            
                            // Cost Notification
                            HStack(spacing: 8) {
                                Image(systemName: "dollarsign.circle.fill")
                                    .foregroundStyle(.green)
                                
                                Text("Each generation costs $2")
                                    .font(.system(.subheadline, design: .rounded).weight(.medium))
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(.green.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.green.opacity(0.3), lineWidth: 1)
                            }
                        }
                        .padding(.top, 16)
                        
                        // Step Content
                        Group {
                            switch currentStep {
                            case .genre:
                                GenreSelectionStep(designSpec: $designSpec)
                            case .elements:
                                ElementSelectionStep(designSpec: $designSpec)
                            case .colors:
                                ColorSelectionStep(designSpec: $designSpec)
                            case .personalization:
                                PersonalizationStep(designSpec: $designSpec, recipient: selectedContact)
                            case .preview:
                                PreviewStep(designSpec: designSpec, aiService: aiService)
                            }
                        }
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: currentStep)
                    }
                    .padding(.horizontal, 24)
                }
                
                // Bottom Navigation
                DesignNavigationFooter(
                    currentStep: $currentStep,
                    designSpec: designSpec,
                    onGenerate: generateRakhi,
                    isGenerating: aiService.isGenerating,
                    onStepChange: checkForCostWarning
                )
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(.orange)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if aiService.isGenerating {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .orange))
                            .scaleEffect(0.8)
                    }
                }
            })
        }
        .alert("Generation Error", isPresented: $showingGenerationError) {
            Button("OK") { }
        } message: {
            Text(aiService.error?.localizedDescription ?? "An unknown error occurred while generating your Rakhi.")
        }
        .onReceive(aiService.$error) { newError in
            showingGenerationError = newError != nil
        }
        .onReceive(aiService.$generatedRakhi) { newRakhi in
            if newRakhi != nil {
                showingGeneratedRakhi = true
            }
        }
        .fullScreenCover(isPresented: $showingGeneratedRakhi) {
            if aiService.generatedRakhi != nil {
                // TODO: Add GeneratedRakhiView when included in project
                Text("Generated Rakhi Result")
                    .navigationTitle("Result")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") {
                                showingGeneratedRakhi = false
                            }
                        }
                    }
            }
        }
        .alert("Generation Cost", isPresented: $showingCostWarning) {
            Button("Cancel", role: .cancel) {
                pendingAction = nil
            }
            Button("Continue ($2)") {
                pendingAction?()
                pendingAction = nil
            }
        } message: {
            Text("Generating a new Rakhi or making changes after generation will cost $2. Do you want to continue?")
        }
    }
    
    private func generateRakhi() {
        Task {
            do {
                let generatedRakhi = try await aiService.generateRakhi(from: designSpec)
                print("Successfully generated Rakhi: \(generatedRakhi.id)")
            } catch {
                print("Failed to generate Rakhi: \(error.localizedDescription)")
            }
        }
    }
    
    private func checkForCostWarning(_ action: @escaping () -> Void) {
        // If user has already generated a Rakhi and is making changes, warn about cost
        if aiService.generatedRakhi != nil {
            pendingAction = action
            showingCostWarning = true
        } else {
            action()
        }
    }
}

// MARK: - Design Steps Enum
enum DesignStep: Int, CaseIterable {
    case genre = 0
    case elements = 1
    case colors = 2
    case personalization = 3
    case preview = 4
    
    var title: String {
        switch self {
        case .genre: return "Style"
        case .elements: return "Elements"
        case .colors: return "Colors"
        case .personalization: return "Personal"
        case .preview: return "Preview"
        }
    }
    
    var description: String {
        switch self {
        case .genre: return "Choose the overall style and feel"
        case .elements: return "Select decorative elements"
        case .colors: return "Pick your color palette"
        case .personalization: return "Add personal touches"
        case .preview: return "Review and generate"
        }
    }
    
    var icon: String {
        switch self {
        case .genre: return "star.circle.fill"
        case .elements: return "circle.grid.2x2.fill"
        case .colors: return "paintpalette.fill"
        case .personalization: return "heart.fill"
        case .preview: return "eye.fill"
        }
    }
    
    func next() -> DesignStep? {
        let nextRawValue = rawValue + 1
        return DesignStep(rawValue: nextRawValue)
    }
    
    func previous() -> DesignStep? {
        let prevRawValue = rawValue - 1
        return DesignStep(rawValue: prevRawValue)
    }
}

// MARK: - Progress Header
struct DesignProgressHeader: View {
    let currentStep: DesignStep
    let totalSteps: Int
    
    var progress: Float {
        Float(currentStep.rawValue + 1) / Float(totalSteps)
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(currentStep.title)
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)
                    
                    Text(currentStep.description)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Image(systemName: currentStep.icon)
                        .font(.system(.title2))
                        .foregroundStyle(.orange)
                    
                    Text("\(currentStep.rawValue + 1) of \(totalSteps)")
                        .font(.system(.caption, design: .rounded).weight(.medium))
                        .foregroundStyle(.secondary)
                }
            }
            
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: .orange))
                .scaleEffect(y: 1.5)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(.regularMaterial)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color(.systemGray4))
                .frame(height: 1)
        }
    }
}

// MARK: - Navigation Footer
struct DesignNavigationFooter: View {
    @Binding var currentStep: DesignStep
    let designSpec: RakhiDesignSpec
    let onGenerate: () -> Void
    let isGenerating: Bool
    let onStepChange: (@escaping () -> Void) -> Void
    
    var canProceed: Bool {
        switch currentStep {
        case .genre:
            return designSpec.genre != .unknown
        case .elements:
            return !designSpec.elements.isEmpty
        case .colors:
            return true // Color palette always has a default
        case .personalization:
            return true // Optional step
        case .preview:
            return !isGenerating
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Back Button
            if currentStep != .genre {
                Button {
                    onStepChange {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            if let prevStep = currentStep.previous() {
                                currentStep = prevStep
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(.system(.body, design: .rounded).weight(.medium))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                }
                .buttonStyle(ForavaSecondaryButtonStyle())
            }
            
            // Next/Generate Button
            Button {
                if currentStep == .preview {
                    onGenerate()
                } else {
                    onStepChange {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            if let nextStep = currentStep.next() {
                                currentStep = nextStep
                            }
                        }
                    }
                }
            } label: {
                HStack(spacing: 8) {
                    if isGenerating {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                        Text("Generating...")
                    } else {
                        Text(currentStep == .preview ? "Generate Rakhi" : "Next")
                        if currentStep != .preview {
                            Image(systemName: "chevron.right")
                        }
                    }
                }
                .font(.system(.body, design: .rounded).weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
            }
            .buttonStyle(ForavaPrimaryButtonStyle())
            .disabled(!canProceed || isGenerating)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 32)
        .padding(.top, 16)
        .background(
            LinearGradient(
                colors: [.clear, Color(.systemBackground).opacity(0.9)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

// MARK: - Button Styles
struct ForavaPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.white)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(configuration.isPressed ? Color.orange.opacity(0.8) : Color.orange)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .shadow(color: .orange.opacity(0.3), radius: 8, y: 4)
            .animation(.spring(response: 0.3), value: configuration.isPressed)
    }
}

struct ForavaSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.orange)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.regularMaterial)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.orange, lineWidth: 1)
            }
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3), value: configuration.isPressed)
    }
}

#Preview {
    RakhiDesignStudioView(selectedContact: Contact(name: "Sample Contact", phoneNumber: "", relationship: ""))
}