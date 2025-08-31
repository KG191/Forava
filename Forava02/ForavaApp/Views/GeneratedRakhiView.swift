import SwiftUI

struct GeneratedRakhiView: View {
    let generatedRakhi: GeneratedRakhi
    let recipient: Contact
    @Environment(\.dismiss) private var dismiss
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
                    GeneratedImageCard(generatedRakhi: generatedRakhi)

                    // Quality and Cultural Scores
                    ScoreDisplaySection(generatedRakhi: generatedRakhi)

                    // Design Summary
                    DesignSummaryCard(designSpec: generatedRakhi.designSpec)

                    // Send Rakhi Button
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
                        dismiss()
                    }
                    .foregroundStyle(.orange)
                }
            }
        }
        .sheet(isPresented: $showingSendOptions) {
            SendRakhiOptionsView(generatedRakhi: generatedRakhi, recipient: recipient)
        }
    }
}

struct GeneratedImageCard: View {
    let generatedRakhi: GeneratedRakhi

    var body: some View {
        VStack(spacing: 16) {
            // Generated Image
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

            // Image Info
            VStack(spacing: 8) {
                Text("AI-Generated Traditional Rakhi")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                Text("Created on \(generatedRakhi.createdAt.formatted(date: .abbreviated, time: .shortened))")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 24))
    }
}

struct ScoreDisplaySection: View {
    let generatedRakhi: GeneratedRakhi

    var body: some View {
        HStack(spacing: 20) {
            ScoreCard(
                title: "Quality Score",
                score: generatedRakhi.qualityScore,
                color: .blue,
                icon: "star.fill"
            )

            ScoreCard(
                title: "Cultural Score",
                score: generatedRakhi.culturalScore,
                color: .green,
                icon: "leaf.fill"
            )
        }
    }
}

struct ScoreCard: View {
    let title: String
    let score: Double
    let color: Color
    let icon: String

    var scoreText: String {
        "\(Int(score * 100))%"
    }

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(.title2))
                .foregroundStyle(color)

            VStack(spacing: 4) {
                Text(scoreText)
                    .font(.system(.title3, design: .rounded).weight(.bold))
                    .foregroundStyle(color)

                Text(title)
                    .font(.system(.caption, design: .rounded).weight(.medium))
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(color.opacity(0.05), in: RoundedRectangle(cornerRadius: 16))
    }
}

struct DesignSummaryCard: View {
    let designSpec: RakhiDesignSpec

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "doc.text.fill")
                    .foregroundStyle(.orange)

                Text("Design Summary")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                Spacer()
            }

            VStack(alignment: .leading, spacing: 12) {
                SummaryRow(label: "Style", value: designSpec.genre.displayName)
                SummaryRow(label: "Elements", value: "\(designSpec.elements.count) selected")
                SummaryRow(label: "Color Palette", value: designSpec.colorPalette.rawValue)

                if let message = designSpec.personalMessage, !message.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Personal Message:")
                            .font(.system(.subheadline, design: .rounded).weight(.medium))
                            .foregroundStyle(.secondary)

                        Text("\"\(message)\"")
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(.primary)
                            .italic()
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(.orange.opacity(0.05), in: RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
    }
}

struct SummaryRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label + ":")
                .font(.system(.subheadline, design: .rounded).weight(.medium))
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .font(.system(.subheadline, design: .rounded).weight(.semibold))
                .foregroundStyle(.primary)
        }
    }
}

struct SendRakhiOptionsView: View {
    let generatedRakhi: GeneratedRakhi
    let recipient: Contact
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDeliveryMethod: DeliveryMethod = .messages
    @State private var showingSuccess = false

    enum DeliveryMethod: String, CaseIterable {
        case messages = "Messages"
        case whatsapp = "WhatsApp"
        case email = "Email"
        case saveToPhotos = "Save to Photos"

        var icon: String {
            switch self {
            case .messages: return "message.fill"
            case .whatsapp: return "message.fill" // Could use WhatsApp icon if available
            case .email: return "envelope.fill"
            case .saveToPhotos: return "photo.on.rectangle.angled"
            }
        }

        var description: String {
            switch self {
            case .messages: return "Send via iMessage"
            case .whatsapp: return "Send via WhatsApp"
            case .email: return "Send via Email"
            case .saveToPhotos: return "Save to your Photos app"
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 16) {
                    Image(systemName: "paperplane.circle.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(.orange)

                    VStack(spacing: 8) {
                        Text("Send Your Rakhi")
                            .font(.system(.title2, design: .rounded).weight(.bold))
                            .foregroundStyle(.primary)

                        Text("Choose how to send your Rakhi to \(recipient.name)")
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.top, 32)

                // Delivery Methods
                VStack(spacing: 12) {
                    ForEach(DeliveryMethod.allCases, id: \.self) { method in
                        DeliveryMethodRow(
                            method: method,
                            isSelected: selectedDeliveryMethod == method
                        ) {
                            selectedDeliveryMethod = method
                        }
                    }
                }

                Spacer()

                // Send Button
                Button {
                    sendRakhi()
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: selectedDeliveryMethod.icon)
                        Text("Send Rakhi")
                    }
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(.orange)
                    )
                    .shadow(color: .orange.opacity(0.3), radius: 8, y: 4)
                }
                .padding(.bottom, 32)
            }
            .padding(.horizontal, 24)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Send Rakhi")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(.orange)
                }
            }
        }
        .alert("Rakhi Sent!", isPresented: $showingSuccess) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Your Rakhi has been sent to \(recipient.name) via \(selectedDeliveryMethod.rawValue)!")
        }
    }

    private func sendRakhi() {
        // Here you would implement the actual sending logic
        // For now, we'll just show a success message
        showingSuccess = true
    }
}

struct DeliveryMethodRow: View {
    let method: SendRakhiOptionsView.DeliveryMethod
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Image(systemName: method.icon)
                    .font(.system(.title3))
                    .foregroundStyle(isSelected ? .orange : .secondary)
                    .frame(width: 32)

                VStack(alignment: .leading, spacing: 4) {
                    Text(method.rawValue)
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)

                    Text(method.description)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(.title3))
                        .foregroundStyle(.orange)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(isSelected ? Color.orange.opacity(0.05) : Color.gray.opacity(0.1))
            )
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? .orange : .clear, lineWidth: 2)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    GeneratedRakhiView(
        generatedRakhi: GeneratedRakhi(
            id: UUID(),
            designSpec: RakhiDesignSpec(
                genre: .traditional,
                elements: [],
                colorPalette: .traditional,
                personalMessage: "Happy Raksha Bandhan!",
                targetAgeGroup: .adult
            ),
            mainImage: AIImageResult(
                imageData: Data(),
                timestamp: Date()
            ),
            prompt: AIPrompt(
                positive: "test",
                negative: "test",
                cfg_scale: 7.5,
                steps: 30,
                seed: 123,
                width: 1024,
                height: 1024
            ),
            createdAt: Date(),
            culturalScore: 0.9,
            qualityScore: 0.85
        ),
        recipient: Contact(name: "Sample Contact", phoneNumber: "", relationship: "")
    )
}
