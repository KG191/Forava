import SwiftUI

// MARK: - Cultural Preview Step
struct CulturalPreviewStep: View {
    let designSpec: CulturalDesignSpec
    let recipient: Contact
    let onGenerate: () -> Void

    @ObservedObject private var terminologyService = DynamicCulturalTerminologyService.shared
    @ObservedObject private var subscriptionManager = SubscriptionManager.shared

    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("Review Your Design")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.primary)

                Text("Preview your \(terminologyService.digitalGiftTerm.lowercased()) before creating")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            ScrollView {
                VStack(spacing: 24) {
                    // Cultural Context Summary
                    culturalContextSummary

                    // Design Specifications
                    designSpecificationsSummary

                    // Personalization Summary
                    personalizationSummary

                    // Generation Cost Information
                    generationCostInfo

                    // AI Generation Preview
                    aiGenerationPreview
                }
            }
        }
    }

    private var culturalContextSummary: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Cultural Context")
                .font(.headline.weight(.medium))
                .foregroundStyle(.primary)

            HStack(spacing: 12) {
                Text(terminologyService.getCurrentOccasion()?.symbol ?? "🎁")
                    .font(.largeTitle)

                VStack(alignment: .leading, spacing: 4) {
                    Text(terminologyService.getCurrentOccasion()?.displayName ?? "Cultural Gift")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.primary)

                    Text("Digital \(terminologyService.getCurrentOccasion()?.displayName ?? "Special") Gift")
                        .font(.body)
                        .foregroundStyle(.secondary)

                    Text("For \(recipient.name)")
                        .font(.caption)
                        .foregroundStyle(.orange)
                        .fontWeight(.medium)
                }

                Spacer()
            }

            // Cultural authenticity indicator
            HStack {
                Text("Cultural Authenticity:")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                HStack(spacing: 2) {
                    ForEach(0..<5) { index in
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundStyle(.yellow)
                            .opacity(index < 4 ? 1.0 : 0.3) // Mock 4/5 stars
                    }
                }

                Text("High")
                    .font(.caption)
                    .foregroundStyle(.green)
                    .fontWeight(.medium)

                Spacer()
            }
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }

    private var designSpecificationsSummary: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Design Specifications")
                .font(.headline.weight(.medium))
                .foregroundStyle(.primary)

            VStack(spacing: 12) {
                // Style/Genre
                SpecificationRow(
                    icon: "paintbrush.fill",
                    title: "Style",
                    value: designSpec.genre.displayName.isEmpty ? "Traditional" : designSpec.genre.displayName
                )

                // Elements
                SpecificationRow(
                    icon: "sparkles",
                    title: "Elements",
                    value: designSpec.elements.isEmpty ? "Cultural symbols" : "\(designSpec.elements.count) selected"
                )

                // Colors
                SpecificationRow(
                    icon: "paintpalette.fill",
                    title: "Colors",
                    value: designSpec.colorPalette.displayName.isEmpty ? "Traditional palette" : designSpec.colorPalette.displayName,
                    colorPreview: !designSpec.colorPalette.colors.isEmpty ? designSpec.colorPalette.colors.prefix(3).map { $0.color } : []
                )

                // Age Appropriateness
                SpecificationRow(
                    icon: "person.fill",
                    title: "Age Group",
                    value: designSpec.targetAgeGroup.displayName.isEmpty ? "All ages" : designSpec.targetAgeGroup.displayName
                )
            }
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }

    private var personalizationSummary: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Personal Touch")
                .font(.headline.weight(.medium))
                .foregroundStyle(.primary)

            VStack(alignment: .leading, spacing: 12) {
                if let message = designSpec.personalMessage, !message.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Personal Message:")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Text("\"\(message)\"")
                            .font(.body)
                            .foregroundStyle(.primary)
                            .italic()
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Traditional Blessing:")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(getTraditionalBlessing())
                        .font(.body)
                        .foregroundStyle(.orange)
                        .italic()
                }
            }
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }

    private var generationCostInfo: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "creditcard.fill")
                    .foregroundStyle(.blue)

                Text("Generation Info")
                    .font(.headline.weight(.medium))
                    .foregroundStyle(.primary)

                Spacer()
            }

            VStack(spacing: 8) {
                HStack {
                    Text("First generation:")
                    Spacer()
                    Text("Free")
                        .fontWeight(.medium)
                        .foregroundStyle(.green)
                }

                if subscriptionManager.regenerationCredits > 0 {
                    HStack {
                        Text("Available credits:")
                        Spacer()
                        Text("\(subscriptionManager.regenerationCredits)")
                            .fontWeight(.medium)
                            .foregroundStyle(.orange)
                    }
                } else {
                    HStack {
                        Text("Re-generation cost:")
                        Spacer()
                        Text("$2.00")
                            .fontWeight(.medium)
                            .foregroundStyle(.orange)
                    }
                }

                HStack {
                    Text("Subscription:")
                    Spacer()
                    Text(subscriptionManager.currentSubscription.displayName)
                        .fontWeight(.medium)
                        .foregroundStyle(subscriptionManager.isPremiumSubscriber ? .green : .secondary)
                }
            }
            .font(.caption)
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }

    private var aiGenerationPreview: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("AI Generation Preview")
                .font(.headline.weight(.medium))
                .foregroundStyle(.primary)

            VStack(spacing: 12) {
                // Mock preview of what will be generated
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(
                        colors: getPreviewGradientColors(),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(height: 200)
                    .overlay(
                        VStack(spacing: 8) {
                            Text(terminologyService.getCurrentOccasion()?.symbol ?? "🎁")
                                .font(.system(size: 48))

                            Text("AI-Generated")
                                .font(.headline.weight(.medium))
                                .foregroundStyle(.white)

                            Text("\(terminologyService.getCurrentOccasion()?.displayName ?? "Cultural") Design")
                                .font(.body)
                                .foregroundStyle(.white.opacity(0.8))
                        }
                    )

                Text("Your \(terminologyService.digitalGiftTerm.lowercased()) will be uniquely generated using advanced AI with cultural authenticity validation.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }

    private func getPreviewGradientColors() -> [Color] {
        if !designSpec.colorPalette.colors.isEmpty {
            return Array(designSpec.colorPalette.colors.prefix(2).map { $0.color })
        }

        // Default cultural colors based on context
        switch designSpec.culturalContext {
        case "rakhi_indian": return [.orange, .red]
        case "chinese": return [.red, .yellow]
        case "christmas_christian": return [Color(red: 0.77, green: 0.12, blue: 0.23), Color(red: 0.13, green: 0.55, blue: 0.13)]
        default: return [.orange, .yellow]
        }
    }

    private func getTraditionalBlessing() -> String {
        guard let occasion = terminologyService.getCurrentOccasion() else { return "May this special occasion bring joy and happiness" }

        switch occasion.id {
        case "raksha_bandhan":
            return "May this sacred bond bring protection and endless blessings"
        case "diwali":
            return "May the festival of lights illuminate your path with joy and prosperity"
        case "chinese_new_year":
            return "Wishing you prosperity, good health, and boundless happiness"
        case "christmas":
            return "May the spirit of Christmas bring you peace and joy"
        case "eid_al_fitr":
            return "Eid Mubarak! May this blessed day bring you happiness and peace"
        case "hanukkah":
            return "May the lights of Hanukkah bring warmth and joy to your home"
        default:
            return "May this special occasion bring you happiness and blessings"
        }
    }
}

struct SpecificationRow: View {
    let icon: String
    let title: String
    let value: String
    let colorPreview: [Color]?

    init(icon: String, title: String, value: String, colorPreview: [Color]? = nil) {
        self.icon = icon
        self.title = title
        self.value = value
        self.colorPreview = colorPreview
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.orange)
                .frame(width: 20)

            Text(title)
                .font(.body)
                .foregroundStyle(.primary)

            Spacer()

            HStack(spacing: 6) {
                if let colors = colorPreview {
                    ForEach(Array(colors.enumerated()), id: \.offset) { _, color in
                        Circle()
                            .fill(color)
                            .frame(width: 12, height: 12)
                    }
                }

                Text(value)
                    .font(.body.weight(.medium))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    CulturalPreviewStep(
        designSpec: CulturalDesignSpec(
            culturalContext: "rakhi_indian",
            genre: CulturalGenre(id: "traditional", displayName: "Traditional", icon: "star", basePrompt: "traditional", culturalContext: "rakhi_indian"),
            colorPalette: CulturalColorPalette(id: "traditional", displayName: "Traditional Colors", colors: [], culturalContext: "rakhi_indian"),
            targetAgeGroup: CulturalAgeGroup(id: "adult", displayName: "Adult", ageRange: "18-60", culturalContext: "rakhi_indian")
        ),
        recipient: Contact(name: "Sample Contact", phoneNumber: "", relationship: "Sister"),
        onGenerate: {}
    )
}
