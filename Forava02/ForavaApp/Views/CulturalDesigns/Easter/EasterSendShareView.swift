import SwiftUI
import Foundation
import Photos
import MessageUI

struct EasterSendShareView: View {
    let generatedImages: [String: String]
    let personalMessage: String
    let selectedContact: Contact
    let culturalColor: Color
    @Binding var showingShareSheet: Bool
    let onGoBackToGenerate: () -> Void

    @State private var selectedFormat: ImageFormat = .iPhone
    @State private var showingSaveAlert = false
    @State private var saveAlertMessage = ""
    @State private var showingMessageComposer = false
    @State private var downloadedImageForMessages: UIImage?

    enum ImageFormat: String, CaseIterable {
        case iPhone = "iPhone"
        case appleWatch = "Apple Watch"

        var displaySize: CGSize {
            switch self {
            case .iPhone:
                return CGSize(
                    width: CGFloat(CulturalAIConfiguration.iPhoneWidth),
                    height: CGFloat(CulturalAIConfiguration.iPhoneHeight)
                )
            case .appleWatch:
                return CGSize(
                    width: CGFloat(CulturalAIConfiguration.watchWidth),
                    height: CGFloat(CulturalAIConfiguration.watchHeight)
                )
            }
        }

        var aspectRatio: CGFloat {
            switch self {
            case .iPhone: return 1024.0/1792.0  // DALL-E 3 portrait (9:15.75)
            case .appleWatch: return 1.0        // Square for Apple Watch
            }
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header Section
                VStack(spacing: 12) {
                    Text("Share Your Gift")
                        .font(.system(.title2, design: .rounded).weight(.bold))
                        .foregroundStyle(.primary)

                    Text("Send your personalized Easter gift to \(selectedContact.name)")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)

                // Glass Morphism Content Container
                VStack(spacing: 20) {
                    if !generatedImages.isEmpty {
                        // Format Selector
                        formatSelector()

                        // Preview
                        imagePreview()

                        // Share Options
                        shareOptions()
                    } else {
                        emptyState()
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
        .alert("Save to Photos", isPresented: $showingSaveAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(saveAlertMessage)
        }
        .sheet(isPresented: $showingMessageComposer) {
            if let image = downloadedImageForMessages {
                MessageComposeView(image: image, recipientName: selectedContact.name, recipientPhone: selectedContact.phoneNumber)
            }
        }
    }

    @ViewBuilder
    private func formatSelector() -> some View {
        Picker("Format", selection: $selectedFormat) {
            ForEach(ImageFormat.allCases, id: \.self) { format in
                Text(format.rawValue).tag(format)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private func imagePreview() -> some View {
        let imageKey = selectedFormat.rawValue
        let imageURL = generatedImages[imageKey]

        VStack(spacing: 12) {
            // Image Display
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.secondarySystemBackground))
                    .aspectRatio(selectedFormat.aspectRatio, contentMode: .fit)

                if let urlString = imageURL {
                    ImageWithTextOverlay(
                        imageURL: urlString,
                        message: personalMessage,
                        imageSize: selectedFormat.displaySize,
                        culturalColor: culturalColor
                    )
                    .aspectRatio(selectedFormat.aspectRatio, contentMode: .fit)
                    .cornerRadius(16)
                }
            }
            .padding(.horizontal, 20)

            // Format Info
            Text("Format: \(selectedFormat.rawValue)")
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private func shareOptions() -> some View {
        VStack(spacing: 16) {
            // Share via iOS Share Sheet
            Button(action: {
                showingShareSheet = true
            }) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                        .font(.headline)

                    Text("Share Image")
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(culturalColor.gradient)
                )
                .foregroundStyle(.white)
            }
            .padding(.horizontal, 20)

            // Save to Photos
            Button(action: {
                saveToPhotos()
            }) {
                HStack {
                    Image(systemName: "square.and.arrow.down")
                        .font(.headline)

                    Text("Save to Photos")
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(culturalColor, lineWidth: 2)
                )
                .foregroundStyle(culturalColor)
            }
            .padding(.horizontal, 20)

            // Send via Messages (Placeholder)
            Button(action: {
                sendViaMessages()
            }) {
                HStack {
                    Image(systemName: "message.fill")
                        .font(.headline)

                    Text("Send via Messages")
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(culturalColor, lineWidth: 2)
                )
                .foregroundStyle(culturalColor)
            }
            .padding(.horizontal, 20)

            Divider()
                .padding(.vertical, 8)

            // Go Back to Generate
            Button(action: onGoBackToGenerate) {
                HStack {
                    Image(systemName: "arrow.left")
                        .font(.headline)

                    Text("Generate New Gift")
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(
                        colors: [Color(hex: "#FF8A00"), Color(hex: "#E05A00")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .foregroundStyle(.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.18), radius: 14, y: 8)
            }
            .padding(.horizontal, 20)
        }
    }

    @ViewBuilder
    private func emptyState() -> some View {
        VStack(spacing: 16) {
            Image(systemName: "paperplane")
                .font(.system(size: 60))
                .foregroundStyle(culturalColor.opacity(0.5))

            Text("No Gift to Share")
                .font(.system(.title3, design: .rounded).weight(.semibold))
                .foregroundStyle(.primary)

            Text("Generate a gift first to share it with \(selectedContact.name)")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button(action: onGoBackToGenerate) {
                Text("Go to Create")
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    .foregroundStyle(culturalColor)
            }
            .padding(.top, 8)
        }
        .padding(.vertical, 60)
    }

    // MARK: - Actions
    private func saveToPhotos() {
        guard let imageURL = generatedImages[selectedFormat.rawValue] else {
            saveAlertMessage = "No image available to save"
            showingSaveAlert = true
            return
        }

        // Download image from URL
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: URL(string: imageURL)!)
                guard let image = UIImage(data: data) else {
                    await MainActor.run {
                        saveAlertMessage = "Failed to load image"
                        showingSaveAlert = true
                    }
                    return
                }

                // Request permission and save
                let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)

                if status == .notDetermined {
                    let newStatus = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
                    if newStatus == .authorized || newStatus == .limited {
                        await saveImageToLibrary(image)
                    } else {
                        await MainActor.run {
                            saveAlertMessage = "Please allow photo library access in Settings"
                            showingSaveAlert = true
                        }
                    }
                } else if status == .authorized || status == .limited {
                    await saveImageToLibrary(image)
                } else {
                    await MainActor.run {
                        saveAlertMessage = "Please allow photo library access in Settings"
                        showingSaveAlert = true
                    }
                }
            } catch {
                await MainActor.run {
                    saveAlertMessage = "Failed to download image: \(error.localizedDescription)"
                    showingSaveAlert = true
                }
            }
        }
    }

