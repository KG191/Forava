import SwiftUI

struct PersonalizationStep: View {
    @Binding var designSpec: RakhiDesignSpec
    let recipient: Contact
    @State private var personalMessage: String = ""
    @State private var estimatedAge: Int = 25

    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Text("Personal Touch")
                    .font(.system(.title3, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)

                Text("Add meaningful details for \(recipient.name)")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            VStack(spacing: 20) {
                // Age Group Selection
                AgeGroupSelector(designSpec: $designSpec, estimatedAge: $estimatedAge)

                // Personal Message
                PersonalMessageEditor(designSpec: $designSpec, personalMessage: $personalMessage)

                // Relationship Context
                RelationshipContext(recipient: recipient)
            }
        }
        .onAppear {
            personalMessage = designSpec.personalMessage ?? ""
        }
        .onChange(of: personalMessage) { _, newValue in
            designSpec.personalMessage = newValue.isEmpty ? nil : newValue
        }
    }
}

struct AgeGroupSelector: View {
    @Binding var designSpec: RakhiDesignSpec
    @Binding var estimatedAge: Int

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "person.fill")
                    .foregroundStyle(.orange)

                Text("Age Group")
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                Spacer()
            }

            // Age Slider
            VStack(spacing: 12) {
                HStack {
                    Text("Estimated Age: \(estimatedAge)")
                        .font(.system(.body, design: .rounded).weight(.medium))
                        .foregroundStyle(.primary)

                    Spacer()

                    Text(getAgeGroupFromAge(estimatedAge).rawValue)
                        .font(.system(.subheadline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.orange)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(.orange.opacity(0.1), in: Capsule())
                }

                Slider(value: Binding(
                    get: { Double(estimatedAge) },
                    set: { estimatedAge = Int($0) }
                ), in: 5...80, step: 1)
                .tint(.orange)
            }

            // Age Group Cards
            HStack(spacing: 12) {
                ForEach(AgeGroup.allCases.filter { $0 != .any }, id: \.self) { ageGroup in
                    AgeGroupCard(
                        ageGroup: ageGroup,
                        isSelected: designSpec.targetAgeGroup == ageGroup
                    ) {
                        withAnimation(.spring(response: 0.3)) {
                            designSpec.targetAgeGroup = ageGroup
                            updateEstimatedAge(for: ageGroup)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
        .onAppear {
            designSpec.targetAgeGroup = getAgeGroupFromAge(estimatedAge)
        }
        .onChange(of: estimatedAge) { _, newAge in
            designSpec.targetAgeGroup = getAgeGroupFromAge(newAge)
        }
    }

    private func getAgeGroupFromAge(_ age: Int) -> AgeGroup {
        switch age {
        case 5...17: return .young
        case 18...49: return .adult
        case 50...: return .elder
        default: return .adult
        }
    }

    private func updateEstimatedAge(for ageGroup: AgeGroup) {
        switch ageGroup {
        case .young: estimatedAge = 12
        case .adult: estimatedAge = 30
        case .elder: estimatedAge = 60
        case .any: estimatedAge = 25
        }
    }
}

struct AgeGroupCard: View {
    let ageGroup: AgeGroup
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Image(systemName: getAgeGroupIcon())
                    .font(.system(.title2))
                    .foregroundStyle(isSelected ? .orange : .primary)

                Text(ageGroup.rawValue)
                    .font(.system(.caption, design: .rounded).weight(.semibold))
                    .foregroundStyle(isSelected ? .orange : .primary)

                Text(ageGroup.ageRange)
                    .font(.system(.caption2, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? .orange.opacity(0.1) : Color(.systemGray6))
            )
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? .orange : .clear, lineWidth: 1.5)
            }
        }
        .buttonStyle(.plain)
    }

    private func getAgeGroupIcon() -> String {
        switch ageGroup {
        case .young: return "figure.child"
        case .adult: return "person.fill"
        case .elder: return "figure.walk"
        case .any: return "person.3.fill"
        }
    }
}

struct PersonalMessageEditor: View {
    @Binding var designSpec: RakhiDesignSpec
    @Binding var personalMessage: String
    @FocusState private var isMessageFocused: Bool

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "heart.text.square.fill")
                    .foregroundStyle(.orange)

                Text("Personal Message (Optional)")
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                Spacer()

                Text("\(personalMessage.count)/100")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
            }

            VStack(alignment: .leading, spacing: 8) {
                TextField("Express your feelings in words...", text: $personalMessage, axis: .vertical)
                    .textFieldStyle(.plain)
                    .font(.system(.body, design: .rounded))
                    .focused($isMessageFocused)
                    .lineLimit(4, reservesSpace: true)
                    .onChange(of: personalMessage) { _, newValue in
                        if newValue.count > 100 {
                            personalMessage = String(newValue.prefix(100))
                        }
                    }

                // Suggested Messages
                if personalMessage.isEmpty && !isMessageFocused {
                    SuggestedMessages { message in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            personalMessage = message
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isMessageFocused ? .orange : .clear, lineWidth: 1.5)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

struct SuggestedMessages: View {
    let onMessageSelected: (String) -> Void

    private let suggestions = [
        "Wishing you happiness and prosperity! 🌟",
        "You mean the world to me ❤️",
        "May our bond grow stronger each day 🤗",
        "Blessed to have you in my life 🙏",
        "Always here for you, no matter what 💝"
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Suggestions:")
                .font(.system(.caption, design: .rounded).weight(.medium))
                .foregroundStyle(.secondary)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 6) {
                ForEach(suggestions, id: \.self) { suggestion in
                    Button(suggestion) {
                        onMessageSelected(suggestion)
                    }
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.orange)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.orange.opacity(0.1), in: Capsule())
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

struct RelationshipContext: View {
    let recipient: Contact

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "heart.circle.fill")
                    .foregroundStyle(.orange)

                Text("Relationship Context")
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                Spacer()
            }

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Sending to:")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)

                    Spacer()

                    Text(recipient.name)
                        .font(.system(.body, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)
                }

                if let relationship = getRelationshipHint(for: recipient.name) {
                    HStack {
                        Text("Relationship:")
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(.secondary)

                        Spacer()

                        Text(relationship)
                            .font(.system(.body, design: .rounded).weight(.medium))
                            .foregroundStyle(.orange)
                    }
                }

                Rectangle()
                    .fill(.orange.opacity(0.2))
                    .frame(height: 1)

                Text("💡 This information helps create a more meaningful and culturally appropriate Rakhi design.")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private func getRelationshipHint(for name: String) -> String? {
        // Simple heuristic based on name patterns
        // In a real app, this could be more sophisticated
        let commonBrotherNames = ["Arjun", "Raj", "Dev", "Amit", "Rohan", "Kiran"]
        let commonSisterNames = ["Priya", "Shreya", "Anaya", "Kavya", "Diya"]

        if commonBrotherNames.contains(where: { name.contains($0) }) {
            return "Brother"
        } else if commonSisterNames.contains(where: { name.contains($0) }) {
            return "Sister (Rakhi exchange)"
        } else {
            return "Family/Friend"
        }
    }
}

#Preview {
    PersonalizationStep(
        designSpec: .constant(RakhiDesignSpec()),
        recipient: Contact.sampleContacts[0]
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}
