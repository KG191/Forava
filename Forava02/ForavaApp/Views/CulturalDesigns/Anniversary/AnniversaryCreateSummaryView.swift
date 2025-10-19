import SwiftUI
import Foundation

struct AnniversaryCreateSummaryView: View {
    let selectedTheme: AnniversaryTheme?
    let selectedGiftOption: String?
    let selectedElements: [AnniversaryElement]
    let selectedColorPalette: AnniversaryColorPalette?
    let finalMessage: String
    let isReadyToGenerate: Bool
    let culturalColor: Color
    let onGenerate: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header Section
                VStack(spacing: 12) {
                    Text("Create Your Anniversary Gift")
                        .font(.system(.title2, design: .rounded).weight(.bold))
                        .foregroundStyle(.primary)

                    Text("Review your selections and generate your personalized anniversary gift")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)

                // Glass Morphism Content Container
                VStack(spacing: 20) {
                    // Selection Summary Cards
                    VStack(spacing: 16) {
                        // Theme Card
                        selectionSummaryCard(
                            title: "Style Theme",
                            content: selectedTheme?.rawValue ?? "Not selected",
                            isComplete: selectedTheme != nil,
                            icon: "paintbrush.fill",
                            details: selectedTheme?.description
                        )

                        // Gift Option Card
                        selectionSummaryCard(
                            title: "Gift Style",
                            content: selectedGiftOption ?? "Not selected",
                            isComplete: selectedGiftOption != nil,
                            icon: "gift.fill",
                            details: selectedGiftOption != nil ? "Specific design style for your anniversary gift" : nil
                        )

                        selectionSummaryCard(
                            title: "Design Elements",
                            content: elementsDescription,
                            isComplete: !selectedElements.isEmpty,
                            icon: "square.stack.3d.up.fill",
                            details: elementsDetailDescription
                        )

                        selectionSummaryCard(
                            title: "Color Palette",
                            content: selectedColorPalette?.name ?? "Not selected",
                            isComplete: selectedColorPalette != nil,
                            icon: "paintpalette.fill",
                            details: selectedColorPalette?.description
                        )

                        selectionSummaryCard(
                            title: "Personal Message",
                            content: messageDescription,
                            isComplete: !finalMessage.isEmpty && finalMessage != "No message selected",
                            icon: "quote.bubble.fill",
                            details: finalMessage.count > 50 ? String(finalMessage.prefix(50)) + "..." : finalMessage
                        )
                    }

                    // Progress Overview
                    progressOverview()

                    // Generation Preview
                    if isReadyToGenerate {
                        generationPreview()
                    }

                    // Generate Button
                    generateButton()
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
    private func selectionSummaryCard(
        title: String,
        content: String,
        isComplete: Bool,
        icon: String,
        details: String? = nil
    ) -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                // Status Icon
                Image(systemName: isComplete ? "checkmark.circle.fill" : "circle.dashed")
                    .font(.title2)
                    .foregroundStyle(isComplete ? culturalColor : .secondary)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)

