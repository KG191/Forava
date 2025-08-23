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
    @State private var hasGeneratedInCurrentSession = false
    @State private var currentSessionContact: String = ""
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) private var presentationMode
    
    // Only show generated Rakhi if it was generated in this session for this contact
    private var shouldShowGeneratedRakhi: Bool {
        return aiService.generatedRakhi != nil && hasGeneratedInCurrentSession && currentSessionContact == selectedContact.name
    }
    
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
                        presentationMode.wrappedValue.dismiss()
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
            if newRakhi != nil && currentSessionContact == selectedContact.name {
                hasGeneratedInCurrentSession = true
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
        .onAppear {
            // Reset session state without clearing published properties that could cause UI flicker
            hasGeneratedInCurrentSession = false
            currentSessionContact = selectedContact.name
            showingGeneratedRakhi = false // Ensure we don't show old results
            print("🎯 Starting new design session for contact: \(selectedContact.name)")
        }
    }
    
    private func generateRakhi() {
        // Check if this is a subsequent generation and warn about cost
        checkForCostWarning {
            performGeneration()
        }
    }
    
    private func performGeneration() {
        Task {
            do {
                // Clear any previous results at the start of generation
                if aiService.generatedRakhi != nil && !hasGeneratedInCurrentSession {
                    aiService.clearGeneratedRakhi()
                    print("[DEBUG] Cleared previous generated Rakhi before new generation")
                }
                
                let generatedRakhi = try await aiService.generateRakhi(from: designSpec)
                print("[SUCCESS] Successfully generated Rakhi: \(generatedRakhi.id)")
            } catch {
                print("[ERROR] Failed to generate Rakhi: \(error.localizedDescription)")
            }
        }
    }
    
    private func checkForCostWarning(_ action: @escaping () -> Void) {
        // Only warn about cost if user has already generated a Rakhi in the current session
        if hasGeneratedInCurrentSession {
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
        .background(Color(.systemGray6))
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
                    .fill(Color(.systemGray6))
            )
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.orange, lineWidth: 1)
            }
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3), value: configuration.isPressed)
    }
}

