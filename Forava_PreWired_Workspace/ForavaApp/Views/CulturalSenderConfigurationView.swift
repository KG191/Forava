import SwiftUI

// MARK: - Cultural Sender Configuration View for Phase 3

struct CulturalSenderConfigurationView: View {
    @StateObject private var paymentService = CulturalPaymentPageService.shared
    @StateObject private var culturalConfig = CulturalConfiguration.shared

    @State private var senderName: String = ""
    @State private var recipientName: String = ""
    @State private var selectedOccasion: String = "Raksha Bandhan"
    @State private var customMessage: String = ""
    @State private var showingPreview = false
    @State private var generatedURL: URL?

    // Phase 3: Available occasions from strategy document
    private let availableOccasions = [
        "Raksha Bandhan", "Diwali", "Holi", "Chinese New Year",
        "Mid-Autumn Festival", "Christmas", "Easter", "Eid al-Fitr",
        "Eid al-Adha", "Vesak Day", "Rosh Hashanah", "Hanukkah",
        "Birthday", "Anniversary"
    ]

    let culturalGift: CulturalGeneratedArtwork
    let onConfigurationComplete: (CulturalSharingPackage) -> Void

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection

                    // Sender Configuration
                    senderConfigurationSection

                    // Recipient Configuration
                    recipientConfigurationSection

                    // Occasion Selection
                    occasionSelectionSection

                    // Custom Message
                    customMessageSection

                    // Preview Button
                    previewSection

