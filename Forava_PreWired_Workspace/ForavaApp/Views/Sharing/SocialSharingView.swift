import SwiftUI
import MessageUI

struct SocialSharingView: View {
    let rakhi: GeneratedRakhi
    @StateObject private var sharingService = SocialSharingService.shared
    @State private var customMessage = ""
    @State private var selectedContacts: [Contact] = []
    @State private var showingContactPicker = false
    @State private var showingShareSheet = false
    @State private var shareResult: ShareResult?
    @State private var showingSuccessMessage = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    SharingHeaderView(rakhi: rakhi)

                    // Custom Message Section
                    CustomMessageSection(customMessage: $customMessage)

                    // Sharing Options
                    SharingOptionsGrid(
                        rakhi: rakhi,
                        customMessage: customMessage,
                        onShare: handleShare
                    )

                    // Contact Selection
                    ContactSelectionSection(
                        selectedContacts: $selectedContacts,
                        showingContactPicker: $showingContactPicker
                    )

                    // Cultural Sharing Guidelines
                    CulturalGuidelinesSection()

                    // Share History Preview
                    if !sharingService.shareHistory.isEmpty {
                        ShareHistoryPreview(history: sharingService.shareHistory)
                    }
                }
                .padding()
            }
            .navigationTitle("Share Your Rakhi")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Share") {
                        showingShareSheet = true
                    }
                    .fontWeight(.semibold)
                }
            }
            .sheet(isPresented: $showingContactPicker) {
                ContactPickerView(selectedContacts: $selectedContacts)
            }
            .sheet(isPresented: $showingShareSheet) {
                ActivityShareSheet(
                    rakhi: rakhi,
                    customMessage: customMessage.isEmpty ? nil : customMessage
                )
            }
            .alert("Shared Successfully!", isPresented: $showingSuccessMessage) {
                Button("OK") { }
            } message: {
                if let result = shareResult {
                    Text("Your Rakhi has been shared via \(result.platform.rawValue)")
                }
            }
        }
    }

    private func handleShare(method: ShareMethod) {
        Task {
            do {
                let result = try await sharingService.shareRakhi(
                    rakhi,
                    via: method,
                    to: selectedContacts,
                    withMessage: customMessage.isEmpty ? nil : customMessage
                )

                await MainActor.run {
                    shareResult = result
                    showingSuccessMessage = true
                }
            } catch {
                print("Sharing failed: \(error.localizedDescription)")
            }
        }
    }
}

struct SharingHeaderView: View {
    let rakhi: GeneratedRakhi

    var body: some View {
        VStack(spacing: 16) {
            // Rakhi Preview
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.regularMaterial)
                    .frame(width: 200, height: 200)

                VStack(spacing: 8) {
                    Image(systemName: "gift.circle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.orange, .red],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    Text("Your AI Rakhi")
                        .font(.system(.subheadline, design: .rounded).weight(.medium))
                        .foregroundStyle(.primary)
                }
            }

            // Rakhi Details
            VStack(spacing: 8) {
                Text("Created with AI & Love")
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)

                HStack(spacing: 16) {
                    DetailBadge(
                        icon: "star.fill",
                        text: "Cultural Score: \(rakhi.culturalScore, specifier: "%.1f")",
                        color: .green
                    )

                    DetailBadge(
                        icon: "paintbrush.pointed.fill",
                        text: rakhi.designSpec.genre.displayName,
                        color: .orange
                    )
                }
            }
        }
    }
}

struct DetailBadge: View {
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(.caption))
                .foregroundStyle(color)

            Text(text)
                .font(.system(.caption, design: .rounded).weight(.medium))
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(color.opacity(0.1), in: Capsule())
    }
}

struct CustomMessageSection: View {
    @Binding var customMessage: String
    @State private var isExpanded = false

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Label("Personal Message", systemImage: "text.quote")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                Spacer()