                    Text(content)
                        .font(.system(.subheadline, design: .rounded).weight(.semibold))
                        .foregroundStyle(isComplete ? .primary : .secondary)
                        .lineLimit(2)
                }

                Spacer()

                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(isComplete ? culturalColor : .secondary)
            }

            // Details Section
            if let details = details, !details.isEmpty, isComplete {
                Divider()

                HStack {
                    Text(details)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                    Spacer()
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isComplete ? culturalColor.opacity(0.25) : culturalColor.opacity(0.12))
        )
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private func progressOverview() -> some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "chart.pie.fill")
                    .foregroundStyle(culturalColor)
                Text("Completion Progress")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                Spacer()
            }

            // Progress Bar
            let progress = Double(completedSteps) / Double(totalSteps)
            VStack(spacing: 8) {
                HStack {
                    Text("\(completedSteps) of \(totalSteps) complete")
                        .font(.system(.subheadline, design: .rounded))
                    Spacer()
                    Text("\(Int(progress * 100))%")
                        .font(.system(.subheadline, design: .rounded).weight(.semibold))
                        .foregroundStyle(culturalColor)
                }

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(culturalColor.opacity(0.15))
                            .frame(height: 8)

                        RoundedRectangle(cornerRadius: 4)
                            .fill(culturalColor.gradient)
                            .frame(width: geometry.size.width * progress, height: 8)
                            .animation(.easeInOut(duration: 0.5), value: progress)
                    }
                }
                .frame(height: 8)
            }

            // Missing Items Alert
            if !isReadyToGenerate {
                missingItemsAlert()
            }
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
    private func missingItemsAlert() -> some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.orange)

            VStack(alignment: .leading, spacing: 4) {
                Text("Complete all selections to generate")
                    .font(.system(.caption, design: .rounded).weight(.semibold))
                    .foregroundStyle(.orange)

                Text(missingItemsDescription)
                    .font(.system(.caption2, design: .rounded))
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.orange.opacity(0.1))
        )
    }

    @ViewBuilder
    private func generationPreview() -> some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "wand.and.stars")
                    .foregroundStyle(culturalColor)
                Text("Ready to Generate")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(culturalColor)
                Spacer()
            }

            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Your anniversary gift will include:")
                            .font(.system(.subheadline, design: .rounded).weight(.medium))

                        VStack(alignment: .leading, spacing: 2) {
                            if let giftOption = selectedGiftOption {
                                featureItem("🎁 \(giftOption) design")
                            }
                            featureItem("🎨 \(selectedTheme?.rawValue ?? "") style theme")
                            featureItem("✨ \(selectedElements.count) custom design elements")
                            featureItem("🌈 \(selectedColorPalette?.name ?? "") color palette")
                            featureItem("💌 Personalized anniversary message")
                            featureItem("📱 iPhone & Apple Watch backgrounds")
                        }
                    }
                    Spacer()
                }
            }
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
    private func featureItem(_ text: String) -> some View {
        Text(text)
            .font(.system(.caption, design: .rounded))
            .foregroundStyle(.secondary)
    }

    @ViewBuilder
    private func generateButton() -> some View {
        VStack(spacing: 12) {
            Button(action: {
                if isReadyToGenerate {
                    onGenerate()
                } else {
                    // Haptic feedback for disabled state
                    #if os(iOS)
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                    #endif
                }
            }) {
                HStack(spacing: 12) {
                    Image(systemName: isReadyToGenerate ? "wand.and.stars" : "exclamationmark.triangle")
                        .font(.headline)

                    Text(isReadyToGenerate ? "Generate Your Anniversary Gift" : "Complete All Selections to Generate")
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isReadyToGenerate ? culturalColor.gradient : Color.orange.gradient)
                )
            }

            if isReadyToGenerate {
                Text("Generation typically takes 15-30 seconds")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
            } else {
                Text("Tap the missing items above to complete your selections")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.orange)
            }
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Computed Properties
    private var elementsDescription: String {
        if selectedElements.isEmpty {
            return "Not selected"
        }
        return "\(selectedElements.count) element\(selectedElements.count == 1 ? "" : "s") selected"
    }

    private var elementsDetailDescription: String {
        selectedElements.map { $0.name }.joined(separator: ", ")
    }

    private var messageDescription: String {
        if finalMessage.isEmpty || finalMessage == "No message selected" {
            return "Not selected"
        }
        return finalMessage.count > 30 ? "Custom message (\(finalMessage.count) characters)" : "Message selected"
    }

    private var completedSteps: Int {
        var steps = 0
        if selectedTheme != nil { steps += 1 }
        if selectedGiftOption != nil { steps += 1 }
        if !selectedElements.isEmpty { steps += 1 }
        if selectedColorPalette != nil { steps += 1 }
        if !finalMessage.isEmpty && finalMessage != "No message selected" { steps += 1 }
        return steps
    }

    private let totalSteps = 5

    private var missingItemsDescription: String {
        var missing: [String] = []
        if selectedTheme == nil { missing.append("Style Theme") }
        if selectedGiftOption == nil { missing.append("Gift Style") }
        if selectedElements.isEmpty { missing.append("Design Elements") }
        if selectedColorPalette == nil { missing.append("Color Palette") }
        if finalMessage.isEmpty || finalMessage == "No message selected" { missing.append("Personal Message") }

        if missing.count == 1 {
            return "Please select: \(missing[0])"
        } else if missing.count == 2 {
            return "Please select: \(missing[0]) and \(missing[1])"
        } else {
            return "Please select: \(missing.dropLast().joined(separator: ", ")) and \(missing.last!)"
        }
    }
}

#Preview {
    AnniversaryCreateSummaryView(
        selectedTheme: .romantic,
        selectedGiftOption: "Classic Love Letter Card",
        selectedElements: [AnniversaryElement.allElements[0], AnniversaryElement.allElements[4]],
        selectedColorPalette: AnniversaryColorPalette.allPalettes[0],
        finalMessage: "Celebrating another year of love and happiness together",
        isReadyToGenerate: true,
        culturalColor: Color(hex: "#DC143C"),
        onGenerate: {}
    )
}
