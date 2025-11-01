import SwiftUI
import Foundation

struct RoshHashanahCreateSummaryView: View {
    let selectedTheme: RoshHashanahTheme?
    let selectedElements: [RoshHashanahElement]
    let selectedColorPalette: RoshHashanahColorPalette?
    let finalMessage: String
    let isReadyToGenerate: Bool
    let culturalColor: Color
    let onGenerate: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                summaryContainer
                Spacer(minLength: 100)
            }
        }
        .background(backgroundGradient)
    }

    private var headerSection: some View {
        VStack(spacing: 12) {
            Text("Review Your Rosh Hashanah Gift")
                .font(.system(.title2, design: .rounded).weight(.bold))
                .foregroundStyle(.primary)

            Text("Review your selections before creating your personalized High Holy Days gift")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
    }

    private var summaryContainer: some View {
        VStack(spacing: 20) {
            styleRow
            Divider()
            elementsRow
            Divider()
            colorPaletteSection
            Divider()
            personalMessageSection

            if !isReadyToGenerate {
                generationWarning
            }

            generateButton
        }
        .padding(20)
        .background(glassMorphismBackground)
        .padding(.horizontal, 16)
    }

    private var styleRow: some View {
        summaryRow(
            icon: "paintpalette.fill",
            title: "Style",
            value: selectedTheme?.rawValue ?? "Not selected",
            isComplete: selectedTheme != nil
        )
    }

    private var elementsRow: some View {
        summaryRow(
            icon: "star.fill",
            title: "Element",
            value: selectedElements.first?.name ?? "Not selected",
            isComplete: !selectedElements.isEmpty
        )
    }

    @ViewBuilder
    private func summaryRow(icon: String, title: String, value: String, isComplete: Bool) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(culturalColor)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(.caption, design: .rounded).weight(.semibold))
                    .foregroundStyle(.secondary)

                Text(value)
                    .font(.system(.body, design: .rounded).weight(.medium))
                    .foregroundStyle(isComplete ? .primary : .secondary)
            }

            Spacer()

            if isComplete {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(culturalColor)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
        )
    }

    private var colorPaletteSection: some View {
        VStack {
            if let palette = selectedColorPalette {
                colorPaletteDetail(palette)
            } else {
                summaryRow(
                    icon: "paintbrush.fill",
                    title: "Color Palette",
                    value: "Not selected",
                    isComplete: false
                )
            }
        }
    }

    private func colorPaletteDetail(_ palette: RoshHashanahColorPalette) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "paintbrush.fill")
                    .foregroundStyle(culturalColor)
                Text("Color Palette")
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                Spacer()
            }

            Text(palette.name)
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.primary)

            HStack(spacing: 12) {
                Circle()
                    .fill(Color(hex: palette.primaryColor))
                    .frame(width: 32, height: 32)
                Circle()
                    .fill(Color(hex: palette.secondaryColor))
                    .frame(width: 32, height: 32)
                Circle()
                    .fill(Color(hex: palette.accentColor))
                    .frame(width: 32, height: 32)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
        )
    }

    private var personalMessageSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "message.fill")
                    .foregroundStyle(culturalColor)
                Text("Personal Message")
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                Spacer()
            }

            Text(finalMessage.isEmpty ? "No message" : finalMessage)
                .font(.system(.body, design: .rounded))
                .foregroundStyle(finalMessage.isEmpty ? .secondary : .primary)
                .multilineTextAlignment(.leading)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
        )
    }

    private var generationWarning: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.orange)
            Text("Please complete all selections to generate your gift")
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.orange.opacity(0.1))
        )
    }

    private var generateButton: some View {
        Button(action: onGenerate) {
            HStack {
                Image(systemName: "sparkles")
                    .font(.headline)

                Text("Generate Rosh Hashanah Gift")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isReadyToGenerate ? culturalColor.gradient : Color.gray.gradient)
            )
            .foregroundStyle(.white)
        }
        .disabled(!isReadyToGenerate)
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
    RoshHashanahCreateSummaryView(
        selectedTheme: .traditional,
        selectedElements: [RoshHashanahElement.allElements[0]],
        selectedColorPalette: RoshHashanahColorPalette.allPalettes[0],
        finalMessage: "L'Shanah Tovah! Wishing you a sweet and blessed New Year",
        isReadyToGenerate: true,
        culturalColor: Color(hex: "#4169E1"),
        onGenerate: {}
    )
}
