import SwiftUI

// MARK: - Cultural Personalization Step
struct CulturalPersonalizationStep: View {
    @Binding var designSpec: CulturalDesignSpec
    let recipient: Contact

    @ObservedObject private var terminologyService = DynamicCulturalTerminologyService.shared
    @State private var personalMessage = ""
    @State private var selectedRelationshipContext = ""
    @State private var includeTraditionalBlessing = true
    @State private var selectedAgeGroup = ""

    private let relationshipContexts = [
        "sibling": "Brother/Sister",
        "parent": "Parent",
        "grandparent": "Grandparent",
        "friend": "Friend",
        "cousin": "Cousin",
        "mentor": "Mentor/Teacher"
    ]

    private let ageGroups = [
        "child": "Child (5-12)",
        "teen": "Teenager (13-17)",
        "adult": "Adult (18-60)",
        "elder": "Elder (60+)"
    ]

    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("Personal Touch")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.primary)

                Text("Add personal elements to make this \(terminologyService.digitalGiftTerm.lowercased()) special")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            ScrollView {
                VStack(spacing: 24) {
                    // Relationship Context
                    relationshipSection

                    // Age Group Selection
                    ageGroupSection

                    // Personal Message
                    personalMessageSection

                    // Cultural Blessing Toggle
                    culturalBlessingSection

                    // Preview
                    personalizationPreview
                }
            }
        }
        .onAppear {
            setupInitialValues()
        }
    }

    private var relationshipSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Relationship")
                .font(.headline.weight(.medium))
                .foregroundStyle(.primary)

            Text("How are you related to \(recipient.name)?")
                .font(.caption)
                .foregroundStyle(.secondary)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                ForEach(Array(relationshipContexts.keys), id: \.self) { key in
                    RelationshipButton(
                        key: key,
                        displayName: relationshipContexts[key] ?? key,
                        isSelected: selectedRelationshipContext == key
                    ) {
                        selectedRelationshipContext = key
                        updateDesignSpec()
                    }
                }
            }
        }
    }

    private var ageGroupSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recipient's Age Group")
                .font(.headline.weight(.medium))
                .foregroundStyle(.primary)

            Text("This helps us choose culturally appropriate elements")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(spacing: 8) {
                ForEach(Array(ageGroups.keys), id: \.self) { key in
                    AgeGroupPill(
                        key: key,
                        displayName: ageGroups[key] ?? key,
                        isSelected: selectedAgeGroup == key
                    ) {
                        selectedAgeGroup = key
                        updateDesignSpec()
                    }
                }
            }
        }
    }

    private var personalMessageSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Personal Message (Optional)")
                .font(.headline.weight(.medium))
                .foregroundStyle(.primary)

            Text("Add a heartfelt message to \(recipient.name)")
                .font(.caption)
                .foregroundStyle(.secondary)

            ZStack(alignment: .topLeading) {
                TextEditor(text: $personalMessage)
                    .padding(8)
                    .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 8))
                    .frame(minHeight: 80)
                    .onChange(of: personalMessage) { _, _ in
                        updateDesignSpec()
                    }

                if personalMessage.isEmpty {
                    Text("Write a special message...")
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 16)
                        .allowsHitTesting(false)
                }
            }

            // Character count
            HStack {
                Spacer()
                Text("\(personalMessage.count)/200")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var culturalBlessingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Include Traditional Blessing")
                    .font(.headline.weight(.medium))
                    .foregroundStyle(.primary)

                Spacer()

                Toggle("", isOn: $includeTraditionalBlessing)
                    .tint(.orange)
                    .onChange(of: includeTraditionalBlessing) { _, _ in
                        updateDesignSpec()
                    }
            }

            Text(getBlessingPreview())
                .font(.caption)
                .foregroundStyle(.secondary)
                .italic()
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }

    private var personalizationPreview: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Preview")
                .font(.headline.weight(.medium))
                .foregroundStyle(.primary)

            VStack(spacing: 12) {
                // Gift preview card
                VStack(spacing: 8) {
                    HStack {
                        Text(terminologyService.getCurrentOccasion()?.symbol ?? "🎁")
                            .font(.title2)

                        Text("Digital \(terminologyService.getCurrentOccasion()?.displayName ?? "Special") Gift")
                            .font(.headline.weight(.medium))

                        Spacer()
                    }

                    HStack {
                        Text("For: \(recipient.name)")
                            .font(.body)
                            .foregroundStyle(.primary)

                        if !selectedRelationshipContext.isEmpty {
                            Text("(\(relationshipContexts[selectedRelationshipContext] ?? ""))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()
                    }

                    if !personalMessage.isEmpty {
                        HStack {
                            Text("\"\(personalMessage)\"")
                                .font(.body)
                                .foregroundStyle(.secondary)
                                .italic()
                                .lineLimit(3)

                            Spacer()
                        }
                        .padding(.top, 4)
                    }

                    if includeTraditionalBlessing {
                        HStack {
                            Text(getBlessingText())
                                .font(.caption)
                                .foregroundStyle(.orange)
                                .italic()

                            Spacer()
                        }
                        .padding(.top, 4)
                    }
                }
                .padding(16)
                .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    private func setupInitialValues() {
        // Initialize with contact's relationship if available
        selectedRelationshipContext = recipient.relationship.lowercased()

        // Default age group
        if selectedAgeGroup.isEmpty {
            selectedAgeGroup = "adult"
        }

        updateDesignSpec()
    }

    private func updateDesignSpec() {
        designSpec.personalMessage = personalMessage.isEmpty ? nil : personalMessage

        // Update target age group
        if !selectedAgeGroup.isEmpty {
            designSpec.targetAgeGroup = CulturalAgeGroup(
                id: selectedAgeGroup,
                displayName: ageGroups[selectedAgeGroup] ?? selectedAgeGroup,
                ageRange: ageGroups[selectedAgeGroup] ?? selectedAgeGroup,
                culturalContext: designSpec.culturalContext
            )
        }
    }

    private func getBlessingPreview() -> String {
        if includeTraditionalBlessing {
            return "A traditional \(terminologyService.getCurrentOccasion()?.displayName ?? "cultural") blessing will be included"
        } else {
            return "No traditional blessing will be added"
        }
    }

    private func getBlessingText() -> String {
        guard let occasion = terminologyService.getCurrentOccasion() else { return "" }

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

struct RelationshipButton: View {
    let key: String
    let displayName: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: getRelationshipIcon())
                    .font(.body)
                    .foregroundStyle(isSelected ? .white : .orange)

                Text(displayName)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(isSelected ? .white : .primary)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? .orange : Color(.systemGray6))
            )
        }
    }

    private func getRelationshipIcon() -> String {
        switch key {
        case "sibling": return "figure.2"
        case "parent": return "heart.fill"
        case "grandparent": return "heart.circle.fill"
        case "friend": return "person.2.fill"
        case "cousin": return "person.3.fill"
        case "mentor": return "graduationcap.fill"
        default: return "person.fill"
        }
    }
}

struct AgeGroupPill: View {
    let key: String
    let displayName: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(displayName.components(separatedBy: " (").first ?? displayName)
                .font(.caption.weight(.medium))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(isSelected ? .orange : Color(.systemGray6))
                )
                .foregroundStyle(isSelected ? .white : .primary)
        }
    }
}

#Preview {
    CulturalPersonalizationStep(
        designSpec: .constant(CulturalDesignSpec(
            culturalContext: "rakhi_indian",
            genre: CulturalGenre(id: "traditional", displayName: "Traditional", icon: "star", basePrompt: "traditional", culturalContext: "rakhi_indian"),
            colorPalette: CulturalColorPalette(id: "traditional", displayName: "Traditional", colors: [], culturalContext: "rakhi_indian"),
            targetAgeGroup: CulturalAgeGroup(id: "adult", displayName: "Adult", ageRange: "18-60", culturalContext: "rakhi_indian")
        )),
        recipient: Contact(name: "Sample Contact", phoneNumber: "", relationship: "Sister")
    )
}
