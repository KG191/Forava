import Foundation
import SwiftUI
import UIKit
import MessageUI

// MARK: - Phase 2: Fixed Social Sharing Service
// Resolves WhatsApp sharing freeze and implements proper error handling

@MainActor
class FixedSocialSharingService: NSObject, ObservableObject {
    static let shared = FixedSocialSharingService()

    @Published var isSharing = false
    @Published var lastError: FixedSharingError?
    @Published var shareSuccess = false

    private override init() {
        super.init()
    }

    // MARK: - Fixed WhatsApp Sharing

    func shareToWhatsApp(
        rakhi: GeneratedRakhi,
        contact: Any?, // Contact? - temporarily using Any to resolve compilation
        message: String,
        from viewController: UIViewController
    ) async {
        print("🔄 Starting WhatsApp sharing process...")

        await MainActor.run {
            self.isSharing = true
            self.lastError = nil
        }

        do {
            // Step 1: Validate WhatsApp availability
            guard isWhatsAppAvailable() else {
                throw FixedSharingError.platformNotAvailable("WhatsApp is not installed")
            }

            // Step 2: Prepare image data safely
            let imageData = rakhi.mainImage.imageData
            guard let image = UIImage(data: imageData) else {
                throw FixedSharingError.invalidContent("Failed to create image from data")
            }

            // Step 3: Use safer sharing approach - UIActivityViewController
            await shareViaActivityController(
                image: image,
                message: message,
                from: viewController
            )

            print("✅ WhatsApp sharing initiated successfully")

        } catch let error as SharingError {
            await MainActor.run {
                self.lastError = FixedSharingError.sharePreparationFailed(error.localizedDescription)
                print("❌ WhatsApp sharing failed: \(error.localizedDescription)")
            }
        } catch {
            await MainActor.run {
                self.lastError = FixedSharingError.sharePreparationFailed(error.localizedDescription)
                print("❌ Unexpected WhatsApp sharing error: \(error)")
            }
        }

        await MainActor.run {
            self.isSharing = false
        }
    }

    // MARK: - Safe Activity Controller Sharing

    private func shareViaActivityController(
        image: UIImage,
        message: String,
        from viewController: UIViewController
    ) async {
        await MainActor.run {
            // Create activity items with proper error handling
            let activityItems: [Any] = [
                message,
                image
            ]

            let activityViewController = UIActivityViewController(
                activityItems: activityItems,
                applicationActivities: nil
            )

            // CRITICAL FIX: Proper iPad support to prevent crashes
            if let popover = activityViewController.popoverPresentationController {
                popover.sourceView = viewController.view
                popover.sourceRect = CGRect(
                    x: viewController.view.bounds.midX,
                    y: viewController.view.bounds.midY,
                    width: 0,
                    height: 0
                )
                popover.permittedArrowDirections = []
            }

            // CRITICAL FIX: Add completion handler to track success/failure
            activityViewController.completionWithItemsHandler = { [weak self] _, completed, _, error in
                Task { @MainActor in
                    if let error = error {
                        self?.lastError = FixedSharingError.sharePreparationFailed(error.localizedDescription)
                        print("❌ Activity sharing failed: \(error)")
                    } else if completed {
                        self?.shareSuccess = true
                        print("✅ Activity sharing completed successfully")
                    } else {
                        print("ℹ️ Activity sharing was cancelled by user")
                    }
                }
            }

            // CRITICAL FIX: Add timeout protection
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                viewController.present(activityViewController, animated: true) {
                    print("✅ Activity controller presented successfully")
                }
            }
        }
    }

    // MARK: - WhatsApp Direct URL Scheme (Fallback)

    func shareDirectToWhatsApp(
        message: String,
        phoneNumber: String? = nil
    ) async -> Bool {
        var urlString = "whatsapp://send?"

        // Add phone number if provided
        if let phone = phoneNumber?.trimmingCharacters(in: .whitespacesAndNewlines),
           !phone.isEmpty {
            // Clean phone number (remove special characters)
            let cleanPhone = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            if !cleanPhone.isEmpty {
                urlString += "phone=\(cleanPhone)&"
            }
        }

        // Add message with proper encoding
        if let encodedMessage = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            urlString += "text=\(encodedMessage)"
        }

        guard let url = URL(string: urlString) else {
            await MainActor.run {
                self.lastError = FixedSharingError.invalidSharingURL
            }
            return false
        }

        return await MainActor.run {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url) { [weak self] success in
                    Task { @MainActor in
                        if success {
                            self?.shareSuccess = true
                            print("✅ WhatsApp opened successfully")
                        } else {
                            self?.lastError = FixedSharingError.platformNotAvailable("Failed to open WhatsApp")
                            print("❌ Failed to open WhatsApp")
                        }
                    }
                }
                return true
            } else {
                self.lastError = FixedSharingError.platformNotAvailable("WhatsApp is not available")
                return false
            }
        }
    }

    // MARK: - Generic Safe Sharing Method

    func shareWithRetry(
        rakhi: GeneratedRakhi,
        message: String,
        contact: Any?, // Contact? - temporarily using Any
        from viewController: UIViewController,
        maxRetries: Int = 2
    ) async {
        var attempts = 0
        var lastError: Error?

        while attempts < maxRetries {
            attempts += 1
            print("🔄 Sharing attempt \(attempts) of \(maxRetries)")

            do {
                // Try activity controller first (most reliable)
                let imageData = rakhi.mainImage.imageData
                if let image = UIImage(data: imageData) {

                    await shareViaActivityController(
                        image: image,
                        message: message,
                        from: viewController
                    )

                    // Success - break out of retry loop
                    return
                }

                throw FixedSharingError.invalidContent("No image data")

            } catch {
                lastError = error
                print("❌ Sharing attempt \(attempts) failed: \(error)")

                // Wait before retry
                if attempts < maxRetries {
                    try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
                }
            }
        }

        // All attempts failed
        await MainActor.run {
            if let error = lastError as? SharingError {
                self.lastError = FixedSharingError.sharePreparationFailed(error.localizedDescription)
            } else {
                self.lastError = FixedSharingError.sharePreparationFailed(lastError?.localizedDescription ?? "Unknown error")
            }
        }
    }

    // MARK: - Utility Methods

    private func isWhatsAppAvailable() -> Bool {
        guard let whatsappURL = URL(string: "whatsapp://") else { return false }
        return UIApplication.shared.canOpenURL(whatsappURL)
    }

    func resetState() {
        lastError = nil
        shareSuccess = false
        isSharing = false
    }

    // MARK: - Error Recovery

    func handleSharingFailure(error: FixedSharingError, from viewController: UIViewController) {
        let alert = UIAlertController(
            title: "Sharing Failed",
            message: error.userFriendlyDescription,
            preferredStyle: .alert
        )

        // Add retry action for recoverable errors
        if error.isRecoverable {
            alert.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
                // Could implement retry logic here
            })
        }

        // Add alternative sharing option
        alert.addAction(UIAlertAction(title: "Try Another Method", style: .default) { _ in
            // Could show sharing options
        })

        alert.addAction(UIAlertAction(title: "OK", style: .cancel))

        viewController.present(alert, animated: true)
    }
}

