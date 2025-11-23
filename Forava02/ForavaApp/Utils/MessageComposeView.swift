import SwiftUI
import MessageUI

/// Shared MessageComposeView for all cultural SendShareView files
/// Wraps MFMessageComposeViewController for SwiftUI integration
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
            controller.addAttachmentData(imageData, typeIdentifier: "public.jpeg", filename: "cultural-gift.jpg")
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