// MARK: - Temporary Generated Rakhi View
struct TemporaryGeneratedRakhiView: View {
    let generatedRakhi: GeneratedRakhi
    let recipient: Contact
    let onDismiss: () -> Void
    @State private var showingSendOptions = false
    
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
                            .fill(Color(.systemGray6))
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
                    .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 24))
                    
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
                    
                    // Gift Amount Suggestion Box
                    GiftAmountSuggestionBox(generatedRakhi: generatedRakhi, recipient: recipient)
                    
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
            Button("Send to Apple Watch") { 
                sendToAppleWatch()
            }
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
    }
    
    // MARK: - Send Options Implementation
    private func sendToAppleWatch() {
        print("[INFO] Sending Rakhi via Messages for Watch setup to \(recipient.name)")
        
        guard let imageData = generatedRakhi.mainImage.imageData,
              let uiImage = UIImage(data: imageData) else {
            print("[ERROR] No image data available")
            return
        }
        
        // Create a payment request URL that the recipient can use
        let paymentRequestURL = createPaymentRequestURL()
        
        // Calculate amount for message
        let baseAmount: Decimal = 51.0
        let complexityMultiplier = 1.0 + (Decimal(generatedRakhi.designSpec.elements.count) * 0.1)
        let culturalMultiplier = Decimal(generatedRakhi.culturalScore)
        let suggested = baseAmount * complexityMultiplier * culturalMultiplier
        let rounded = (suggested / 10).rounded() * 10 + 1
        let suggestedAmount = min(max(rounded, 21), 501)
        
        // Delay to allow alert to dismiss first
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let rakhiMessage = AppConfig.createRakhiMessage(
                amount: suggestedAmount,
                desc: "Rakhi Blessing Gift",
                rakhiId: generatedRakhi.id.uuidString,
                sender: "Forava Creator"
            )
            
            let paymentActivity = PaymentRequestActivity(url: paymentRequestURL, recipientName: self.recipient.name, amount: 101) // Default suggested amount
            
            let activityVC = UIActivityViewController(
                activityItems: [
                    rakhiMessage,
                    uiImage
                ],
                applicationActivities: [paymentActivity]
            )
            
            // Filter to primarily show Messages
            activityVC.excludedActivityTypes = [
                .assignToContact,
                .postToFacebook,
                .postToTwitter
            ]
            
            // Set completion handler
            activityVC.completionWithItemsHandler = { _, _, _, _ in
                DispatchQueue.main.async {
                    self.onDismiss()
                }
            }
            
            // Find the topmost presented view controller
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                var topVC = window.rootViewController
                while let presentedVC = topVC?.presentedViewController {
                    topVC = presentedVC
                }
                topVC?.present(activityVC, animated: true)
            }
        }
    }
    
    private func createPaymentRequestURL() -> URL {
        // Calculate suggested amount based on rakhi complexity
        let baseAmount: Decimal = 51.0
        let complexityMultiplier = 1.0 + (Decimal(generatedRakhi.designSpec.elements.count) * 0.1)
        let culturalMultiplier = Decimal(generatedRakhi.culturalScore)
        let suggested = baseAmount * complexityMultiplier * culturalMultiplier
        let rounded = (suggested / 10).rounded() * 10 + 1
        let suggestedAmount = min(max(rounded, 21), 501)
        
        // Use AppConfig to create Universal Link
        return AppConfig.universalPayURL(
            amount: suggestedAmount,
            desc: "Rakhi Blessing Gift",
            rakhiId: generatedRakhi.id.uuidString,
            sender: "Forava Creator"
        ) ?? URL(string: "https://\(AppConfig.associatedDomain)")!
    }
    
    private func sendViaMessages() {
        print("[INFO] Sending Rakhi via Messages to \(recipient.name)")
        
        guard let imageData = generatedRakhi.mainImage.imageData,
              let uiImage = UIImage(data: imageData) else {
            print("[ERROR] No image data available for Messages")
            return
        }
        
        // Delay to allow alert to dismiss first
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let activityVC = UIActivityViewController(
                activityItems: [
                    "🎊 I've created a beautiful Rakhi for you! Made with love using Forava ❤️",
                    uiImage  // Use UIImage directly instead of file URL to avoid file system issues
                ],
                applicationActivities: nil
            )
            
            // Set completion handler to call onDismiss when done
            activityVC.completionWithItemsHandler = { _, _, _, _ in
                DispatchQueue.main.async {
                    onDismiss()
                }
            }
            
            // Find the topmost presented view controller
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                var topVC = window.rootViewController
                while let presentedVC = topVC?.presentedViewController {
                    topVC = presentedVC
                }
                topVC?.present(activityVC, animated: true)
            }
        }
    }
    
    private func sendViaWhatsApp() {
        print("[INFO] Sending Rakhi via WhatsApp to \(recipient.name)")
        
        guard let imageData = generatedRakhi.mainImage.imageData,
              let uiImage = UIImage(data: imageData) else {
            print("[ERROR] No image data available for WhatsApp")
            return
        }
        
        // Save to Photos first for WhatsApp sharing
        UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
        
        // Create WhatsApp URL scheme
        let message = "🎊 I've created a beautiful Rakhi for you! Made with love using Forava ❤️"
        let encodedMessage = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        if let whatsappURL = URL(string: "whatsapp://send?text=\(encodedMessage)") {
            if UIApplication.shared.canOpenURL(whatsappURL) {
                UIApplication.shared.open(whatsappURL)
            } else {
                // WhatsApp not installed, fall back to regular sharing
                shareViaGenericActivity()
            }
        }
        
        onDismiss()
    }
    
    private func sendViaEmail() {
        print("[INFO] Sending Rakhi via Email to \(recipient.name)")
        
        guard let imageData = generatedRakhi.mainImage.imageData,
              let uiImage = UIImage(data: imageData) else {
            print("[ERROR] No image data available for Email")
            return
        }
        
        let tempURL = saveTempImage(uiImage, filename: "rakhi_for_\(recipient.name)")
        
        if let url = tempURL {
            // Delay to allow alert to dismiss first
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let activityVC = UIActivityViewController(
                    activityItems: [
                        EmailContent(
                            subject: "🎊 A Special Rakhi Just for You!",
                            body: """
                            Dear \(recipient.name),
                            
                            I've created a beautiful, personalized Rakhi just for you using Forava! 
                            
                            🎨 This Rakhi was designed with love and care, incorporating traditional elements and colors that represent our special bond.
                            
                            📱 To view it on your Apple Watch:
                            1. Save the attached image to your Photos
                            2. Open the Photos app on your Apple Watch
                            3. Set it as your watch face background
                            4. Enjoy your personalized Rakhi clock face!
                            
                            May this Rakhi bring you happiness, protection, and good fortune.
                            
                            With love and blessings,
                            Your loving sister ❤️
                            
                            Created with Forava - AI-Powered Rakhi Designer
                            """,
                            imageURL: url
                        )
                    ],
                    applicationActivities: nil
                )
                
                // Set completion handler to call onDismiss when done
                activityVC.completionWithItemsHandler = { _, _, _, _ in
                    DispatchQueue.main.async {
                        onDismiss()
                    }
                }
                
                // Find the topmost presented view controller
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    var topVC = window.rootViewController
                    while let presentedVC = topVC?.presentedViewController {
                        topVC = presentedVC
                    }
                    topVC?.present(activityVC, animated: true)
                }
            }
        } else {
            onDismiss()
        }
    }
    
    private func saveToPhotos() {
        print("[INFO] Saving Rakhi to Photos for \(recipient.name)")
        
        guard let imageData = generatedRakhi.mainImage.imageData,
              let uiImage = UIImage(data: imageData) else {
            print("[ERROR] No image data available for Photos")
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
        
        // Show success feedback
        let alert = UIAlertController(
            title: "Saved!",
            message: "Your Rakhi has been saved to Photos. \(recipient.name) can now set it as their Apple Watch face.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.present(alert, animated: true)
        }
        
        onDismiss()
    }
    
    // MARK: - Helper Methods
    
    private func saveTempImage(_ image: UIImage, filename: String) -> URL? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        
        // Clean the filename to be filesystem-friendly
        let cleanFilename = filename
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: "[^a-zA-Z0-9_-]", with: "", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        let tempDir = FileManager.default.temporaryDirectory
        let tempURL = tempDir.appendingPathComponent("\(cleanFilename).jpg")
        
        do {
            try data.write(to: tempURL)
            print("[DEBUG] Successfully saved temp image to: \(tempURL.path)")
            return tempURL
        } catch {
            print("[ERROR] Failed to save temp image: \(error)")
            return nil
        }
    }
    
    private func shareViaGenericActivity() {
        guard let imageData = generatedRakhi.mainImage.imageData,
              let uiImage = UIImage(data: imageData) else { return }
        
        // Delay to allow alert to dismiss first
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let activityVC = UIActivityViewController(
                activityItems: [
                    "🎊 I've created a beautiful Rakhi for you! Made with love using Forava ❤️",
                    uiImage
                ],
                applicationActivities: nil
            )
            
            // Find the topmost presented view controller
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                var topVC = window.rootViewController
                while let presentedVC = topVC?.presentedViewController {
                    topVC = presentedVC
                }
                topVC?.present(activityVC, animated: true)
            }
        }
    }
}

