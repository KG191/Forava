import SwiftUI

struct CulturalGiftSelectionView: View {
    let selectedContact: Contact
    let selectedEvent: CulturalEvent

    @State private var selectedGift: CulturalGift?
    @State private var selectedCategory: CulturalGiftCategory = .traditional
    @State private var showingSendConfirmation = false
    @Environment(\.dismiss) private var dismiss

    private var availableGifts: [CulturalGift] {
        let culturalGifts = CulturalGift.gifts(for: selectedEvent.category)

        // If no gifts available for this culture, fall back to Rakhi gifts converted to CulturalGift
        if culturalGifts.isEmpty && selectedEvent.category == .hindu {
            return Rakhi.sampleRakhis.map { $0.toCulturalGift() }
        }

        return culturalGifts
    }

    private var filteredGifts: [CulturalGift] {
        availableGifts.filter { $0.category == selectedCategory }
    }

    private var availableCategories: [CulturalGiftCategory] {
        let categories = Set(availableGifts.map { $0.category })
        return CulturalGiftCategory.allCases.filter { categories.contains($0) }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header with cultural context
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: selectedEvent.category.icon)
                            .foregroundStyle(selectedEvent.category.primaryColor)

                        Text(selectedEvent.selectionTitle)
                            .font(.system(.title2, design: .rounded).weight(.bold))
                            .foregroundStyle(.primary)
                    }

                    Text("for \(selectedContact.name)")
                        .font(.system(.body, design: .rounded).weight(.medium))
                        .foregroundStyle(selectedEvent.category.primaryColor)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                // Cultural Context Description
                Text(selectedEvent.description)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.top, 8)

                // Category Selector
                if availableCategories.count > 1 {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(availableCategories, id: \.self) { category in
                                CulturalCategoryPill(
                                    category: category,
                                    isSelected: selectedCategory == category,
                                    culturalColor: selectedEvent.category.primaryColor
                                ) {
                                    withAnimation(.spring(response: 0.3)) {
                                        selectedCategory = category
                                        selectedGift = nil
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.top, 20)
                }

                // Gift Grid
                ScrollView {
                    if filteredGifts.isEmpty {
                        // Empty state
                        VStack(spacing: 20) {
                            Image(systemName: selectedEvent.category.icon)
                                .font(.system(size: 60))
                                .foregroundStyle(selectedEvent.category.primaryColor.opacity(0.6))

                            VStack(spacing: 8) {
                                Text("Coming Soon!")
                                    .font(.system(.title2, design: .rounded).weight(.bold))
                                    .foregroundStyle(.primary)

                                Text("\(selectedEvent.name) gifts are being carefully curated with cultural authenticity in mind.")
                                    .font(.system(.body, design: .rounded))
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .padding(.horizontal, 40)
                        .padding(.vertical, 60)
                    } else {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                            ForEach(filteredGifts) { gift in
                                CulturalGiftCard(
                                    gift: gift,
                                    isSelected: selectedGift?.id == gift.id,
                                    culturalColor: selectedEvent.category.primaryColor
                                ) {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        selectedGift = gift
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                    }
                }

                // Bottom Send Button
                if let selectedGift = selectedGift {
                    VStack(spacing: 16) {
                        // Selected Gift Summary
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selectedEvent.category.primaryColor.opacity(0.2))
                                    .frame(width: 60, height: 60)

                                // Placeholder icon since we don't have actual images
                                Image(systemName: selectedEvent.category.icon)
                                    .font(.system(size: 24))
                                    .foregroundStyle(selectedEvent.category.primaryColor)
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text(selectedGift.name)
                                    .font(.system(.body, design: .rounded).weight(.semibold))
                                    .foregroundStyle(.primary)
                                    .lineLimit(2)

                                Text("$\(selectedGift.price, specifier: "%.2f")")
                                    .font(.system(.subheadline, design: .rounded).weight(.medium))
                                    .foregroundStyle(selectedEvent.category.primaryColor)
                            }

                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))

                        // Continue Button - Use CulturalGiftDesignView (single routing source)
                        NavigationLink(destination: CulturalGiftDesignView(selectedContact: selectedContact, selectedEvent: selectedEvent)) {
                            HStack(spacing: 8) {
                                Image(systemName: "arrow.right.circle.fill")
                                Text("Continue with \(selectedGift.name)")
                            }
                            .font(.system(.body, design: .rounded).weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(selectedEvent.category.primaryColor, in: RoundedRectangle(cornerRadius: 18))
                            .foregroundStyle(.white)
                        }
                        .buttonStyle(.plain)
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
                    .foregroundStyle(selectedEvent.category.primaryColor)
                }
            }
        }
        .sheet(isPresented: $showingSendConfirmation) {
            if let selectedGift = selectedGift {
                CulturalGiftConfirmationView(
                    gift: selectedGift,
                    contact: selectedContact,
                    culturalEvent: selectedEvent
                )
            }
        }
        .onAppear {
            // Set default category to the first available
            if let firstCategory = availableCategories.first {
                selectedCategory = firstCategory
            }
        }
    }
}

