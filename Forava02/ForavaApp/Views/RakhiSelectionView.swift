import SwiftUI

struct RakhiSelectionView: View {
    let selectedContact: Contact
    let selectedEvent: CulturalEvent?
    @State private var selectedRakhi: Rakhi?
    @State private var selectedCategory: RakhiCategory = .traditional
    @State private var showingSendConfirmation = false
    @Environment(\.dismiss) private var dismiss

    init(selectedContact: Contact, selectedEvent: CulturalEvent? = nil) {
        self.selectedContact = selectedContact
        self.selectedEvent = selectedEvent
    }

    var filteredRakhis: [Rakhi] {
        Rakhi.sampleRakhis.filter { $0.category == selectedCategory }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    Text(selectedEvent?.selectionTitle ?? "Choose a Gift")
                        .font(.system(.title2, design: .rounded).weight(.bold))
                        .foregroundStyle(.primary)

                    Text("for \(selectedContact.name)")
                        .font(.system(.body, design: .rounded).weight(.medium))
                        .foregroundStyle(selectedEvent?.category.primaryColor ?? .orange)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                // Category Selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(RakhiCategory.allCases, id: \.self) { category in
                            CategoryPill(
                                category: category,
                                isSelected: selectedCategory == category
                            ) {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedCategory = category
                                    selectedRakhi = nil
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.top, 20)

                // Rakhi Grid
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                        ForEach(filteredRakhis) { rakhi in
                            RakhiCard(
                                rakhi: rakhi,
                                isSelected: selectedRakhi?.id == rakhi.id
                            ) {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    selectedRakhi = rakhi
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                }

                // Bottom Send Button
                if let selectedRakhi = selectedRakhi {
                    VStack(spacing: 16) {
                        // Selected Rakhi Summary
                        HStack(spacing: 12) {
                            Image(selectedRakhi.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))

                            VStack(alignment: .leading, spacing: 4) {
                                Text(selectedRakhi.name)
                                    .font(.system(.body, design: .rounded).weight(.semibold))
                                    .foregroundStyle(.primary)

                                Text("$\(selectedRakhi.price, specifier: "%.2f")")
                                    .font(.system(.subheadline, design: .rounded).weight(.medium))
                                    .foregroundStyle(.orange)
                            }

                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))

                        // Send Button
                        Button {
                            showingSendConfirmation = true
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "paperplane.fill")
                                Text("Send to \(selectedContact.name)")
                            }
                            .font(.system(.body, design: .rounded).weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                        }
                        .buttonStyle(ForavaPrimaryButtonStyle())
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                    .background(
                        LinearGradient(
                            colors: [.clear, Color(.systemBackground).opacity(0.9)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                    .foregroundStyle(.orange)
                }
            }
        }
        .sheet(isPresented: $showingSendConfirmation) {
            if let selectedRakhi = selectedRakhi {
                SendConfirmationView(
                    rakhi: selectedRakhi,
                    contact: selectedContact
                )
            }
        }
    }
}

struct CategoryPill: View {
    let category: RakhiCategory
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                Image(systemName: "circle.fill")
                    .font(.system(.footnote, weight: .medium))

                Text(category.rawValue)
                    .font(.system(.footnote, design: .rounded).weight(.medium))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? .orange : Color(.systemGray5))
            )
            .foregroundStyle(isSelected ? .white : .primary)
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? .clear : .orange.opacity(0.3), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }
}

struct RakhiCard: View {
    let rakhi: Rakhi
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Rakhi Image
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.regularMaterial)
                        .frame(height: 160)

                    // Placeholder for now - will be replaced with actual images
                    Image(systemName: "circle.badge.checkmark.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.orange, .red.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(rakhi.name)
                        .font(.system(.subheadline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)

                    Text(rakhi.description)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)

                    HStack {
                        Text("$\(rakhi.price, specifier: "%.2f")")
                            .font(.system(.footnote, design: .rounded).weight(.bold))
                            .foregroundStyle(.orange)

                        Spacer()

                        // Color indicators
                        HStack(spacing: 4) {
                            ForEach(rakhi.colors.prefix(3), id: \.self) { colorName in
                                Circle()
                                    .fill(colorFromName(colorName))
                                    .frame(width: 8, height: 8)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(16)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? .orange : .clear, lineWidth: 2)
            }
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .shadow(color: isSelected ? .orange.opacity(0.3) : .black.opacity(0.1), radius: isSelected ? 12 : 6, y: isSelected ? 8 : 3)
        }
        .buttonStyle(.plain)
    }

    private func colorFromName(_ name: String) -> Color {
        switch name.lowercased() {
        case "gold": return .yellow
        case "silver": return .gray
        case "red": return .red
        case "blue": return .blue
        case "white": return .white
        case "orange": return .orange
        case "black": return .black
        case "pink": return .pink
        case "saffron": return .orange
        case "yellow": return .yellow
        case "pearl": return .white
        default: return .gray
        }
    }
}

struct SendConfirmationView: View {
    let rakhi: Rakhi
    let contact: Contact
    @State private var isLoading = false
    @State private var showingSuccess = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()

                // Rakhi Display
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.orange.opacity(0.2), .red.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 120, height: 120)

                        Image(systemName: "gift.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.orange)
                    }

                    VStack(spacing: 8) {
                        Text("Send \(rakhi.name)")
                            .font(.system(.title2, design: .rounded).weight(.bold))
                            .foregroundStyle(.primary)

                        Text("to \(contact.name)")
                            .font(.system(.title3, design: .rounded).weight(.medium))
                            .foregroundStyle(.orange)
                    }
                }

                // Details
                VStack(spacing: 16) {
                    HStack {
                        Text("Rakhi:")
                        Spacer()
                        Text(rakhi.name)
                            .fontWeight(.medium)
                    }

                    HStack {
                        Text("Recipient:")
                        Spacer()
                        Text(contact.name)
                            .fontWeight(.medium)
                    }

                    HStack {
                        Text("Expected Payment:")
                        Spacer()
                        Text("$\(rakhi.price, specifier: "%.2f")")
                            .fontWeight(.bold)
                            .foregroundStyle(.orange)
                    }
                }
                .font(.system(.body, design: .rounded))
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))

                Spacer()

                // Action Buttons
                VStack(spacing: 16) {
                    if showingSuccess {
                        VStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(.green)

                            Text("Rakhi Sent Successfully!")
                                .font(.system(.headline, design: .rounded).weight(.bold))
                                .foregroundStyle(.primary)

                            Text("They'll receive it as an Apple Watch face")
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundStyle(.secondary)
                        }
                        .transition(.scale.combined(with: .opacity))
                    } else {
                        Button {
                            sendRakhi()
                        } label: {
                            HStack(spacing: 8) {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "paperplane.fill")
                                }

                                Text(isLoading ? "Sending..." : "Send Rakhi")
                            }
                            .font(.system(.body, design: .rounded).weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                        }
                        .buttonStyle(ForavaPrimaryButtonStyle())
                        .disabled(isLoading)
                    }

                    Button("Cancel") {
                        dismiss()
                    }
                    .buttonStyle(ForavaSecondaryButtonStyle())
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(.orange)
                }
            }
        }
    }

    private func sendRakhi() {
        isLoading = true

        // Simulate sending process
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isLoading = false
                showingSuccess = true
            }

            // Here you would integrate with WatchConnectivity
            // to send the rakhi to the recipient's Apple Watch

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                dismiss()
            }
        }
    }
}

#Preview {
    RakhiSelectionView(selectedContact: Contact.sampleContacts[0])
}