// MARK: - Payment Request Activity
class PaymentRequestActivity: UIActivity {
    let paymentURL: URL
    let recipientName: String
    let amount: Double
    
    init(url: URL, recipientName: String, amount: Double) {
        self.paymentURL = url
        self.recipientName = recipientName
        self.amount = amount
        super.init()
    }
    
    override var activityType: UIActivity.ActivityType? {
        return UIActivity.ActivityType("com.forava.payment.request")
    }
    
    override var activityTitle: String? {
        return "Send Gift Request"
    }
    
    override var activityImage: UIImage? {
        return UIImage(systemName: "dollarsign.circle.fill")
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return true
    }
    
    override func perform() {
        // Open the payment URL
        if UIApplication.shared.canOpenURL(paymentURL) {
            UIApplication.shared.open(paymentURL)
        }
        activityDidFinish(true)
    }
}

// MARK: - Email Content Helper
class EmailContent: NSObject, UIActivityItemSource {
    let subject: String
    let body: String
    let imageURL: URL
    
    init(subject: String, body: String, imageURL: URL) {
        self.subject = subject
        self.body = body
        self.imageURL = imageURL
        super.init()
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return subject
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        if activityType == .mail {
            return body
        }
        return subject
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return subject
    }
}

// MARK: - Gift Amount Suggestion Box
struct GiftAmountSuggestionBox: View {
    let generatedRakhi: GeneratedRakhi
    let recipient: Contact
    @State private var showingGiftAmount = false
    @State private var selectedGiftAmount: Double?
    