struct CulturalCategoryPill: View {
    let category: CulturalGiftCategory
    let isSelected: Bool
    let culturalColor: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.system(.footnote, weight: .medium))

                Text(category.rawValue)
                    .font(.system(.footnote, design: .rounded).weight(.medium))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? culturalColor : Color(.systemGray5))
            )
            .foregroundStyle(isSelected ? .white : .primary)
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? .clear : culturalColor.opacity(0.3), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }
}

struct CulturalGiftCard: View {
    let gift: CulturalGift
    let isSelected: Bool
    let culturalColor: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Gift Placeholder
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.regularMaterial)
                        .frame(height: 160)

                    // Cultural icon placeholder
                    VStack(spacing: 8) {
                        Image(systemName: gift.category.icon)
                            .font(.system(size: 40))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [culturalColor, culturalColor.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        Text(gift.culturalContext.displayName)
                            .font(.system(.caption2, design: .rounded).weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(gift.name)
                        .font(.system(.subheadline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)

                    Text(gift.description)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)

                    HStack {
                        Text("$\(gift.price, specifier: "%.2f")")
                            .font(.system(.footnote, design: .rounded).weight(.bold))
                            .foregroundStyle(culturalColor)

                        Spacer()

                        // Cultural significance indicator
                        HStack(spacing: 2) {
                            ForEach(0..<Int(gift.culturalSignificance * 5), id: \.self) { _ in
                                Circle()
                                    .fill(culturalColor)
                                    .frame(width: 6, height: 6)
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
                    .stroke(isSelected ? culturalColor : .clear, lineWidth: 2)
            }
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .shadow(
                color: isSelected ? culturalColor.opacity(0.3) : .black.opacity(0.1),
                radius: isSelected ? 12 : 6,
                y: isSelected ? 8 : 3
            )
        }
        .buttonStyle(.plain)
    }
}

struct CulturalGiftConfirmationView: View {
    let gift: CulturalGift
    let contact: Contact
    let culturalEvent: CulturalEvent

    @State private var isLoading = false
    @State private var showingSuccess = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()

                // Gift Display
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        culturalEvent.category.primaryColor.opacity(0.2),
                                        culturalEvent.category.primaryColor.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 120, height: 120)

                        Image(systemName: culturalEvent.category.icon)
                            .font(.system(size: 60))
                            .foregroundStyle(culturalEvent.category.primaryColor)
                    }

                    VStack(spacing: 8) {
                        Text("Send \(gift.name)")
                            .font(.system(.title2, design: .rounded).weight(.bold))
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.center)

                        Text("to \(contact.name)")
                            .font(.system(.title3, design: .rounded).weight(.medium))
                            .foregroundStyle(culturalEvent.category.primaryColor)
                    }

                    Text("For \(culturalEvent.name)")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.secondary)
                }

                // Details
                VStack(spacing: 16) {
                    HStack {
                        Text("Gift:")
                        Spacer()
                        Text(gift.name)
                            .fontWeight(.medium)
                    }

                    HStack {
                        Text("Recipient:")
                        Spacer()
                        Text(contact.name)
                            .fontWeight(.medium)
                    }

                    HStack {
                        Text("Celebration:")
                        Spacer()
                        Text(culturalEvent.name)
                            .fontWeight(.medium)
                    }

                    HStack {
                        Text("Expected Payment:")
                        Spacer()
                        Text("$\(gift.price, specifier: "%.2f")")
                            .fontWeight(.bold)
                            .foregroundStyle(culturalEvent.category.primaryColor)
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

                            Text("\(culturalEvent.name) Gift Sent!")
                                .font(.system(.headline, design: .rounded).weight(.bold))
                                .foregroundStyle(.primary)

                            Text("They'll receive it as an Apple Watch face")
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .transition(.scale.combined(with: .opacity))
                    } else {
                        Button {
                            sendGift()
                        } label: {
                            HStack(spacing: 8) {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "paperplane.fill")
                                }

                                Text(isLoading ? "Sending..." : "Send \(culturalEvent.name) Gift")
                            }
                            .font(.system(.body, design: .rounded).weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(culturalEvent.category.primaryColor, in: RoundedRectangle(cornerRadius: 18))
                            .foregroundStyle(.white)
                        }
                        .buttonStyle(.plain)
                        .disabled(isLoading)
                    }

                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.system(.body, design: .rounded).weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
                    .foregroundStyle(culturalEvent.category.primaryColor)
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
                    .foregroundStyle(culturalEvent.category.primaryColor)
                }
            }
        }
    }

    private func sendGift() {
        isLoading = true

        // Simulate sending process
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isLoading = false
                showingSuccess = true
            }

            // Here you would integrate with WatchConnectivity
            // to send the gift to the recipient's Apple Watch

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                dismiss()
            }
        }
    }
}

