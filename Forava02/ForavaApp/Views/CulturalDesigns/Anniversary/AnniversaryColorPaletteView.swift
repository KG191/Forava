import SwiftUI
import Foundation

struct AnniversaryColorPaletteView: View {
    @Binding var selectedColorPalette: AnniversaryColorPalette?
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

                    Text("Select colors that will set the perfect mood for your anniversary celebration")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)

                // Glass Morphism Content Container
                VStack(spacing: 20) {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(AnniversaryColorPalette.allPalettes) { palette in
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
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(culturalColor.opacity(0.3), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 16)

                Spacer(minLength: 100)
            }
        }
        .background(Color(.systemGroupedBackground))
    }

    @ViewBuilder
    private func colorPaletteCard(palette: AnniversaryColorPalette, isSelected: Bool) -> some View {
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
                    .fill(isSelected ? culturalColor.opacity(0.1) : Color(.systemGray6))
            )
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func selectedPalettePreview(palette: AnniversaryColorPalette) -> some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Image(systemName: "paintpalette.fill")
                    .foregroundStyle(culturalColor)
                Text("Selected Palette: \(palette.name)")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                Spacer()
            }

            // Detailed Color Information
            VStack(spacing: 12) {
                colorDetailRow(
                    label: "Primary Color",
                    color: Color(hex: palette.primaryColor),
                    hexValue: palette.primaryColor
                )

                colorDetailRow(
                    label: "Secondary Color",
                    color: Color(hex: palette.secondaryColor),
                    hexValue: palette.secondaryColor
                )

                colorDetailRow(
                    label: "Accent Color",
                    color: Color(hex: palette.accentColor),
                    hexValue: palette.accentColor
                )
            }

            // Background Hint
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "wand.and.stars")
                        .foregroundStyle(culturalColor)
                    Text("Atmosphere")
                        .font(.system(.subheadline, design: .rounded).weight(.medium))
                    Spacer()
                }

                HStack {
                    Text(palette.backgroundHint.capitalized)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.secondary)
                    Spacer()
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: palette.primaryColor).opacity(0.1))
            )

            // Live Preview Sample
            anniversaryPreviewSample(with: palette)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(culturalColor.opacity(0.05))
        )
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private func colorDetailRow(label: String, color: Color, hexValue: String) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(color)
                .frame(width: 24, height: 24)
                .overlay(
                    Circle()
                        .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                )

            Text(label)
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.primary)

            Spacer()

            Text(hexValue.uppercased())
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(.systemGray5))
                .cornerRadius(6)
        }
    }

    @ViewBuilder
    private func anniversaryPreviewSample(with palette: AnniversaryColorPalette) -> some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "eye.fill")
                    .foregroundStyle(culturalColor)
                Text("Preview")
                    .font(.system(.subheadline, design: .rounded).weight(.medium))
                Spacer()
            }

            // Mini Anniversary Card Preview
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(hex: palette.primaryColor),
                            Color(hex: palette.secondaryColor)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 80)
                .overlay(
                    VStack(spacing: 4) {
                        Image(systemName: "heart.fill")
                            .font(.title2)
                            .foregroundStyle(Color(hex: palette.accentColor))

                        Text("Anniversary")
                            .font(.system(.caption, design: .rounded).weight(.bold))
                            .foregroundStyle(Color(hex: palette.accentColor))

                        Text("Celebrating Love")
                            .font(.system(.caption2, design: .rounded))
                            .foregroundStyle(Color(hex: palette.accentColor).opacity(0.8))
                    }
                )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: palette.accentColor).opacity(0.1))
        )
    }
}

#Preview {
    AnniversaryColorPaletteView(
        selectedColorPalette: .constant(AnniversaryColorPalette.allPalettes[0]),
        culturalColor: Color(hex: "#DC143C")
    )
}