    private var suggestedAmount: Double {
        // AI-suggested amount based on design complexity and cultural context
        let baseAmount = 51.0 // Traditional starting amount
        let complexityMultiplier = 1.0 + (Double(generatedRakhi.designSpec.elements.count) * 0.1)
        let culturalMultiplier = generatedRakhi.culturalScore
        
        let suggested = baseAmount * complexityMultiplier * culturalMultiplier
        
        // Round to culturally appropriate amounts (ending in 1)
        let rounded = round(suggested / 10) * 10 + 1
        return min(max(rounded, 21), 501) // Keep within reasonable bounds
    }
    
    private var displayAmount: Double {
        return selectedGiftAmount ?? suggestedAmount
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "indianrupeesign.circle.fill")
                    .foregroundStyle(.green)
                
                Text("Gift Amount Suggestion")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                HStack {
                    Text(selectedGiftAmount != nil ? "Selected Amount:" : "Suggested Amount:")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("$\(Int(displayAmount))")
                        .font(.system(.title3, design: .rounded).weight(.bold))
                        .foregroundStyle(.green)
                }
                
                Text("Based on design complexity and cultural significance")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                
                Button("Configure Payment Options") {
                    showingGiftAmount = true
                }
                .font(.system(.subheadline, design: .rounded).weight(.medium))
                .foregroundStyle(.green)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(.green.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(.green.opacity(0.05), in: RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.green.opacity(0.3), lineWidth: 1)
        }
        .sheet(isPresented: $showingGiftAmount) {
            GiftAmountConfigurationView(
                recipientName: recipient.name,
                recipientRelationship: recipient.relationship,
                rakhi: generatedRakhi,
                onAmountSelected: { amount in
                    selectedGiftAmount = Double(truncating: amount as NSDecimalNumber)
                    print("[INFO] Selected gift amount: $\(amount)")
                }
            )
        }
    }
}

// MARK: - Simplified Gift Amount Configuration View
struct GiftAmountConfigurationView: View {
    let recipientName: String
    let recipientRelationship: String
    let rakhi: GeneratedRakhi
    let onAmountSelected: (Decimal) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var selectedAmount: Decimal = 101
    @State private var customAmount: String = ""
    @State private var showingCustomInput = false
    
