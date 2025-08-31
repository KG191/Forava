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
            if let generatedRakhi = aiService.generatedRakhi {
                TemporaryGeneratedRakhiView(
                    generatedRakhi: generatedRakhi,
                    recipient: selectedContact,
                    onDismiss: { showingGeneratedRakhi = false }
                )
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

// Button styles are defined in SharedUIComponents.swift

// MARK: - Temporary Generated Rakhi View
struct TemporaryGeneratedRakhiView: View {
    let generatedRakhi: GeneratedRakhi
    let recipient: Contact
    let onDismiss: () -> Void
    @State private var showingSendOptions = false
    @State private var showingShareSheet = false
    @State private var shareItems: [Any] = []

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Success Header
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 64))
                            .foregroundStyle(.green)

                        VStack(spacing: 8) {
                            Text("Your Rakhi is Ready!")
                                .font(.system(.title, design: .rounded).weight(.bold))
                                .foregroundStyle(.primary)

                            Text("Created for \(recipient.name)")
                                .font(.system(.title3, design: .rounded).weight(.medium))
                                .foregroundStyle(.orange)
                        }
                    }
                    .padding(.top, 32)

                    // Generated Image Display
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.regularMaterial)
                            .frame(height: 280)

                        if let imageData = generatedRakhi.mainImage.imageData {
                            if let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: 280)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
                            } else {
                                VStack(spacing: 12) {
                                    Image(systemName: "exclamationmark.triangle")
                                        .font(.system(size: 48))
                                        .foregroundStyle(.orange)
                                    Text("Image format error")
                                        .font(.system(.body, design: .rounded))
                                        .foregroundStyle(.secondary)
                                }
                            }
                        } else {
                            VStack(spacing: 12) {
                                Image(systemName: "photo")
                                    .font(.system(size: 48))
                                    .foregroundStyle(.secondary)
                                Text("Generated Rakhi Image")
                                    .font(.system(.body, design: .rounded))
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 24))

                    // Quality Scores
                    HStack(spacing: 20) {
                        VStack(spacing: 8) {
                            Image(systemName: "star.fill")
                                .font(.system(.title2))
                                .foregroundStyle(.blue)
                            VStack(spacing: 4) {
                                Text("\(Int(generatedRakhi.qualityScore * 100))%")
                                    .font(.system(.title3, design: .rounded).weight(.bold))
                                    .foregroundStyle(.blue)
                                Text("Quality Score")
                                    .font(.system(.caption, design: .rounded).weight(.medium))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(.blue.opacity(0.05), in: RoundedRectangle(cornerRadius: 16))

                        VStack(spacing: 8) {
                            Image(systemName: "leaf.fill")
                                .font(.system(.title2))
                                .foregroundStyle(.green)
                            VStack(spacing: 4) {
                                Text("\(Int(generatedRakhi.culturalScore * 100))%")
                                    .font(.system(.title3, design: .rounded).weight(.bold))
                                    .foregroundStyle(.green)
                                Text("Cultural Score")
                                    .font(.system(.caption, design: .rounded).weight(.medium))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(.green.opacity(0.05), in: RoundedRectangle(cornerRadius: 16))
                    }

                    // Apple Watch Setup Notice
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: "applewatch")
                                .foregroundStyle(.blue)
                            Text("Apple Watch Ready")
                                .font(.system(.headline, design: .rounded).weight(.semibold))
                                .foregroundStyle(.primary)
                            Spacer()
                        }

                        Text("This Rakhi is optimized as a functional clock face for Apple Watch with the image as background.")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(.blue.opacity(0.05), in: RoundedRectangle(cornerRadius: 16))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.blue.opacity(0.3), lineWidth: 1)
                    }

                    // Send Rakhi Button (NO Regenerate button as requested)
                    VStack(spacing: 16) {
                        Button {
                            showingSendOptions = true
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "paperplane.fill")
                                Text("Send Rakhi to \(recipient.name)")
                            }
                            .font(.system(.title3, design: .rounded).weight(.semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(.orange)
                            )
                            .shadow(color: .orange.opacity(0.3), radius: 12, y: 6)
                        }

                        Text("Free to send • Your Rakhi will be delivered instantly")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Rakhi Created")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        onDismiss()
                    }
                    .foregroundStyle(.orange)
                }
            }
        }
        .alert("Send Options", isPresented: $showingSendOptions) {
            Button("Messages") {
                sendViaMessages()
            }
            Button("WhatsApp") {
                sendViaWhatsApp()
            }
            Button("Email") {
                sendViaEmail()
            }
            Button("Save to Photos") {
                saveToPhotos()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Choose how to send your Rakhi to \(recipient.name)")
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(activityItems: shareItems)
        }
    }

    private func sendViaMessages() {
        guard let image = getRakhiImage() else {
            print("❌ No image data available for sharing")
            return
        }

        let message = "Here's a beautiful Rakhi I created for you! Happy Raksha Bandhan! 🎊"
        shareItems = [message, image]
        showingSendOptions = false
        showingShareSheet = true
    }

    private func sendViaWhatsApp() {
        guard let image = getRakhiImage() else {
            print("❌ No image data available for sharing")
            return
        }

        let message = "🎊 Happy Raksha Bandhan! I've created this special Rakhi for you with love ❤️"
        shareItems = [message, image]
        showingSendOptions = false
        showingShareSheet = true
    }

    private func sendViaEmail() {
        guard let image = getRakhiImage() else {
            print("❌ No image data available for sharing")
            return
        }

        let subject = "Your Special Rakhi - Happy Raksha Bandhan!"
        let message = """
        Dear \(recipient.name),

        I've created this beautiful Rakhi especially for you using the Forava app!

        Wishing you happiness, prosperity, and the blessings of this sacred festival.

        Happy Raksha Bandhan! 🎊

        With love,
        [Your Name]
        """

        shareItems = [EmailContent(subject: subject, body: message, image: image), image]
        showingSendOptions = false
        showingShareSheet = true
    }

    private func saveToPhotos() {
        guard let image = getRakhiImage() else {
            print("❌ No image data available for saving")
            return
        }

        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        print("✅ Rakhi saved to Photos!")
        showingSendOptions = false
    }
    
    private func getRakhiImage() -> UIImage? {
        guard let imageData = generatedRakhi.mainImage.imageData,
              let image = UIImage(data: imageData) else {
            return nil
        }
        return image
    }

}

// MARK: - SwiftUI ShareSheet Wrapper
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Email Content Helper
class EmailContent: NSObject, UIActivityItemSource {
    let subject: String
    let body: String
    let image: UIImage

    init(subject: String, body: String, image: UIImage) {
        self.subject = subject
        self.body = body
        self.image = image
        super.init()
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return body
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return body
    }

    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return subject
    }
}

#Preview {
    RakhiDesignStudioView(selectedContact: Contact(name: "Sample Contact", phoneNumber: "", relationship: ""))
}
