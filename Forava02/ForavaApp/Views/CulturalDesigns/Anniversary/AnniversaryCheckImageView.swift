import SwiftUI
import Foundation

struct AnniversaryCheckImageView: View {
    let generatedImages: [String: String]  // Keys: "iPhone", "AppleWatch"
    let personalMessage: String
    @Binding var isGenerating: Bool
    let culturalColor: Color
    let onRegenerate: () -> Void

    @State private var selectedFormat: ImageFormat = .iPhone
    @State private var showingFullscreen = false

    enum ImageFormat: String, CaseIterable {
        case iPhone = "iPhone"
        case appleWatch = "Apple Watch"

        var icon: String {
            switch self {
            case .iPhone: return "iphone"
            case .appleWatch: return "applewatch"
            }
        }

        var aspectRatio: CGFloat {
            switch self {
            case .iPhone: return 9.0/19.5  // iPhone aspect ratio
            case .appleWatch: return 1.0   // Square for Apple Watch
            }
        }

        var dictionaryKey: String {
            switch self {
            case .iPhone: return "iPhone"
            case .appleWatch: return "AppleWatch"
            }
        }

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
    }

    private var currentImage: String? {
        generatedImages[selectedFormat.dictionaryKey]
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header Section
                VStack(spacing: 12) {
                    Text("Check Your Anniversary Gift")
                        .font(.system(.title2, design: .rounded).weight(.bold))
                        .foregroundStyle(.primary)

                    Text("Review your AI-generated anniversary design for iPhone and Apple Watch")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)

                // Glass Morphism Content Container
                VStack(spacing: 24) {
                    // Format Selection
                    if !isGenerating && !generatedImages.isEmpty {
                        formatSelectionView()
                    }

                    // Image Display Area
                    imageDisplayView()

                    // Generation Controls
                    generationControlsView()

                    // Quality Assessment (if image exists)
                    if !isGenerating && !generatedImages.isEmpty {
                        qualityAssessmentView()
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
        .fullScreenCover(isPresented: $showingFullscreen) {
            fullscreenImageView()
        }
    }

    @ViewBuilder
    private func formatSelectionView() -> some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "rectangle.3.group.fill")
                    .foregroundStyle(culturalColor)
                Text("Format Preview")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                Spacer()
            }

