import SwiftUI
import Foundation

struct RakshaBandhanCheckImageView: View {
    let generatedImages: [String: String]
    let personalMessage: String
    @Binding var isGenerating: Bool
    let culturalColor: Color
    let onRegenerate: () -> Void

    @State private var selectedFormat: ImageFormat = .iPhone

    enum ImageFormat: String, CaseIterable {
        case iPhone = "iPhone"
        case appleWatch = "Apple Watch"

        var displaySize: CGSize {
            switch self {
            case .iPhone:
                return CGSize(
                    width: CGFloat(CulturalAIConfiguration.iPhoneWidth),
                    height: CGFloat(CulturalAIConfiguration.iPhoneHeight)
                )
            case .appleWatch:
                return CGSize(
                    width: CGFloat(CulturalAIConfiguration.watchWidth),
                    height: CGFloat(CulturalAIConfiguration.watchHeight)
                )
            }
        }

        var aspectRatio: CGFloat {
            switch self {
            case .iPhone: return 1024.0/1792.0  // DALL-E 3 portrait (9:15.75)
            case .appleWatch: return 1.0        // Square for Apple Watch
            }
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header Section
                VStack(spacing: 12) {
                    Text(isGenerating ? "Generating Your Gift..." : "Your Raksha Bandhan Gift")
                        .font(.system(.title2, design: .rounded).weight(.bold))
                        .foregroundStyle(.primary)

                    Text(isGenerating ? "Please wait while we create your personalized design" : "Preview your generated gift")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)

                // Glass Morphism Content Container
                VStack(spacing: 20) {
                    if isGenerating {
                        generationProgress()
                    } else if !generatedImages.isEmpty {
                        // Format Selector
                        formatSelector()

                        // Generated Image Display
                        generatedImageDisplay()

                        // Regenerate Button
                        regenerateButton()
                    } else {
                        emptyState()
                    }
                }
                .padding(.vertical, 24)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.thinMaterial)
                        .background(RoundedRectangle(cornerRadius: 20).fill(culturalColor.opacity(0.03)))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(culturalColor.opacity(0.3), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 16)

                Spacer(minLength: 100)
            }
        }
        .background(
            LinearGradient(
                colors: [culturalColor.opacity(0.08), .white],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }

    @ViewBuilder
    private func generationProgress() -> some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(culturalColor)
                .padding(.top, 40)

            Text("Creating your personalized Raksha Bandhan gift...")
                .font(.system(.headline, design: .rounded))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)

            Text("This may take 10-30 seconds")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.secondary)
                .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }

    @ViewBuilder
    private func formatSelector() -> some View {
        Picker("Format", selection: $selectedFormat) {
            ForEach(ImageFormat.allCases, id: \.self) { format in
                Text(format.rawValue).tag(format)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private func generatedImageDisplay() -> some View {
        let imageKey = selectedFormat.rawValue
        let imageURL = generatedImages[imageKey]

        VStack(spacing: 16) {
            // Image Display
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.secondarySystemBackground))
                    .aspectRatio(selectedFormat.aspectRatio, contentMode: .fit)

                if let urlString = imageURL {
                    // Use ImageWithTextOverlay for displaying image with message
                    ImageWithTextOverlay(
                        imageURL: urlString,
                        message: personalMessage,
                        imageSize: selectedFormat.displaySize,
                        culturalColor: culturalColor
                    )
                    .aspectRatio(selectedFormat.aspectRatio, contentMode: .fit)
                    .cornerRadius(16)
                } else {
                    VStack(spacing: 12) {
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)

                        Text("Image not available")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(.horizontal, 20)

            // Format Info
            Text("Format: \(selectedFormat.rawValue)")
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private func regenerateButton() -> some View {
        Button(action: onRegenerate) {
            HStack {
                Image(systemName: "arrow.clockwise")
                    .font(.headline)

                Text("Regenerate")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(culturalColor, lineWidth: 2)
            )
            .foregroundStyle(culturalColor)
        }
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private func emptyState() -> some View {
        VStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 60))
                .foregroundStyle(culturalColor.opacity(0.5))

            Text("No Gift Generated Yet")
                .font(.system(.title3, design: .rounded).weight(.semibold))
                .foregroundStyle(.primary)

            Text("Go to the Create tab to generate your Raksha Bandhan gift")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 60)
    }
}

#Preview {
    RakshaBandhanCheckImageView(
        generatedImages: [:],
        personalMessage: "रक्षा बंधन की शुभकामनाएं",
        isGenerating: .constant(false),
        culturalColor: Color(hex: "#FF6B35"),
        onRegenerate: {}
    )
}