                    // Generate Button
                    generateButtonSection
                }
                .padding()
            }
            .navigationTitle("Cultural Gift Configuration")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingPreview) {
                if let url = generatedURL {
                    CulturalPaymentPreviewView(
                        paymentURL: url,
                        senderName: senderName,
                        recipientName: recipientName,
                        occasion: selectedOccasion
                    )
                }
            }
        }
    }

    // MARK: - Header Section

    private var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "gift.fill")
                .font(.system(size: 48))
                .foregroundStyle(.accent)

            Text("Configure Cultural Gift")
                .font(.system(.title, design: .rounded).weight(.bold))

            Text("Personalize your cultural greeting with authentic messaging and sender information")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical)
    }

    // MARK: - Sender Configuration Section

    private var senderConfigurationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Sender Information", systemImage: "person.circle.fill")
                .font(.system(.headline, design: .rounded).weight(.semibold))
                .foregroundStyle(.accent)

            VStack(alignment: .leading, spacing: 8) {
                Text("Your Name")
                    .font(.system(.subheadline, design: .rounded).weight(.medium))
                    .foregroundStyle(.primary)

                TextField("Enter your name", text: $senderName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .submitLabel(.next)

                Text("This will replace 'Forava Creator' in the greeting")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Recipient Configuration Section

    private var recipientConfigurationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Recipient Information", systemImage: "person.2.circle.fill")
                .font(.system(.headline, design: .rounded).weight(.semibold))
                .foregroundStyle(.accent)

            VStack(alignment: .leading, spacing: 8) {
                Text("Recipient's Name")
                    .font(.system(.subheadline, design: .rounded).weight(.medium))
                    .foregroundStyle(.primary)

                TextField("Enter recipient's name", text: $recipientName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .submitLabel(.next)

                Text("Personalize the greeting for the recipient")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Occasion Selection Section

    private var occasionSelectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Cultural Occasion", systemImage: "calendar.circle.fill")
                .font(.system(.headline, design: .rounded).weight(.semibold))
                .foregroundStyle(.accent)

            VStack(alignment: .leading, spacing: 8) {
                Text("Select Occasion")
                    .font(.system(.subheadline, design: .rounded).weight(.medium))
                    .foregroundStyle(.primary)

                Picker("Occasion", selection: $selectedOccasion) {
                    ForEach(availableOccasions, id: \.self) { occasion in
                        Text(occasion)
                            .tag(occasion)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(8)

                // Dynamic cultural footer preview
                Text("Footer: \"Made with ❤️ for \(selectedOccasion)\"")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Custom Message Section

    private var customMessageSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Personal Message", systemImage: "text.bubble.fill")
                .font(.system(.headline, design: .rounded).weight(.semibold))
                .foregroundStyle(.accent)

            VStack(alignment: .leading, spacing: 8) {
                Text("Custom Message (Optional)")
                    .font(.system(.subheadline, design: .rounded).weight(.medium))
                    .foregroundStyle(.primary)

                TextEditor(text: $customMessage)
                    .frame(minHeight: 80)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)

                Text("Add a personal touch to your cultural greeting")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Preview Section

    private var previewSection: some View {
        VStack(spacing: 16) {
            Button(action: generatePreview) {
                HStack {
                    if paymentService.isGeneratingPaymentLink {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "eye.fill")
                    }
                    Text("Preview Cultural Greeting")
                        .font(.system(.body, design: .rounded).weight(.medium))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(.accent)
                .cornerRadius(12)
            }
            .disabled(senderName.isEmpty || paymentService.isGeneratingPaymentLink)

            if let url = generatedURL {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Generated URL:")
                        .font(.system(.caption, design: .rounded).weight(.medium))
                        .foregroundStyle(.secondary)

                    Text(url.absoluteString)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundStyle(.primary)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(6)
                        .textSelection(.enabled)
                }
                .padding(.horizontal)
            }
        }
    }

    // MARK: - Generate Button Section

    private var generateButtonSection: some View {
        Button(action: generateCulturalSharingPackage) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                Text("Create Cultural Gift")
                    .font(.system(.body, design: .rounded).weight(.semibold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [.accent, .accent.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
        }
        .disabled(senderName.isEmpty || recipientName.isEmpty)
        .padding(.horizontal)
        .padding(.bottom)
    }

    // MARK: - Actions

    private func generatePreview() {
        Task {
            let url = await paymentService.createSharablePaymentURL(
                culturalGift: culturalGift,
                senderName: senderName.isEmpty ? "A Friend" : senderName,
                recipientName: recipientName.isEmpty ? "You" : recipientName,
                selectedOccasion: selectedOccasion,
                includePreview: true
            )

            await MainActor.run {
                generatedURL = url
                showingPreview = true
            }
        }
    }

    private func generateCulturalSharingPackage() {
        let sharingPackage = paymentService.integrateWithSocialSharing(
            culturalGift: culturalGift,
            senderName: senderName,
            recipientName: recipientName,
            occasion: selectedOccasion
        )

        onConfigurationComplete(sharingPackage)
    }
}

// MARK: - Cultural Payment Preview View

struct CulturalPaymentPreviewView: View {
    let paymentURL: URL
    let senderName: String
    let recipientName: String
    let occasion: String

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Preview Header
                    VStack(spacing: 16) {
                        Image(systemName: "safari.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(.accent)

                        Text("Payment Page Preview")
                            .font(.system(.title, design: .rounded).weight(.bold))

                        Text("This is how your recipient will see the cultural gift")
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }

                    // Mock Payment Page Content
                    VStack(alignment: .leading, spacing: 16) {
                        // Header
                        HStack {
                            Text(getOccasionEmoji(for: occasion))
                                .font(.system(size: 32))

                            VStack(alignment: .leading) {
                                Text("From: \(senderName)")
                                    .font(.system(.headline, design: .rounded))

                                Text("To: \(recipientName)")
                                    .font(.system(.subheadline, design: .rounded))
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()
                        }

                        Divider()

                        // Cultural Greeting
                        Text(CulturalPaymentPageService.shared.getCulturalGreeting(
                            for: occasion,
                            senderName: senderName
                        ))
                        .font(.system(.body, design: .rounded))
                        .lineLimit(nil)

                        // Enhanced Messaging (Phase 3.3)
                        let messaging = CulturalPaymentPageService.shared.generateCulturalMessaging(for: occasion)
                        Text(messaging.greetingMessage)
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(.secondary)
                            .lineLimit(nil)

                        Divider()

                        // Cultural Footer (Phase 3.4)
                        HStack {
                            Spacer()
                            Text(messaging.culturalFooter)
                                .font(.system(.caption, design: .rounded))
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                    }
                    .padding()
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)

                    // URL Display
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Generated URL:")
                            .font(.system(.caption, design: .rounded).weight(.medium))
                            .foregroundStyle(.secondary)

                        Text(paymentURL.absoluteString)
                            .font(.system(.caption, design: .monospaced))
                            .foregroundStyle(.primary)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .textSelection(.enabled)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Preview")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func getOccasionEmoji(for occasion: String) -> String {
        switch occasion.lowercased() {
        case "diwali": return "🪔"
        case "chinese new year": return "🧧"
        case "christmas": return "🎄"
        case "eid al-fitr", "eid al-adha": return "🌙"
        case "vesak day": return "🪷"
        case "rosh hashanah": return "🍎"
        case "hanukkah": return "🕎"
        case "birthday": return "🎂"
        case "anniversary": return "💕"
        case "holi": return "🌈"
        case "mid-autumn festival": return "🥮"
        case "easter": return "🐰"
        default: return "🎊"
        }
    }
}

// MARK: - Preview

#if DEBUG
struct CulturalSenderConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        let mockArtwork = CulturalGeneratedArtwork(
            id: UUID(),
            designSpec: CulturalDesignSpec(
                culturalContext: "hindu_festivals",
                genre: CulturalGenre(
                    id: "diwali",
                    displayName: "Diwali",
                    icon: "flame.fill",
                    basePrompt: "test",
                    culturalContext: "hindu_festivals"
                ),
                colorPalette: CulturalColorPalette(
                    id: "traditional",
                    displayName: "Traditional",
                    colors: [],
                    culturalContext: "hindu_festivals"
                ),
                targetAgeGroup: CulturalAgeGroup(
                    id: "any",
                    displayName: "Any",
                    ageRange: "All",
                    culturalContext: "hindu_festivals"
                )
            ),
            culturalContext: "hindu_festivals",
            mainImage: CulturalImageResult(
                url: "test",
                width: 512,
                height: 512,
                seed: 123,
                qualityScore: 0.9
            ),
            qualityScore: 0.9,
            culturalScore: 0.85,
            generatedAt: Date(),
            metadata: CulturalGenerationMetadata(
                culturalContext: "hindu_festivals",
                model: "test",
                prompt: "test",
                negativePrompt: "test",
                culturalEnhancers: [],
                steps: 30,
                cfgScale: 7.5,
                seed: 123
            )
        )

        CulturalSenderConfigurationView(
            culturalGift: mockArtwork
        ) { _ in
            print("Configuration complete")
        }
    }
}
#endif
