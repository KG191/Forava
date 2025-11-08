import SwiftUI
import Foundation

struct HoliColorPaletteView: View {
    @Binding var selectedColorPalette: HoliColorPalette?
    let culturalColor: Color

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header Section
                VStack(spacing: 12) {
                    Text("Choose Color Palette")
                        .font(.system(.title2, design: .rounded).weight(.bold))
                        .foregroundStyle(.primary)

                    Text("Select colors that will set the perfect mood for your Holi celebration")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)

                // Glass Morphism Content Container
                VStack(spacing: 20) {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(HoliColorPalette.allPalettes) { palette in
                            colorPaletteCard(
                                palette: palette,
                                isSelected: selectedColorPalette?.id == palette.id
                            )
                        }
                    }
                    .padding(.horizontal, 20)

                    // Selected Palette Preview
                    if let selectedPalette = selectedColorPalette {
                        selectedPalettePreview(palette: selectedPalette)
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
    private func colorPaletteCard(palette: HoliColorPalette, isSelected: Bool) -> some View {
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

                    Text(palette.hindiName)
                        .font(.system(.caption2, design: .rounded))
                        .foregroundStyle(.secondary)

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

    @ViewBuilder
    private func selectedPalettePreview(palette: HoliColorPalette) -> some View {
        VStack(spacing: 16) {
            Text("Selected Palette Preview")
                .font(.system(.headline, design: .rounded))
                .foregroundStyle(.primary)

            HStack(spacing: 12) {
                VStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(hex: palette.primaryColor))
                        .frame(height: 50)

                    Text("Primary")
                        .font(.system(.caption2, design: .rounded))
                        .foregroundStyle(.secondary)
                }

                VStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(hex: palette.secondaryColor))
                        .frame(height: 50)

                    Text("Secondary")
                        .font(.system(.caption2, design: .rounded))
                        .foregroundStyle(.secondary)
                }

                VStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(hex: palette.accentColor))
                        .frame(height: 50)

                    Text("Accent")
                        .font(.system(.caption2, design: .rounded))
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
        .padding(.horizontal, 20)
    }
}

#Preview {
    HoliColorPaletteView(
        selectedColorPalette: .constant(HoliColorPalette.allPalettes[0]),
        culturalColor: Color(hex: "#FF6B35")
    )
}