                Button {
                    withAnimation(.spring(response: 0.4)) {
                        isExpanded.toggle()
                    }
                } label: {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(.subheadline))
                        .foregroundStyle(.orange)
                }
            }

            if isExpanded {
                VStack(spacing: 12) {
                    TextField("Add your personal message...", text: $customMessage, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(3...6)

                    // Suggested messages
                    SuggestedMessagesView(customMessage: $customMessage)
                }
                .transition(.asymmetric(
                    insertion: .scale.combined(with: .opacity),
                    removal: .opacity
                ))
            }
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct SuggestedMessagesView: View {
    @Binding var customMessage: String

    private let suggestedMessages = [
        "🎊 Created this special Rakhi just for you!",
        "✨ A gift made with AI magic and lots of love",
        "🙏 May this Rakhi bring you joy and prosperity",
        "💝 Tradition meets technology in this beautiful creation"
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Suggested Messages:")
                .font(.system(.caption, design: .rounded).weight(.medium))
                .foregroundStyle(.secondary)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                ForEach(suggestedMessages, id: \.self) { message in
                    Button {
                        customMessage = message
                    } label: {
                        Text(message)
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.orange)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(.orange.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
                            .multilineTextAlignment(.leading)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

struct SharingOption {
    let method: ShareMethod
    let title: String
    let icon: String
    let color: Color
}

struct SharingOptionsGrid: View {
    let rakhi: GeneratedRakhi
    let customMessage: String
    let onShare: (ShareMethod) -> Void

    private let sharingOptions: [SharingOption] = [
        SharingOption(method: .whatsapp, title: "WhatsApp", icon: "logo.whatsapp", color: .green),
        SharingOption(method: .instagram, title: "Instagram", icon: "camera", color: .pink),
        SharingOption(method: .messages, title: "Messages", icon: "message.fill", color: .blue),
        SharingOption(method: .email, title: "Email", icon: "envelope.fill", color: .gray),
        SharingOption(method: .facebook, title: "Facebook", icon: "f.circle.fill", color: .blue),
        SharingOption(method: .twitter, title: "Twitter", icon: "bird.fill", color: .cyan)
    ]

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Label("Share Via", systemImage: "square.and.arrow.up")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                Spacer()
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                ForEach(Array(sharingOptions.enumerated()), id: \.offset) { _, option in
                    SharingOptionButton(
                        method: option.method,
                        title: option.title,
                        icon: option.icon,
                        color: option.color,
                        onTap: onShare
                    )
                }
            }
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct SharingOptionButton: View {
    let method: ShareMethod
    let title: String
    let icon: String
    let color: Color
    let onTap: (ShareMethod) -> Void

    @State private var isPressed = false

    var body: some View {
        Button {
            onTap(method)
        } label: {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(.title2))
                    .foregroundStyle(color)

                Text(title)
                    .font(.system(.caption, design: .rounded).weight(.medium))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(color.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(.plain)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        } perform: { }
    }
}

struct ContactSelectionSection: View {
    @Binding var selectedContacts: [Contact]
    @Binding var showingContactPicker: Bool

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Label("Recipients", systemImage: "person.2.fill")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                Spacer()

                Button("Add Contacts") {
                    showingContactPicker = true
                }
                .font(.system(.subheadline, design: .rounded).weight(.medium))
                .foregroundStyle(.orange)
            }

            if selectedContacts.isEmpty {
                ContactEmptyState()
            } else {
                ContactList(selectedContacts: $selectedContacts)
            }
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct ContactEmptyState: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.badge.plus")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)

            Text("No recipients selected")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.secondary)

            Text("Add contacts to share directly with them")
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
    }
}

struct ContactList: View {
    @Binding var selectedContacts: [Contact]

    var body: some View {
        LazyVStack(spacing: 8) {
            ForEach(selectedContacts) { contact in
                ContactRow(contact: contact) {
                    selectedContacts.removeAll { $0.id == contact.id }
                }
            }
        }
    }
}

struct ContactRow: View {
    let contact: Contact
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(.orange.opacity(0.2))
                .frame(width: 40, height: 40)
                .overlay {
                    Text(String(contact.name.prefix(1).uppercased()))
                        .font(.system(.subheadline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.orange)
                }

            VStack(alignment: .leading, spacing: 2) {
                Text(contact.name)
                    .font(.system(.subheadline, design: .rounded).weight(.medium))
                    .foregroundStyle(.primary)

                if !contact.phoneNumber.isEmpty {
                    Text(contact.phoneNumber)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            Button {
                onRemove()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(.title3))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 8))
    }
}

struct CulturalGuidelinesSection: View {
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Label("Cultural Guidelines", systemImage: "info.circle")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                Spacer()
            }

            VStack(alignment: .leading, spacing: 8) {
                GuidelineItem(
                    icon: "heart.fill",
                    text: "Share with love and respect for tradition",
                    color: .red
                )

                GuidelineItem(
                    icon: "shield.fill",
                    text: "Respect privacy when sharing others' creations",
                    color: .blue
                )

                GuidelineItem(
                    icon: "sparkles",
                    text: "Include cultural context when appropriate",
                    color: .orange
                )
            }
        }
        .padding(16)
        .background(.blue.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(.blue.opacity(0.2), lineWidth: 1)
        }
    }
}

struct GuidelineItem: View {
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(.caption))
                .foregroundStyle(color)
                .frame(width: 16)

            Text(text)
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(.primary)

            Spacer()
        }
    }
}

