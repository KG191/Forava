import SwiftUI
import Foundation
import MessageUI
import Photos

struct AnniversarySendShareView: View {
    let generatedImages: [String: String]  // Keys: "iPhone", "AppleWatch"
    let personalMessage: String
    let selectedContact: Contact
    let culturalColor: Color
    @Binding var showingShareSheet: Bool

    @State private var showingMessageComposer = false
    @State private var showingSaveConfirmation = false
    @State private var saveStatus: SaveStatus = .none
    @State private var shareMethod: ShareMethod?

    private var hasGeneratedImages: Bool {
        !generatedImages.isEmpty
    }

    enum ShareMethod: String, CaseIterable {
        case messages = "Messages"
        case mail = "Email"
        case photos = "Save to Photos"
        case socialMedia = "Social Media"
        case airdrop = "AirDrop"

        var icon: String {
            switch self {
            case .messages: return "message.fill"
            case .mail: return "envelope.fill"
            case .photos: return "photo.fill"
            case .socialMedia: return "square.and.arrow.up.fill"
            case .airdrop: return "wifi.circle.fill"
            }
        }

        var color: Color {
            switch self {
            case .messages: return .green
            case .mail: return .blue
            case .photos: return .purple
            case .socialMedia: return .orange
            case .airdrop: return .cyan
            }
        }
    }

    enum SaveStatus: Equatable {
        case none
        case saving
        case success
        case failed(String)

        var message: String {
            switch self {
            case .none: return ""
            case .saving: return "Saving to Photos..."
            case .success: return "Saved to Photos successfully!"
            case .failed(let error): return "Failed to save: \(error)"
            }
        }

        var isSuccess: Bool {
            if case .success = self { return true }
            return false
        }

        var isError: Bool {
            if case .failed = self { return true }
            return false
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header Section
                VStack(spacing: 12) {
                    Text("Send Your Anniversary Gift")
                        .font(.system(.title2, design: .rounded).weight(.bold))
                        .foregroundStyle(.primary)

                    Text("Share your personalized anniversary design with \(selectedContact.name)")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)

                // Glass Morphism Content Container
                VStack(spacing: 24) {
                    if hasGeneratedImages {
                        // Image Preview
                        imagePreviewSection()

                        // Sharing Options
                        sharingOptionsSection()

                        // Contact Information
                        contactInfoSection()

                        // Delivery Status
                        if saveStatus != .none {
                            deliveryStatusSection()
                        }
                    } else {
                        // No Image Available
                        noImageSection()
                    }
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
        .sheet(isPresented: $showingMessageComposer) {
            if MFMessageComposeViewController.canSendText() {
                MessageComposeView(
                    recipient: selectedContact.phoneNumber,
                    images: generatedImages
                )
            } else {
                Text("Messages not available")
            }
        }
        .alert("Save Status", isPresented: $showingSaveConfirmation) {
            Button("OK") {
                saveStatus = .none
            }
        } message: {
            Text(saveStatus.message)
        }
    }

    @ViewBuilder
    private func imagePreviewSection() -> some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "photo.circle.fill")
                    .foregroundStyle(culturalColor)
                Text("Your Anniversary Gift")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                Spacer()
            }