    private var suggestedAmounts: [Decimal] {
        let baseAmount = 51.0
        let complexityMultiplier = 1.0 + (Double(rakhi.designSpec.elements.count) * 0.1)
        let culturalMultiplier = rakhi.culturalScore
        
        let suggested = baseAmount * complexityMultiplier * culturalMultiplier
        let rounded = round(suggested / 10) * 10 + 1
        let baseValue = min(max(rounded, 21), 501)
        
        return [
            Decimal(21),   // Traditional minimum
            Decimal(51),   // Classic amount
            Decimal(101),  // Popular choice
            Decimal(baseValue), // AI suggested
            Decimal(251),  // Premium amount
            Decimal(501)   // Maximum suggested
        ].uniqued().sorted()
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 16) {
                        Image(systemName: "gift.circle.fill")
                            .font(.system(size: 64))
                            .foregroundStyle(.green)
                        
                        VStack(spacing: 8) {
                            Text("Gift Amount")
                                .font(.system(.title, design: .rounded).weight(.bold))
                                .foregroundStyle(.primary)
                            
                            Text("for \(recipientName)")
                                .font(.system(.title3, design: .rounded).weight(.medium))
                                .foregroundStyle(.orange)
                        }
                    }
                    .padding(.top, 32)
                    
                    // Suggested Amounts
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "star.circle.fill")
                                .foregroundStyle(.orange)
                            Text("Suggested Amounts")
                                .font(.system(.headline, design: .rounded).weight(.semibold))
                                .foregroundStyle(.primary)
                            Spacer()
                        }
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                            ForEach(suggestedAmounts, id: \.self) { amount in
                                AmountCard(
                                    amount: amount,
                                    isSelected: selectedAmount == amount,
                                    onSelect: { selectedAmount = amount }
                                )
                            }
                        }
                    }
                    
                    // Custom Amount
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "pencil.circle.fill")
                                .foregroundStyle(.blue)
                            Text("Custom Amount")
                                .font(.system(.headline, design: .rounded).weight(.semibold))
                                .foregroundStyle(.primary)
                            Spacer()
                        }
                        
                        if showingCustomInput {
                            HStack {
                                Text("$")
                                    .font(.title2.weight(.medium))
                                    .foregroundStyle(.secondary)
                                
                                TextField("Enter amount", text: $customAmount)
                                    .font(.title2.weight(.medium))
                                    .keyboardType(.decimalPad)
                                    .onChange(of: customAmount) { _, newValue in
                                        if let amount = Decimal(string: newValue), amount > 0 {
                                            selectedAmount = amount
                                        }
                                    }
                                
                                Button("Done") {
                                    showingCustomInput = false
                                    hideKeyboard()
                                }
                                .font(.caption.weight(.medium))
                                .foregroundStyle(.blue)
                            }
                            .padding(16)
                            .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 12))
                        } else {
                            Button {
                                showingCustomInput = true
                            } label: {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundStyle(.blue)
                                    
                                    Text("Enter Custom Amount")
                                        .font(.subheadline.weight(.medium))
                                        .foregroundStyle(.blue)
                                    
                                    Spacer()
                                }
                                .padding(16)
                                .background(.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Gift Amount")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(.secondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Continue") {
                        onAmountSelected(selectedAmount)
                        dismiss()
                    }
                    .font(.system(.body, design: .rounded).weight(.semibold))
                    .foregroundStyle(.green)
                    .disabled(selectedAmount <= 0)
                }
            }
        }
        .onAppear {
            selectedAmount = suggestedAmounts.contains(101) ? 101 : suggestedAmounts.first ?? 51
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct AmountCard: View {
    let amount: Decimal
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 8) {
                Text("$\(amount as NSDecimalNumber)")
                    .font(.system(.title3, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)
                
                if isAuspiciousAmount(amount) {
                    Text("Auspicious")
                        .font(.system(.caption2, design: .rounded).weight(.medium))
                        .foregroundStyle(.green)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.green.opacity(0.15), in: Capsule())
                }
            }
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? .green.opacity(0.1) : Color(.systemGray6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? .green : .clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
    
    private func isAuspiciousAmount(_ amount: Decimal) -> Bool {
        let intValue = Int(truncating: amount as NSDecimalNumber)
        return intValue % 10 == 1 || [21, 51, 101, 251, 501].contains(intValue)
    }
}

extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}

#Preview {
    RakhiDesignStudioView(selectedContact: Contact(name: "Sample Contact", phoneNumber: "", relationship: ""))
}