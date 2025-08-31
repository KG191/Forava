import SwiftUI

// MARK: - Cultural Gift Preview View
struct CulturalGiftPreviewView: View {
    let gift: CulturalGift
    let recipient: Contact

    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var terminologyService = DynamicCulturalTerminologyService.shared
    @State private var showingShareSheet = false
    @State private var shareImage: UIImage?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Gift Header
                    giftHeader

                    // Generated Image
                    generatedImageView

                    // Gift Details
                    giftDetails

                    // Cultural Information
                    culturalInformation

                    // Actions
                    actionButtons
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .navigationTitle("\(terminologyService.digitalGiftTerm)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                        .foregroundStyle(.orange)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        shareGift()
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .foregroundStyle(.orange)
                }
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            if let image = shareImage {
                ShareSheet(items: [image])
            }
        }
    }

    private var giftHeader: some View {
        VStack(spacing: 16) {
            // Cultural symbol
            Text(terminologyService.getCurrentOccasion()?.symbol ?? "🎁")
                .font(.system(size: 64))

            VStack(spacing: 8) {
                Text("Your \(terminologyService.digitalGiftTerm)")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.primary)

                Text("For \(recipient.name)")
                    .font(.headline)
                    .foregroundStyle(.orange)

                if let relationship = gift.designSpec.personalMessage {
                    Text("\"\(relationship)\"")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .italic()
                        .multilineTextAlignment(.center)
                        .padding(.top, 4)
                }
            }
        }
    }

    private var generatedImageView: some View {
        VStack(spacing: 16) {
            if gift.generatedImages.isEmpty {
                // Placeholder for generated image
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: getCulturalColors(),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 300)
                    .overlay(
                        VStack(spacing: 12) {
                            Text(terminologyService.getCurrentOccasion()?.symbol ?? "🎁")
                                .font(.system(size: 48))

                            Text("AI-Generated")
                                .font(.headline.weight(.medium))
                                .foregroundStyle(.white)

                            Text("\(terminologyService.getCurrentOccasion()?.displayName ?? "Cultural") Design")
                                .font(.body)
                                .foregroundStyle(.white.opacity(0.8))
                        }
                    )
                    .shadow(radius: 8)
            } else {
                // Display generated image
                ForEach(gift.generatedImages.prefix(1), id: \.id) { image in
                    if let uiImage = UIImage(data: image.imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(radius: 8)
                    } else {
                        // Fallback if image data is invalid
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 300)
                            .overlay(
                                Text("Image Preview")
                                    .foregroundStyle(.secondary)
                            )
                    }
                }
            }

            // Status indicator
            HStack {
                Circle()
                    .fill(gift.status.color)
                    .frame(width: 8, height: 8)

                Text(gift.status.displayName)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                if !gift.generatedImages.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundStyle(.yellow)

                        Text(String(format: "%.0f%%", gift.generatedImages.first?.culturalAccuracyScore ?? 0.85 * 100))
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Text("Cultural Accuracy")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    private var giftDetails: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Design Details")
                .font(.headline.weight(.medium))
                .foregroundStyle(.primary)

            VStack(spacing: 12) {
                DetailRow(
                    icon: "paintbrush.fill",
                    title: "Style",
                    value: gift.designSpec.genre.displayName.isEmpty ? "Traditional" : gift.designSpec.genre.displayName
                )

                DetailRow(
                    icon: "sparkles",
                    title: "Elements",
                    value: gift.designSpec.elements.isEmpty ? "Cultural symbols" : "\(gift.designSpec.elements.count) cultural elements"
                )

                DetailRow(
                    icon: "paintpalette.fill",
                    title: "Colors",
                    value: gift.designSpec.colorPalette.displayName.isEmpty ? "Traditional palette" : gift.designSpec.colorPalette.displayName
                )

                DetailRow(
                    icon: "clock.fill",
                    title: "Created",
                    value: formatDate(gift.createdAt)
                )
            }
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }

    private var culturalInformation: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Cultural Significance")
                .font(.headline.weight(.medium))
                .foregroundStyle(.primary)

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Occasion:")
                        .font(.body.weight(.medium))
                    Text(terminologyService.getCurrentOccasion()?.displayName ?? "Special Occasion")
                        .font(.body)
                        .foregroundStyle(.orange)
                    Spacer()
                }

                HStack {
                    Text("Cultural Context:")
                        .font(.body.weight(.medium))
                    Text(gift.designSpec.culturalContext.capitalized)
                        .font(.body)
                        .foregroundStyle(.secondary)
                    Spacer()
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Traditional Blessing:")
                        .font(.body.weight(.medium))

                    Text(getTraditionalBlessing())
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .italic()
                }
            }
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }

    private var actionButtons: some View {
        VStack(spacing: 16) {
            // Primary action - Share
            Button {
                shareGift()
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share \(terminologyService.digitalGiftTerm)")
                }
                .font(.headline.weight(.semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(.orange, in: RoundedRectangle(cornerRadius: 16))
            }

            // Secondary actions
            HStack(spacing: 12) {
                // Save to Photos
                Button {
                    saveToPhotos()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "square.and.arrow.down")
                        Text("Save")
                    }
                    .font(.body.weight(.medium))
                    .foregroundStyle(.orange)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(.orange.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
                }

                // Regenerate (if premium)
                Button {
                    regenerateGift()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.clockwise")
                        Text("Regenerate")
                    }
                    .font(.body.weight(.medium))
                    .foregroundStyle(.blue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }

    // MARK: - Helper Methods

    private func getCulturalColors() -> [Color] {
        if !gift.designSpec.colorPalette.colors.isEmpty {
            return gift.designSpec.colorPalette.colors.prefix(2).map { $0.color }
        }

        switch gift.designSpec.culturalContext {
        case "rakhi_indian": return [.orange, .red]
        case "chinese": return [.red, .yellow]
        case "christmas_christian": return [Color(red: 0.77, green: 0.12, blue: 0.23), Color(red: 0.13, green: 0.55, blue: 0.13)]
        default: return [.orange, .yellow]
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private func getTraditionalBlessing() -> String {
        guard let occasion = terminologyService.getCurrentOccasion() else {
            return "May this special gift bring joy and happiness to your heart."
        }

        switch occasion.id {
        case "raksha_bandhan":
            return "May this sacred bond of protection bring endless blessings and strengthen the love between siblings."
        case "diwali":
            return "May the festival of lights illuminate your path with joy, prosperity, and divine blessings."
        case "chinese_new_year":
            return "Wishing you prosperity, good health, and boundless happiness in the year ahead."
        case "christmas":
            return "May the spirit of Christmas bring you peace, joy, and the warmth of family love."
        case "eid_al_fitr":
            return "Eid Mubarak! May this blessed day bring you happiness, peace, and spiritual fulfillment."
        case "hanukkah":
            return "May the lights of Hanukkah bring warmth, hope, and joy to your home and heart."
        default:
            return "May this special occasion bring you happiness, love, and countless blessings."
        }
    }

    private func shareGift() {
        // Create shareable image
        createShareableImage()
    }

    private func createShareableImage() {
        // In a real implementation, this would create a composite image
        // For now, we'll use a placeholder
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 400, height: 600))
        let image = renderer.image { context in
            // Create a gradient background
            let colors = getCulturalColors()
            if colors.count >= 2 {
                let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                        colors: [colors[0].cgColor!, colors[1].cgColor!] as CFArray,
                                        locations: [0.0, 1.0])!
                context.cgContext.drawLinearGradient(gradient,
                                                   start: CGPoint(x: 0, y: 0),
                                                   end: CGPoint(x: 400, y: 600),
                                                   options: [])
            }

            // Add text overlay (simplified)
            let text = "\(terminologyService.digitalGiftTerm)\nFor \(recipient.name)"
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: 24, weight: .bold)
            ]

            let attributedString = NSAttributedString(string: text, attributes: attributes)
            let textSize = attributedString.size()
            let textRect = CGRect(
                x: (400 - textSize.width) / 2,
                y: (600 - textSize.height) / 2,
                width: textSize.width,
                height: textSize.height
            )
            attributedString.draw(in: textRect)
        }

        shareImage = image
        showingShareSheet = true
    }

    private func saveToPhotos() {
        createShareableImage()
        if let image = shareImage {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }

    private func regenerateGift() {
        // This would trigger a new generation
        print("Regenerating gift...")
    }
}

// MARK: - Supporting Views

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.orange)
                .frame(width: 20)

            Text(title)
                .font(.body)
                .foregroundStyle(.primary)

            Spacer()

            Text(value)
                .font(.body.weight(.medium))
                .foregroundStyle(.secondary)
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    CulturalGiftPreviewView(
        gift: CulturalGift.mock(for: Contact(name: "Sample Contact", phoneNumber: "", relationship: .sister)),
        recipient: Contact(name: "Sample Contact", phoneNumber: "", relationship: .sister)
    )
}