struct ShareHistoryPreview: View {
    let history: [ShareRecord]

    var recentShares: [ShareRecord] {
        Array(history.suffix(3))
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Label("Recent Shares", systemImage: "clock.arrow.circlepath")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                Spacer()

                NavigationLink("View All") {
                    ShareHistoryView(history: history)
                }
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.orange)
            }

            LazyVStack(spacing: 8) {
                ForEach(recentShares) { share in
                    ShareHistoryRow(share: share)
                }
            }
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct ShareHistoryRow: View {
    let share: ShareRecord

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(share.success ? .green.opacity(0.2) : .red.opacity(0.2))
                .frame(width: 32, height: 32)
                .overlay {
                    Image(systemName: share.success ? "checkmark" : "xmark")
                        .font(.system(.caption))
                        .foregroundStyle(share.success ? .green : .red)
                }

            VStack(alignment: .leading, spacing: 2) {
                Text(share.platform.rawValue)
                    .font(.system(.subheadline, design: .rounded).weight(.medium))
                    .foregroundStyle(.primary)

                Text(share.timestamp, style: .relative)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text("✨ \(share.culturalScore, specifier: "%.1f")")
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(.orange)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Supporting Views

struct ContactPickerView: View {
    @Binding var selectedContacts: [Contact]
    @Environment(\.dismiss) private var dismiss

    // Sample contacts for demo
    private let availableContacts = [
        Contact(name: "Priya Sharma", phoneNumber: "+91 98765 43210"),
        Contact(name: "Rahul Kumar", phoneNumber: "+91 87654 32109"),
        Contact(name: "Anita Gupta", phoneNumber: "+91 76543 21098"),
        Contact(name: "Vikram Singh", phoneNumber: "+91 65432 10987")
    ]

    var body: some View {
        NavigationStack {
            List {
                ForEach(availableContacts) { contact in
                    ContactPickerRow(
                        contact: contact,
                        isSelected: selectedContacts.contains { $0.id == contact.id }
                    ) { isSelected in
                        if isSelected {
                            selectedContacts.append(contact)
                        } else {
                            selectedContacts.removeAll { $0.id == contact.id }
                        }
                    }
                }
            }
            .navigationTitle("Select Contacts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ContactPickerRow: View {
    let contact: Contact
    let isSelected: Bool
    let onToggle: (Bool) -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(contact.name)
                    .font(.system(.body, design: .rounded))

                if !contact.phoneNumber.isEmpty {
                    Text(contact.phoneNumber)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            Button {
                onToggle(!isSelected)
            } label: {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(.title3))
                    .foregroundStyle(isSelected ? .orange : .secondary)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onToggle(!isSelected)
        }
    }
}

struct ActivityShareSheet: UIViewControllerRepresentable {
    let rakhi: GeneratedRakhi
    let customMessage: String?

    func makeUIViewController(context: Context) -> UIActivityViewController {
        Task {
            try await SocialSharingService.shared.shareViaActivityViewController(
                rakhi,
                from: UIApplication.shared.windows.first?.rootViewController ?? UIViewController(),
                customMessage: customMessage
            )
        }

        // Return placeholder - actual implementation would be different
        return UIActivityViewController(activityItems: [], applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No updates needed
    }
}

struct ShareHistoryView: View {
    let history: [ShareRecord]

    var body: some View {
        List {
            ForEach(history) { share in
                ShareHistoryDetailRow(share: share)
            }
        }
        .navigationTitle("Share History")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ShareHistoryDetailRow: View {
    let share: ShareRecord

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(share.platform.rawValue)
                    .font(.system(.headline, design: .rounded))

                Spacer()

                Image(systemName: share.success ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundStyle(share.success ? .green : .red)
            }

            Text(share.timestamp, style: .date)
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    SocialSharingView(
        rakhi: GeneratedRakhi(
            id: UUID(),
            designSpec: RakhiDesignSpec(genre: .traditional),
            mainImage: AIImageResult(
                imageURL: "test://image.jpg",
                metadata: GenerationMetadata(
                    seed: 12345,
                    cfg_scale: 7.5,
                    steps: 30,
                    model: "sdxl_base_1.0",
                    timestamp: Date()
                ),
                processingTime: 1.0
            ),
            animationFrames: [],
            prompt: AIPrompt(
                positive: "traditional rakhi",
                negative: "blurry",
                cfg_scale: 7.5,
                steps: 30,
                seed: 12345,
                width: 1024,
                height: 1024
            ),
            createdAt: Date(),
            culturalScore: 0.8,
            qualityScore: 0.9
        )
    )
}
