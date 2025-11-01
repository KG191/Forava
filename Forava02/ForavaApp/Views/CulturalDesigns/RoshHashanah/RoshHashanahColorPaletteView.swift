import SwiftUI
import Foundation

struct RoshHashanahColorPaletteView: View {
    @Binding var selectedColorPalette: RoshHashanahColorPalette?
    let culturalColor: Color

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                contentContainer
                Spacer(minLength: 100)
            }
        }
        .background(backgroundGradient)
    }

    private var headerSection: some View {
        VStack(spacing: 12) {
            Text("Choose Your Color Palette")
                .font(.system(.title2, design: .rounded).weight(.bold))
                .foregroundStyle(.primary)

            Text("Select the color scheme that resonates with your High Holy Days celebration")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
    }

    private var contentContainer: some View {
        VStack(spacing: 16) {
            ForEach(RoshHashanahColorPalette.allPalettes) { palette in
                colorPaletteCard(
                    palette: palette,
                    isSelected: selectedColorPalette?.id == palette.id
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .background(glassMorphismBackground)
        .padding(.horizontal, 16)
    }

    @ViewBuilder
    private func colorPaletteCard(palette: RoshHashanahColorPalette, isSelected: Bool) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedColorPalette = palette
            }
        } label: {
            VStack(spacing: 12) {
                // Color Swatches
                HStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(hex: palette.primaryColor))
                        .frame(height: 60)

                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(hex: palette.secondaryColor))
                        .frame(height: 60)

                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(hex: palette.accentColor))
                        .frame(height: 60)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? culturalColor : Color.clear, lineWidth: 3)
                )

                VStack(spacing: 4) {
                    Text(palette.name)
                        .font(.system(.subheadline, design: .rounded).weight(.semibold))
                        .foregroundStyle(isSelected ? culturalColor : .primary)

                    Text(palette.description)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }

                // Selection Indicator
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(culturalColor)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? culturalColor.opacity(0.25) : culturalColor.opacity(0.10))
            )
        }
        .buttonStyle(.plain)
    }

    private var glassMorphismBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.thinMaterial)
            .background(RoundedRectangle(cornerRadius: 20).fill(culturalColor.opacity(0.03)))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(culturalColor.opacity(0.3), lineWidth: 1)
            )
    }

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [culturalColor.opacity(0.08), .white],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

#Preview {
    RoshHashanahColorPaletteView(
        selectedColorPalette: .constant(RoshHashanahColorPalette.allPalettes[0]),
        culturalColor: Color(hex: "#4169E1")
    )
}