    private func saveImageToLibrary(_ image: UIImage) async {
        do {
            try await PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }
            await MainActor.run {
                saveAlertMessage = "Image saved to Photos successfully!"
                showingSaveAlert = true
            }
        } catch {
            await MainActor.run {
                saveAlertMessage = "Failed to save image: \(error.localizedDescription)"
                showingSaveAlert = true
            }
        }
    }

    private func sendViaMessages() {
        guard MFMessageComposeViewController.canSendText() else {
            saveAlertMessage = "Messages is not available on this device"
            showingSaveAlert = true
            return
        }

        guard let imageURL = generatedImages[selectedFormat.rawValue] else {
            saveAlertMessage = "No image available to send"
            showingSaveAlert = true
            return
        }

        // Download image for Messages
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: URL(string: imageURL)!)
                guard let image = UIImage(data: data) else {
                    await MainActor.run {
                        saveAlertMessage = "Failed to load image"
                        showingSaveAlert = true
                    }
                    return
                }

                await MainActor.run {
                    downloadedImageForMessages = image
                    showingMessageComposer = true
                }
            } catch {
                await MainActor.run {
                    saveAlertMessage = "Failed to download image: \(error.localizedDescription)"
                    showingSaveAlert = true
                }
            }
        }
    }
}

// MARK: - Message Composer
struct MessageComposeView: UIViewControllerRepresentable {
    let image: UIImage
    let recipientName: String
    let recipientPhone: String
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let controller = MFMessageComposeViewController()
        controller.messageComposeDelegate = context.coordinator

        // Add recipient if phone number exists
        if !recipientPhone.isEmpty {
            controller.recipients = [recipientPhone]
        }

        // Attach image
        if let imageData = image.jpegData(compressionQuality: 0.9) {
            controller.addAttachmentData(imageData, typeIdentifier: "public.jpeg", filename: "easter-gift.jpg")
        }

        // Set message body
        controller.body = "I created this personalized gift for you! 🎁"

        return controller
    }

    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {
        // No updates needed
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        let parent: MessageComposeView

        init(_ parent: MessageComposeView) {
            self.parent = parent
        }

        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}



// MARK: - Message Composer
struct MessageComposeView: UIViewControllerRepresentable {
    let image: UIImage
    let recipientName: String
    let recipientPhone: String
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let controller = MFMessageComposeViewController()
        controller.messageComposeDelegate = context.coordinator

        // Add recipient if phone number exists
        if !recipientPhone.isEmpty {
            controller.recipients = [recipientPhone]
        }

        // Attach image
        if let imageData = image.jpegData(compressionQuality: 0.9) {
            controller.addAttachmentData(imageData, typeIdentifier: "public.jpeg", filename: "anniversary-gift.jpg")
        }

        // Set message body
        controller.body = "I created this personalized gift for you! 🎁"

        return controller
    }

    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {
        // No updates needed
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        let parent: MessageComposeView

        init(_ parent: MessageComposeView) {
            self.parent = parent
        }

        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    EasterSendShareView(
        generatedImages: [:],
        personalMessage: "中秋快樂! Wishing you a happy Easter",
        selectedContact: Contact(name: "Friend", phoneNumber: ""),
        culturalColor: Color(hex: "#FFD700"),
        showingShareSheet: .constant(false),
        onGoBackToGenerate: {}
    )
}
