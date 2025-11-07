import SwiftUI
import MessageUI

struct RakshaBandhanConnectView: View {
    let selectedContact: Contact
    let culturalColor: Color

    @State private var showingMessageComposer = false
    @State private var showingVoucherGrid = false
    @State private var messageComposeResult: MessageComposeResult?
    @State private var selectedProvider: VoucherProvider?
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header Section
                VStack(spacing: 12) {
                    Text("Show Your Gratitude")
                        .font(.system(.title2, design: .rounded).weight(.bold))
                        .foregroundStyle(.primary)

                    Text("Send a heartfelt message or gift voucher to \(selectedContact.name)")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)

                // Glass Morphism Content Container
                VStack(spacing: 20) {
                    // Send Message Section
                    sendMessageSection()

                    Divider()
                        .padding(.vertical, 8)

                    // Send Voucher Section
                    sendVoucherSection()
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
                ConnectMessageComposeView(
                    recipients: [selectedContact.phoneNumber],
                    body: "Thank you for the wonderful Raksha Bandhan gift! 🎗️",
                    result: $messageComposeResult
                )
            }
        }
        .sheet(isPresented: $showingVoucherGrid) {
            ConnectVoucherSelectionSheet(
                culturalColor: culturalColor,
                onProviderSelected: { provider in
                    selectedProvider = provider
                    showingVoucherGrid = false
                    openVoucherProvider(provider)
                }
            )
        }
        .alert("Connect", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }

    @ViewBuilder
    private func sendMessageSection() -> some View {
        VStack(spacing: 16) {
            // Icon and Title
            VStack(spacing: 8) {
                Image(systemName: "message.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "#FF8A00"), Color(hex: "#E05A00")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                Text("Send Message")
                    .font(.system(.headline, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)

                Text("Express your gratitude with a heartfelt message")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 20)

            // Send Message Button
            Button(action: {
                if MFMessageComposeViewController.canSendText() {
                    showingMessageComposer = true
                } else {
                    alertMessage = "Message service is not available on this device."
                    showingAlert = true
                }
            }) {
                HStack {
                    Image(systemName: "paperplane.fill")
                        .font(.headline)

                    Text("Send Thank You Message")
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
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
    private func sendVoucherSection() -> some View {
        VStack(spacing: 16) {
            // Icon and Title
            VStack(spacing: 8) {
                Image(systemName: "giftcard.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "#FF8A00"), Color(hex: "#E05A00")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                Text("Send Gift Voucher")
                    .font(.system(.headline, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)

                Text("Choose from premium brands and retailers")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 20)

            // Select Voucher Button
            Button(action: {
                showingVoucherGrid = true
            }) {
                HStack {
                    Image(systemName: "sparkles")
                        .font(.headline)

                    Text("Browse Gift Vouchers")
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
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

    private func openVoucherProvider(_ provider: VoucherProvider) {
        UIApplication.shared.open(provider.url)
        alertMessage = "Opening \(provider.name)..."
        showingAlert = true
    }
}


#Preview {
    RakshaBandhanConnectView(
        selectedContact: Contact(name: "Friend", phoneNumber: "1234567890"),
        culturalColor: Color(hex: "#FF6B35")
    )
}
