import SwiftUI
import MessageUI

// MARK: - Connect Tab Message Composer
struct ConnectMessageComposeView: UIViewControllerRepresentable {
    let recipients: [String]
    let body: String
    @Binding var result: MessageComposeResult?

    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let controller = MFMessageComposeViewController()
        controller.recipients = recipients
        controller.body = body
        controller.messageComposeDelegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(result: $result)
    }

    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        @Binding var result: MessageComposeResult?

        init(result: Binding<MessageComposeResult?>) {
            _result = result
        }

        func messageComposeViewController(
            _ controller: MFMessageComposeViewController,
            didFinishWith result: MessageComposeResult
        ) {
            self.result = result
            controller.dismiss(animated: true)
        }
    }
}

// MARK: - Connect Tab Voucher Selection Sheet
struct ConnectVoucherSelectionSheet: View {
    let culturalColor: Color
    let onProviderSelected: (VoucherProvider) -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VoucherProviderGrid(
                culturalColor: culturalColor,
                onProviderSelected: onProviderSelected
            )
            .navigationTitle("Select Gift Voucher")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundStyle(culturalColor)
                }
            }
        }
    }
}
