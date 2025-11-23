import SwiftUI

struct CulturalEventCard: View {
    let event: CulturalEvent
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            // Card with image above and text below
            VStack(alignment: .center, spacing: DeviceInfo.isIPad ? 16 : 12) {
                // Pure image with PNG transparency - fixed positioning
                Image(event.imageName)
                    .renderingMode(.original)  // Preserve PNG alpha channels
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: DeviceInfo.isIPad ? 260 : 210, height: DeviceInfo.isIPad ? 185 : 150)
                    .clipped()  // Ensure consistent bounds

                // Text details positioned below the image
                VStack(spacing: 6) {
                    Text(event.name)
                        .font(.system(.subheadline, design: .rounded).weight(.bold))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .multilineTextAlignment(.center)
                        .shadow(color: .black.opacity(0.5), radius: 2, y: 1)

                    HStack(spacing: 4) {
                        Image(systemName: event.category.icon)
                            .font(.caption2)
                        Text(event.category.displayName)
                            .font(.system(.caption2, design: .rounded).weight(.medium))
                    }
                    .foregroundStyle(.white.opacity(0.9))
                    .shadow(color: .black.opacity(0.3), radius: 1, y: 0.5)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .frame(width: DeviceInfo.isIPad ? 260 : 210)
                .frame(minHeight: DeviceInfo.isIPad ? 75 : 65)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.ultraThinMaterial)
                        .opacity(0.7)
                )
            }
        }
        .buttonStyle(.plain)  // No button styling that could add backgrounds
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: isSelected)
    }
}

#Preview {
    HStack(spacing: 20) {
        CulturalEventCard(
            event: CulturalEvent.allEvents[0],
            isSelected: false,
            onTap: {}
        )

        CulturalEventCard(
            event: CulturalEvent.allEvents[1],
            isSelected: true,
            onTap: {}
        )
    }
    .padding()
    .background(.gray.opacity(0.1))
}
