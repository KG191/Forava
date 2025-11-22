import SwiftUI

/// Component that displays an image with native iOS text overlay
/// Guarantees perfect typography, spelling, and placement
struct ImageWithTextOverlay: View {
    let imageURL: String
    let message: String
    let imageSize: CGSize
    let culturalColor: Color

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background image
                AsyncImage(url: URL(string: imageURL)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .scaleEffect(1.2)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    case .failure:
                        Rectangle()
                            .fill(Color(.systemGray6))
                            .overlay(
                                Image(systemName: "exclamationmark.triangle")
                                    .foregroundStyle(.red)
                            )
                    @unknown default:
                        EmptyView()
                    }
                }

                // Text overlay - positioned at bottom with background
                if !message.isEmpty && message != "No message selected" {
                    VStack {
                        Spacer()

                        Text(message)
                            .font(textFont(for: geometry.size))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                            .shadow(color: Color(hex: "#FF8A00").opacity(0.8), radius: 4, x: 0, y: 2)
                            .shadow(color: Color(hex: "#FF8A00").opacity(0.4), radius: 8, x: 0, y: 4)
                            .padding(.horizontal, max(geometry.size.width * 0.08, 16))
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.ultraThinMaterial)
                                    .opacity(0.3)  // (0.0 = invisible, 1.0 = full material)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(.white.opacity(0.2), lineWidth: 1)
                                    )
                            )
                            .padding(.horizontal, max(geometry.size.width * 0.06, 12))
                            .padding(.bottom, max(geometry.size.height * 0.05, 16))
                    }
                }
            }
        }
    }

    // MARK: - Computed Properties

    /// Adaptive font size based on displayed dimensions and text length
    private func textFont(for displaySize: CGSize) -> Font {
        let baseSize: CGFloat

        // Determine base size from display height (not original image height)
        if displaySize.height > 600 {
            // Large display (e.g., fullscreen)
            baseSize = 28
        } else if displaySize.height > 400 {
            // Medium display
            baseSize = 22
        } else if displaySize.height > 250 {
            // Small display
            baseSize = 18
        } else {
            // Very small display
            baseSize = 14
        }

        // Reduce size if message is very long
        let adjustedSize: CGFloat
        if message.count > 50 {
            adjustedSize = baseSize * 0.75
        } else if message.count > 30 {
            adjustedSize = baseSize * 0.85
        } else {
            adjustedSize = baseSize
        }

        // Use elegant script/calligraphy font
        return .custom("Snell Roundhand", size: adjustedSize)
            .weight(.bold)
    }
}

#Preview {
    ImageWithTextOverlay(
        imageURL: "sample_image_url",
        message: "Happy 10th Anniversary!",
        imageSize: CGSize(width: 400, height: 800),
        culturalColor: Color(hex: "#DC143C")
    )
    .frame(width: 400, height: 800)
}