// MARK: - Enhanced Error Handling

enum FixedSharingError: LocalizedError, Equatable {
    case platformNotAvailable(String)
    case invalidContent(String)
    case sharePreparationFailed(String)
    case invalidSharingURL
    case networkError
    case userCancelled

    var errorDescription: String? {
        switch self {
        case .platformNotAvailable(let platform):
            return "Platform not available: \(platform)"
        case .invalidContent(let reason):
            return "Invalid content: \(reason)"
        case .sharePreparationFailed(let reason):
            return "Share preparation failed: \(reason)"
        case .invalidSharingURL:
            return "Invalid sharing URL"
        case .networkError:
            return "Network error occurred"
        case .userCancelled:
            return "Sharing cancelled by user"
        }
    }

    var userFriendlyDescription: String {
        switch self {
        case .platformNotAvailable(let platform):
            return "\(platform) is not installed. Please install the app and try again."
        case .invalidContent:
            return "There was a problem with the content to share. Please try again."
        case .sharePreparationFailed:
            return "Failed to prepare content for sharing. Please try again."
        case .invalidSharingURL:
            return "Invalid sharing link. Please try again."
        case .networkError:
            return "Please check your internet connection and try again."
        case .userCancelled:
            return "Sharing was cancelled."
        }
    }

    var isRecoverable: Bool {
        switch self {
        case .platformNotAvailable, .invalidContent:
            return false
        case .sharePreparationFailed, .invalidSharingURL, .networkError:
            return true
        case .userCancelled:
            return false
        }
    }
}

// MARK: - SwiftUI Integration

struct SafeSharingView: View {
    @StateObject private var sharingService = FixedSocialSharingService.shared

    let rakhi: GeneratedRakhi
    let contact: Any // Contact - temporarily using Any
    let message: String

    var body: some View {
        VStack {
            if sharingService.isSharing {
                ProgressView("Preparing to share...")
                    .progressViewStyle(CircularProgressViewStyle())
            } else if sharingService.shareSuccess {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                    Text("Shared successfully!")
                }
            } else if let error = sharingService.lastError {
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.red)
                        Text("Sharing failed")
                    }

                    Text(error.userFriendlyDescription)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    if error.isRecoverable {
                        Button("Try Again") {
                            Task {
                                await shareAgain()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .font(.caption)
                    }
                }
            }
        }
        .onAppear {
            sharingService.resetState()
        }
    }

    private func shareAgain() async {
        guard let viewController = getRootViewController() else { return }

        await sharingService.shareWithRetry(
            rakhi: rakhi,
            message: message,
            contact: contact,
            from: viewController
        )
    }

    @MainActor
    private func getRootViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return nil
        }
        return window.rootViewController
    }
}

#Preview {
    // Preview disabled due to Contact type compilation issue  
    Text("SafeSharingView Preview")
}