// MARK: - Temporary Cultural Gift Design View
// ⚠️ DEPRECATED: This view is no longer used. Use CulturalGiftDesignView.swift instead.
// ⚠️ DO NOT ADD NEW CULTURES HERE - all routing should be in CulturalGiftDesignView.swift
@available(*, deprecated, message: "Use CulturalGiftDesignView instead")
struct TempCulturalGiftDesignView: View {
    let selectedContact: Contact
    let selectedEvent: CulturalEvent

    var body: some View {
        // Route to appropriate cultural design view
        switch selectedEvent.name.lowercased() {
        case "anniversary":
            AnniversaryDesignView(selectedContact: selectedContact, selectedEvent: selectedEvent)
        case "chinese new year":
            ChineseNewYearDesignView(selectedContact: selectedContact, selectedEvent: selectedEvent)
        case "diwali":
            DiwaliDesignView(selectedContact: selectedContact, selectedEvent: selectedEvent)
        case "vesak day":
            VesakDayDesignView(selectedContact: selectedContact, selectedEvent: selectedEvent)
        default:
            // Placeholder for other cultural events
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: selectedEvent.category.icon)
                        .font(.system(size: 60))
                        .foregroundStyle(selectedEvent.category.primaryColor)

                    Text("Creating \(selectedEvent.name) Gift")
                        .font(.system(.title, design: .rounded).weight(.bold))
                        .foregroundStyle(.primary)

                    Text("for \(selectedContact.name)")
                        .font(.system(.title2, design: .rounded).weight(.medium))
                        .foregroundStyle(selectedEvent.category.primaryColor)
                }

                // Status Message
                VStack(spacing: 16) {
                    Text("🎨 Cultural Design Studio")
                        .font(.system(.headline, design: .rounded).weight(.semibold))

                    Text("We're carefully crafting culturally authentic \(selectedEvent.name.lowercased()) gifts with AI-powered personalization.")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    Text("This feature is being enhanced to ensure cultural accuracy and authenticity.")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.tertiary)
                        .padding(.horizontal)
                }

                Spacer()

                // Back Button
                Button("Return to Gift Selection") {
                    // This would typically dismiss or navigate back
                }
                .font(.system(.body, design: .rounded).weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(selectedEvent.category.primaryColor.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))
                .foregroundStyle(selectedEvent.category.primaryColor)
            }
            .padding(32)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Cultural Design")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CulturalGiftSelectionView(
        selectedContact: Contact.sampleContacts[0],
        selectedEvent: CulturalEvent.allEvents[0]
    )
}