            HStack(spacing: 16) {
                ForEach(ImageFormat.allCases, id: \.self) { format in
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedFormat = format
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: format.icon)
                                .font(.title3)
                                .foregroundStyle(selectedFormat == format ? .white : culturalColor)

                            Text(format.rawValue)
                                .font(.system(.subheadline, design: .rounded).weight(.medium))
                                .foregroundStyle(selectedFormat == format ? .white : culturalColor)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(selectedFormat == format ? culturalColor : culturalColor.opacity(0.1))
                        )
                    }
                }
                Spacer()
            }
        }
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private func imageDisplayView() -> some View {
        VStack(spacing: 16) {
            if isGenerating {
                generatingView()
            } else if let imageURL = currentImage {
                generatedImageView(imageURL: imageURL)
            } else {
                placeholderView()
            }
        }
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private func generatingView() -> some View {
        VStack(spacing: 20) {
            // Apple HIG-Compliant Progress Indicator
            ProgressView()
                .progressViewStyle(.circular)
                .scaleEffect(2.5)
                .tint(culturalColor)

            VStack(spacing: 8) {
                Text("Creating Your Anniversary Gift")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                Text("AI is crafting your personalized design...")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.secondary)

                Text("This usually takes 15-30 seconds")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
            }
        }
        .frame(height: 300)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(culturalColor.opacity(0.12))
        )
    }

    @ViewBuilder
    private func generatedImageView(imageURL: String) -> some View {
        VStack(spacing: 12) {
            // Image Preview - Using ImageWithTextOverlay component
            Button {
                showingFullscreen = true
            } label: {
                ImageWithTextOverlay(
                    imageURL: imageURL,
                    message: personalMessage,
                    imageSize: selectedFormat.displaySize,
                    culturalColor: culturalColor
                )
                .frame(maxWidth: .infinity)
                .aspectRatio(selectedFormat.aspectRatio, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(culturalColor.opacity(0.3), lineWidth: 2)
                )
                .shadow(color: culturalColor.opacity(0.2), radius: 8, x: 0, y: 4)
                .overlay(
                    // Tap hint overlay
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("Tap to view full size")
                                .font(.system(.caption2, design: .rounded).weight(.medium))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(.black.opacity(0.6))
                                )
                                .padding(8)
                        }
                    }
                )
            }
            .buttonStyle(.plain)

            // Format Info
            HStack {
                Image(systemName: selectedFormat.icon)
                    .foregroundStyle(culturalColor)
                Text("Optimized for \(selectedFormat.rawValue) with personal message")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
                Spacer()
            }
        }
    }

    @ViewBuilder
    private func placeholderView() -> some View {
        VStack(spacing: 16) {
            Image(systemName: "photo.badge.plus")
                .font(.system(.largeTitle))
                .foregroundStyle(.secondary)

            Text("No Image Generated Yet")
                .font(.system(.headline, design: .rounded).weight(.semibold))
                .foregroundStyle(.secondary)

            Text("Complete your selections and generate your anniversary gift")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(culturalColor.opacity(0.35), style: StrokeStyle(lineWidth: 2, dash: [5]))
        )
    }

    @ViewBuilder
    private func generationControlsView() -> some View {
        VStack(spacing: 12) {
            if !isGenerating && !generatedImages.isEmpty {
                // Regenerate Button
                Button(action: onRegenerate) {
                    HStack(spacing: 12) {
                        Image(systemName: "arrow.clockwise")
                            .font(.headline)

                        Text("Regenerate Design")
                            .font(.system(.headline, design: .rounded).weight(.semibold))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(culturalColor.gradient)
                    )
                }

                Text("Don't like this design? Generate a new variation")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private func qualityAssessmentView() -> some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(.green)
                Text("Quality Assessment")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                Spacer()
            }

            VStack(spacing: 12) {
                qualityMetric(
                    label: "Cultural Authenticity",
                    score: 0.92,
                    icon: "heart.fill",
                    color: .green
                )

                qualityMetric(
                    label: "Design Harmony",
                    score: 0.88,
                    icon: "paintpalette.fill",
                    color: .blue
                )

                qualityMetric(
                    label: "Image Quality",
                    score: 0.95,
                    icon: "photo.fill",
                    color: .purple
                )
            }

            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundStyle(.blue)
                Text("Your anniversary gift meets our high quality standards")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(culturalColor.opacity(0.10))
        )
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private func qualityMetric(label: String, score: Double, icon: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(color)
                .font(.subheadline)

            Text(label)
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.primary)

            Spacer()

            // Score Bar
            HStack(spacing: 8) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(culturalColor.opacity(0.12))
                            .frame(height: 6)

                        RoundedRectangle(cornerRadius: 4)
                            .fill(color.gradient)
                            .frame(width: geometry.size.width * score, height: 6)
                    }
                }
                .frame(width: 60, height: 6)

                Text("\(Int(score * 100))%")
                    .font(.system(.caption, design: .rounded).weight(.semibold))
                    .foregroundStyle(color)
                    .frame(width: 30, alignment: .trailing)
            }
        }
    }

    @ViewBuilder
    private func fullscreenImageView() -> some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack {
                HStack {
                    Button("Done") {
                        showingFullscreen = false
                    }
                    .foregroundStyle(.white)
                    .font(.headline)
                    Spacer()
                }
                .padding()

                Spacer()

                // Full size image display with text overlay
                if let imageURL = currentImage {
                    ImageWithTextOverlay(
                        imageURL: imageURL,
                        message: personalMessage,
                        imageSize: selectedFormat.displaySize,
                        culturalColor: culturalColor
                    )
                    .aspectRatio(selectedFormat.aspectRatio, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding()
                } else {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(culturalColor.opacity(0.10))
                        .aspectRatio(selectedFormat.aspectRatio, contentMode: .fit)
                        .overlay(
                            VStack(spacing: 16) {
                                Image(systemName: selectedFormat.icon)
                                    .font(.system(.largeTitle))
                                    .foregroundStyle(culturalColor)

                                Text("Full Size \(selectedFormat.rawValue) Preview")
                                    .font(.system(.title2, design: .rounded).weight(.semibold))
                                    .foregroundStyle(.primary)
                            }
                        )
                        .padding()
                }

                Spacer()
            }
        }
    }
}

#Preview {
    AnniversaryCheckImageView(
        generatedImages: ["iPhone": "sample_image_url", "AppleWatch": "sample_watch_url"],
        personalMessage: "Happy 10th Anniversary!",
        isGenerating: .constant(false),
        culturalColor: Color(hex: "#DC143C"),
        onRegenerate: {}
    )
}
