import SwiftUI

struct ColorSelectionStep: View {
    @Binding var designSpec: RakhiDesignSpec
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("Color Palette")
                    .font(.system(.title3, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)
                
                Text("Choose colors that resonate with your feelings")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Color Palette Options
            VStack(spacing: 16) {
                ForEach(ColorPalette.allCases, id: \.self) { palette in
                    ColorPaletteCard(
                        palette: palette,
                        isSelected: designSpec.colorPalette == palette
                    ) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            designSpec.colorPalette = palette
                        }
                    }
                }
            }
            
            // Color Meaning
            if designSpec.colorPalette != .traditional {
                ColorMeaningSection(palette: designSpec.colorPalette)
            }
        }
    }
}

struct ColorPaletteCard: View {
    let palette: ColorPalette
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Color Preview
                HStack(spacing: 4) {
                    ForEach(Array(palette.colors.enumerated()), id: \.offset) { _, color in
                        Circle()
                            .fill(color)
                            .frame(width: 24, height: 24)
                            .overlay {
                                Circle()
                                    .stroke(.white.opacity(0.3), lineWidth: 1)
                            }
                    }
                }
                .padding(.horizontal, 12)
                
                // Palette Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(palette.rawValue)
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)
                    
                    Text(paletteDescription(for: palette))
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                // Selection indicator
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(.title2))
                        .foregroundStyle(.orange)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? .orange : .clear, lineWidth: 2)
            }
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .shadow(
                color: isSelected ? .orange.opacity(0.3) : .black.opacity(0.05),
                radius: isSelected ? 8 : 4,
                y: isSelected ? 4 : 2
            )
        }
        .buttonStyle(.plain)
    }
    
    private func paletteDescription(for palette: ColorPalette) -> String {
        switch palette {
        case .traditional:
            return "Classic reds, oranges, and gold - timeless and sacred"
        case .modern:
            return "Contemporary blues and sleek colors for modern style"
        case .vibrant:
            return "Bright, energetic colors for a joyful celebration"
        case .pastel:
            return "Soft, gentle tones for a delicate touch"
        case .earthy:
            return "Natural earth tones for an organic, grounded feel"
        case .metallic:
            return "Gold, silver, and bronze for elegant luxury"
        case .monochrome:
            return "Sophisticated black, white, and gray palette"
        }
    }
}

struct ColorMeaningSection: View {
    let palette: ColorPalette
    
    var body: some View {
        VStack(spacing: 16) {
            Rectangle()
                .fill(.orange.opacity(0.3))
                .frame(height: 1)
            
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "paintbrush.pointed.fill")
                        .foregroundStyle(.orange)
                    
                    Text("Color Significance")
                        .font(.system(.subheadline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)
                    
                    Spacer()
                }
                
                Text(getColorMeaning(for: palette))
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(.orange.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private func getColorMeaning(for palette: ColorPalette) -> String {
        switch palette {
        case .traditional:
            return ""
        case .modern:
            return "Modern colors represent innovation and contemporary bonds. They symbolize the evolution of tradition while maintaining core values."
        case .vibrant:
            return "Bright colors symbolize joy, energy, and celebration. They represent the vibrant bond between siblings and the happiness of the festival."
        case .pastel:
            return "Soft pastel colors convey gentleness, care, and tender love. They're perfect for expressing subtle emotions and refined affection."
        case .earthy:
            return "Earth tones connect us to nature and represent grounding, stability, and the enduring strength of family bonds."
        case .metallic:
            return "Metallic tones represent prosperity, honor, and lasting bonds. Gold signifies purity and divine blessings for the relationship."
        case .monochrome:
            return "Monochrome palettes express sophistication and timeless elegance. They focus attention on design and form rather than color."
        }
    }
}

#Preview {
    ColorSelectionStep(designSpec: .constant(RakhiDesignSpec()))
        .padding()
        .background(Color(.systemGroupedBackground))
}