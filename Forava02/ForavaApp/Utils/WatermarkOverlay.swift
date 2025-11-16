import SwiftUI

/// Watermark overlay for free tier images
struct WatermarkOverlay: View {
    let culturalColor: Color

    var body: some View {
        VStack {
            Spacer()

            HStack {
                Spacer()

                // Watermark badge (bottom-right corner)
                HStack(spacing: 6) {
                    Image(systemName: "infinity")
                        .font(.caption2)
                        .fontWeight(.semibold)

                    Text("Created with Forava")
                        .font(.caption2)
                        .fontWeight(.medium)
                }
                .foregroundStyle(.white.opacity(0.9))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(.black.opacity(0.4))
                        .blur(radius: 0.5)
                )
                .padding(16)
            }
        }
    }
}

/// Extension to easily add watermark to any image
extension View {
    func watermarked(isFreeTier: Bool, culturalColor: Color = .blue) -> some View {
        ZStack {
            self

            if isFreeTier {
                WatermarkOverlay(culturalColor: culturalColor)
            }
        }
    }
}

// MARK: - UIImage Watermarking
extension UIImage {
    /// Add watermark to UIImage (for sharing/saving)
    func withWatermark(text: String = "Created with Forava", culturalColor: UIColor = .systemBlue) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)

        return renderer.image { context in
            // Draw original image
            self.draw(at: .zero)

            // Configure watermark
            let textFont = UIFont.systemFont(ofSize: 14, weight: .medium)
            let textAttributes: [NSAttributedString.Key: Any] = [
                .font: textFont,
                .foregroundColor: UIColor.white.withAlphaComponent(0.9)
            ]

            // Calculate watermark position (bottom-right)
            let textSize = text.size(withAttributes: textAttributes)
            let padding: CGFloat = 16
            let badgePadding: CGFloat = 12
            let badgeHeight = textSize.height + badgePadding

            let badgeWidth = textSize.width + badgePadding * 2 + 20 // +20 for icon
            let badgeRect = CGRect(
                x: size.width - badgeWidth - padding,
                y: size.height - badgeHeight - padding,
                width: badgeWidth,
                height: badgeHeight
            )

            // Draw background capsule
            let path = UIBezierPath(roundedRect: badgeRect, cornerRadius: badgeHeight / 2)
            context.cgContext.setFillColor(UIColor.black.withAlphaComponent(0.4).cgColor)
            path.fill()

            // Draw infinity icon
            let iconSize: CGFloat = 12
            let iconY = badgeRect.midY - iconSize / 2
            let iconRect = CGRect(
                x: badgeRect.minX + badgePadding,
                y: iconY,
                width: iconSize,
                height: iconSize
            )

            // Simple infinity symbol representation (∞)
            let infinityFont = UIFont.systemFont(ofSize: iconSize, weight: .semibold)
            let infinityAttrs: [NSAttributedString.Key: Any] = [
                .font: infinityFont,
                .foregroundColor: UIColor.white.withAlphaComponent(0.9)
            ]
            "∞".draw(at: CGPoint(x: iconRect.minX, y: iconRect.minY), withAttributes: infinityAttrs)

            // Draw text
            let textX = badgeRect.minX + badgePadding + iconSize + 6
            let textY = badgeRect.midY - textSize.height / 2
            text.draw(at: CGPoint(x: textX, y: textY), withAttributes: textAttributes)
        }
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .frame(width: 300, height: 500)

        WatermarkOverlay(culturalColor: .blue)
    }
    .frame(width: 300, height: 500)
    .clipShape(RoundedRectangle(cornerRadius: 16))
}
