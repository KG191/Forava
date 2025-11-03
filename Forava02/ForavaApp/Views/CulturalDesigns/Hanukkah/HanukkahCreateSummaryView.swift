import SwiftUI
import Foundation

struct HanukkahCreateSummaryView: View {
    let selectedTheme: HanukkahTheme?
    let selectedElements: [HanukkahElement]
    let selectedColorPalette: HanukkahColorPalette?
    let finalMessage: String
    let isReadyToGenerate: Bool
    let culturalColor: Color
    let onGenerate: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header Section
                VStack(spacing: 12) {
                    Text("Create Your Hanukkah Gift")
                        .font(.system(.title2, design: .rounded).weight(.bold))
                        .foregroundStyle(.primary)

                    Text("Review your selections and generate your personalized gift")
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
                .fill(isComplete ? culturalColor.opacity(0.10) : Color(.secondarySystemBackground))
        )
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private func progressOverview() -> some View {
        let completionCount = [
            selectedTheme != nil,
            !selectedElements.isEmpty,
            selectedColorPalette != nil,
            !finalMessage.isEmpty && finalMessage != "No message selected"
        ].filter { $0 }.count

        VStack(spacing: 12) {
            HStack {
                Text("Progress")
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(.primary)

                Spacer()

                Text("\(completionCount)/4 Complete")
                    .font(.system(.subheadline, design: .rounded).weight(.medium))
                    .foregroundStyle(completionCount == 4 ? culturalColor : .secondary)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.secondarySystemBackground))
                        .frame(height: 12)

                    RoundedRectangle(cornerRadius: 8)
                        .fill(culturalColor.gradient)
                        .frame(width: geometry.size.width * (CGFloat(completionCount) / 4.0), height: 12)
                }
            }
            .frame(height: 12)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private func generationPreview() -> some View {
        VStack(spacing: 12) {
            Image(systemName: "sparkles")
                .font(.largeTitle)
                .foregroundStyle(culturalColor)

            Text("Ready to Generate!")
                .font(.system(.title3, design: .rounded).weight(.bold))
                .foregroundStyle(.primary)

            Text("Your personalized Hanukkah gift will include both iPhone and Apple Watch formats")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(culturalColor.opacity(0.10))
        )
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private func generateButton() -> some View {
        Button(action: onGenerate) {
            HStack {
                if isReadyToGenerate {
                    Image(systemName: "wand.and.stars")
                        .font(.headline)
                }

                Text(isReadyToGenerate ? "Generate Gift" : "Complete All Selections")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isReadyToGenerate ? culturalColor.gradient : Color(.secondarySystemBackground).gradient)
            )
            .foregroundStyle(isReadyToGenerate ? .white : .secondary)
        }
        .disabled(!isReadyToGenerate)
        .padding(.horizontal, 20)
    }

    // MARK: - Computed Properties
    private var elementsDescription: String {
        if selectedElements.isEmpty {
            return "Not selected"
        }
        return selectedElements.map { $0.name }.joined(separator: ", ")
    }

    private var elementsDetailDescription: String {
        if selectedElements.isEmpty {
            return ""
        }
        return selectedElements.map { $0.name }.joined(separator: ", ")
    }

    private var messageDescription: String {
        if finalMessage.isEmpty || finalMessage == "No message selected" {
            return "Not selected"
        }
        return finalMessage.count > 30 ? String(finalMessage.prefix(30)) + "..." : finalMessage
    }
}

#Preview {
    HanukkahCreateSummaryView(
        selectedTheme: .traditional,
        selectedElements: [HanukkahElement.allElements[0]],
        selectedColorPalette: HanukkahColorPalette.allPalettes[0],
        finalMessage: "חג שמח! Happy Hanukkah and Festival of Lights!",
        isReadyToGenerate: true,
        culturalColor: Color(hex: "#0047AB"),
        onGenerate: {}
    )
}