            // Image Preview Card
            RoundedRectangle(cornerRadius: 16)
                .fill(culturalColor.opacity(0.12))
                .aspectRatio(1.0, contentMode: .fit)
                .frame(maxHeight: 200)
                .overlay(
                    VStack(spacing: 12) {
                        Image(systemName: "heart.circle.fill")
                            .font(.system(.largeTitle))
                            .foregroundStyle(culturalColor)

                        Text("Anniversary Design")
                            .font(.system(.headline, design: .rounded).weight(.semibold))
                            .foregroundStyle(.primary)

                        Text("Ready to share with \(selectedContact.name)")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                )
        }
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private func sharingOptionsSection() -> some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "square.and.arrow.up.circle.fill")
                    .foregroundStyle(culturalColor)
                Text("Sharing Options")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                Spacer()
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(ShareMethod.allCases, id: \.self) { method in
                    shareMethodCard(method: method)
                }
            }
        }
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private func shareMethodCard(method: ShareMethod) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                shareMethod = method
                handleShare(method: method)
            }
        } label: {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(method.color.opacity(0.2))
                        .frame(width: 50, height: 50)

                    Image(systemName: method.icon)
                        .font(.title2)
                        .foregroundStyle(method.color)
                }

                Text(method.rawValue)
                    .font(.system(.caption, design: .rounded).weight(.medium))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(culturalColor.opacity(0.10))
            )
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func contactInfoSection() -> some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .foregroundStyle(culturalColor)
                Text("Recipient")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                Spacer()
            }

            HStack(spacing: 16) {
                Circle()
                    .fill(culturalColor.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text(String(selectedContact.name.prefix(1)).uppercased())
                            .font(.system(.title2, design: .rounded).weight(.bold))
                            .foregroundStyle(culturalColor)
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(selectedContact.name)
                        .font(.system(.subheadline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)

                    if !selectedContact.phoneNumber.isEmpty {
                        Text(selectedContact.phoneNumber)
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.secondary)
                    }

                    if let relationship = selectedContact.relationship {
                        Text(relationship)
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(culturalColor)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(culturalColor.opacity(0.1))
                            .cornerRadius(4)
                    }
                }

                Spacer()
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
    private func deliveryStatusSection() -> some View {
        VStack(spacing: 12) {
            HStack {
                let iconName = saveStatus.isSuccess ? "checkmark.circle.fill" :
                    saveStatus.isError ? "xmark.circle.fill" : "clock.circle.fill"
                Image(systemName: iconName)
                    .foregroundStyle(saveStatus.isSuccess ? .green : saveStatus.isError ? .red : .orange)

                Text("Delivery Status")
                    .font(.system(.headline, design: .rounded).weight(.semibold))

                Spacer()
            }

            HStack {
                Text(saveStatus.message)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(saveStatus.isSuccess ? .green : saveStatus.isError ? .red : .primary)
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill((saveStatus.isSuccess ? Color.green : saveStatus.isError ? Color.red : Color.orange).opacity(0.1))
        )
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private func noImageSection() -> some View {
        VStack(spacing: 16) {
            Image(systemName: "photo.badge.plus")
                .font(.system(.largeTitle))
                .foregroundStyle(.secondary)

            Text("No Image to Share")
                .font(.system(.headline, design: .rounded).weight(.semibold))
                .foregroundStyle(.secondary)

            Text("Generate your anniversary gift first before sharing")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button("Go Back to Generate") {
                // This would be handled by the parent view
            }
            .font(.system(.subheadline, design: .rounded).weight(.medium))
            .foregroundStyle(culturalColor)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(culturalColor.opacity(0.1))
            .cornerRadius(8)
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
    }

    // MARK: - Sharing Functions
    private func handleShare(method: ShareMethod) {
        switch method {
        case .messages:
            if MFMessageComposeViewController.canSendText() {
                showingMessageComposer = true
            }
        case .mail:
            // Handle email sharing
            shareViaEmail()
        case .photos:
            saveToPhotos()
        case .socialMedia:
            shareViaActivitySheet()
        case .airdrop:
            shareViaActivitySheet()
        }
    }

    private func shareViaEmail() {
        // Email sharing implementation would go here
        print("📧 Sharing via email to \(selectedContact.email ?? "unknown email")")
    }

    private func saveToPhotos() {
        saveStatus = .saving

        // Simulate save operation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // In real implementation, this would actually save the image
            if Bool.random() { // Simulate success/failure
                saveStatus = .success
                showingSaveConfirmation = true
            } else {
                saveStatus = .failed("Permission denied")
                showingSaveConfirmation = true
            }
        }
    }

    private func shareViaActivitySheet() {
        showingShareSheet = true
    }
}

// MARK: - Message Composer
struct MessageComposeView: UIViewControllerRepresentable {
    let recipient: String
    let images: [String: String]

    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let composer = MFMessageComposeViewController()
        composer.recipients = [recipient]
        composer.body = "Happy Anniversary! I created this special gift for you. 💕"
        composer.messageComposeDelegate = context.coordinator
        // TODO: Attach actual generated images with text overlay
        return composer
    }

    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        func messageComposeViewController(
            _ controller: MFMessageComposeViewController,
            didFinishWith result: MessageComposeResult
        ) {
            controller.dismiss(animated: true)
        }
    }
}

#Preview {
    AnniversarySendShareView(
        generatedImages: ["iPhone": "sample_image_url", "AppleWatch": "sample_watch_url"],
        personalMessage: "Happy 10th Anniversary!",
        selectedContact: Contact(name: "Sarah Johnson", phoneNumber: "+1-555-0123", relationship: "Partner"),
        culturalColor: Color(hex: "#DC143C"),
        showingShareSheet: .constant(false)
    )
}
