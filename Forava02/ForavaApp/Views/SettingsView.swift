import SwiftUI
import WebKit

struct SettingsView: View {
    @EnvironmentObject var preferences: CulturePreferencesManager
    @StateObject private var paymentService = ComprehensivePaymentService.shared
    @StateObject private var quotaManager = GenerationQuotaManager.shared
    @State private var notificationsEnabled = true
    @State private var soundEnabled = true
    @State private var hapticEnabled = true
    @State private var autoApprovePayments = false
    @State private var maxPaymentAmount = 100.0
    @State private var showingDeleteConfirmation = false
    @State private var showingPrivacyPolicy = false
    @State private var showingTermsOfService = false
    @State private var showingMinimumSelectionAlert = false
    @State private var showCultureSelection = false
    @State private var showPaywall = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            // MARK: Dark Gradient Background
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(hex: "#1a1a1a"), location: 0.0),
                    .init(color: Color(hex: "#2d2d2d"), location: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            NavigationStack {
                List {
                // My Cultures Section
                Section {
                    cultureSelectionSection
                } header: {
                    Text("Which Culture Does Your Loved One or Friend Identify With? You can change this anytime.")
                        .foregroundStyle(.white)
                }

                // Credits Section
                Section {
                    subscriptionSection
                } header: {
                    Text("Credits & Balance")
                        .foregroundStyle(.white)
                } footer: {
                    Text("Track your free generations and regeneration credits")
                        .foregroundStyle(.white.opacity(0.7))
                }

                // Notifications Section
                Section {
                    notificationsSection
                } header: {
                    Text("Notifications")
                        .foregroundStyle(.white)
                } footer: {
                    Text("Control how you receive notifications for gifts and reminders.")
                        .foregroundStyle(.white.opacity(0.7))
                }

                // Data Management Section
                Section {
                    dataManagementSection
                } header: {
                    Text("Data Management")
                        .foregroundStyle(.white)
                }

                // Legal Section
                Section {
                    legalSection
                } header: {
                    Text("Legal")
                        .foregroundStyle(.white)
                }

                // Help & Support Section (SAFETY-002: UGC Moderation)
                Section {
                    helpSupportSection
                } header: {
                    Text("Help & Support")
                        .foregroundStyle(.white)
                } footer: {
                    Text("Get help or report issues with AI-generated content")
                        .foregroundStyle(.white.opacity(0.7))
                }

                // App Information Section
                Section {
                    appInfoSection
                } header: {
                    Text("About")
                        .foregroundStyle(.white)
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(.dark)
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
        .sheet(isPresented: $showingPrivacyPolicy) {
            PrivacyPolicyView()
        }
        .sheet(isPresented: $showingTermsOfService) {
            TermsOfServiceView()
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView(paymentService: paymentService, quotaManager: quotaManager)
        }
        .alert("Delete All Data", isPresented: $showingDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                deleteAllUserData()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This will permanently delete all your Rakhi gifts, payment history, and app data. This action cannot be undone.")
        }
        .alert("Minimum Selection Required", isPresented: $showingMinimumSelectionAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("You must select at least one culture to continue using the app.")
        }
    }

    // MARK: - My Cultures Section
    private var cultureSelectionSection: some View {
        // Get all events and sort alphabetically by name
        let sortedEvents = CulturalEvent.allEvents.sorted { $0.name < $1.name }

        return DisclosureGroup(
            isExpanded: $showCultureSelection,
            content: {
                VStack(spacing: 8) {
                    ForEach(sortedEvents) { event in
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    // Check if this is the last selected culture
                    if preferences.isSelected(event.id.uuidString) && preferences.selectedCultureIDs.count == 1 {
                        showingMinimumSelectionAlert = true
                    } else {
                        preferences.toggleCulture(event.id.uuidString)
                    }
                }
            } label: {
                HStack(spacing: 12) {
                    // Checkbox
                    Image(systemName: preferences.isSelected(event.id.uuidString) ? "checkmark.square.fill" : "square")
                        .font(.system(size: 22))
                        .foregroundStyle(preferences.isSelected(event.id.uuidString) ? .orange : .white.opacity(0.5))

                    // Culture name
                    Text(event.name)
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.white)

                    Spacer()
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    preferences.isSelected(event.id.uuidString)
                                        ? Color.orange.opacity(0.6)
                                        : Color.white.opacity(0.2),
                                    lineWidth: preferences.isSelected(event.id.uuidString) ? 2 : 1
                                )
                        )
                )
            }
            .buttonStyle(.plain)
                    }
                }
                .padding(.top, 8)
            },
            label: {
                HStack(spacing: 12) {
                    Image(systemName: "globe")
                        .font(.system(size: 20))
                        .foregroundStyle(.orange)

                    Text("My Cultures")
                        .font(.system(.body, design: .rounded).weight(.semibold))
                        .foregroundStyle(.white)

                    Spacer()

                    Text("\(preferences.selectedCultureIDs.count) selected")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.white.opacity(0.7))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(.orange.opacity(0.2)))
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
            }
        )
        .tint(.orange)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                )
        )
    }

    // MARK: - Subscription Section
    private var subscriptionSection: some View {
        Group {
            // Current Tier Status
            HStack {
                Image(systemName: paymentService.isSubscribed ? "crown.fill" : "sparkles")
                    .foregroundStyle(paymentService.isSubscribed ? Color(hex: "#FFD700") : .orange)
                    .frame(width: 20)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Current Plan")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.white.opacity(0.7))

                    Text(paymentService.getSubscriptionTier().displayName)
                        .font(.system(.body, design: .rounded).weight(.semibold))
                        .foregroundStyle(.white)
                }

                Spacer()

                if paymentService.isSubscribed {
                    Text("Active")
                        .font(.system(.caption, design: .rounded).weight(.medium))
                        .foregroundStyle(.green)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(.green.opacity(0.2)))
                }
            }

            // Free Quota Remaining (if on free tier)
            if !paymentService.isSubscribed {
                HStack {
                    Image(systemName: "gift.fill")
                        .foregroundStyle(.blue)
                        .frame(width: 20)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Free Generations")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.white.opacity(0.7))

                        Text("\(quotaManager.quotaRemaining) of 3 remaining")
                            .font(.system(.body, design: .rounded).weight(.semibold))
                            .foregroundStyle(.white)
                    }

                    Spacer()
                }
            }

            // Regeneration Credits
            HStack {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .foregroundStyle(.purple)
                    .frame(width: 20)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Regeneration Credits")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.white.opacity(0.7))

                    Text("\(paymentService.getAvailableCreditsCount()) available")
                        .font(.system(.body, design: .rounded).weight(.semibold))
                        .foregroundStyle(.white)
                }

                Spacer()
            }

            // Purchase Credits Button (CRITICAL: For App Store Review - IAP Visibility)
            Button {
                showPaywall = true
            } label: {
                HStack {
                    Image(systemName: "cart.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)

                    Text("Buy Regeneration Credits")
                        .font(.system(.body, design: .rounded).weight(.semibold))
                        .foregroundStyle(.white)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.7))
                }
                .padding(.vertical, 14)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.orange,
                                    Color.orange.opacity(0.8)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: .orange.opacity(0.3), radius: 8, x: 0, y: 4)
                )
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Notifications Section
    private var notificationsSection: some View {
        Group {
            Toggle(isOn: $notificationsEnabled) {
                HStack {
                    Image(systemName: "bell.fill")
                        .foregroundStyle(.blue)
                        .frame(width: 20)

                    Text("Push Notifications")
                        .foregroundStyle(.white)
                }
            }

            if notificationsEnabled {
                Toggle(isOn: $soundEnabled) {
                    HStack {
                        Image(systemName: "speaker.wave.2.fill")
                            .foregroundStyle(.purple)
                            .frame(width: 20)

                        Text("Sound")
                            .foregroundStyle(.white)
                    }
                }

                Toggle(isOn: $hapticEnabled) {
                    HStack {
                        Image(systemName: "iphone.radiowaves.left.and.right")
                            .foregroundStyle(.pink)
                            .frame(width: 20)

                        Text("Haptic Feedback")
                            .foregroundStyle(.white)
                    }
                }
            }
        }
    }

    // MARK: - Data Management Section
    private var dataManagementSection: some View {
        Group {
            Button {
                showingDeleteConfirmation = true
            } label: {
                HStack {
                    Image(systemName: "trash.fill")
                        .foregroundStyle(.red)
                        .frame(width: 20)

                    Text("Delete All Data")
                        .foregroundStyle(.white)
                }
            }
        }
    }

    // MARK: - Legal Section
    private var legalSection: some View {
        Group {
            Button {
                showingPrivacyPolicy = true
            } label: {
                HStack {
                    Image(systemName: "hand.raised.fill")
                        .foregroundStyle(.blue)
                        .frame(width: 20)

                    Text("Privacy Policy")
                        .foregroundStyle(.white)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundStyle(.white.opacity(0.5))
                        .font(.caption)
                }
            }

            Button {
                showingTermsOfService = true
            } label: {
                HStack {
                    Image(systemName: "doc.text.fill")
                        .foregroundStyle(.blue)
                        .frame(width: 20)

                    Text("Terms of Service")
                        .foregroundStyle(.white)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundStyle(.white.opacity(0.5))
                        .font(.caption)
                }
            }
        }
    }

    // MARK: - Help & Support Section (SAFETY-002: UGC Moderation)
    private var helpSupportSection: some View {
        Group {
            // Contact Support
            Link(destination: URL(string: "mailto:foravaapp@gmail.com")!) {
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundStyle(.orange)
                        .frame(width: 20)

                    Text("Contact Support")
                        .foregroundStyle(.white)

                    Spacer()

                    Image(systemName: "arrow.up.right")
                        .foregroundStyle(.white.opacity(0.5))
                        .font(.caption)
                }
            }

            // Report Content (general link - specific reports handled per-image)
            Button {
                // Open email with report template
                if let mailtoURL = URL(string: "mailto:foravaapp@gmail.com?subject=Content%20Report&body=Please%20describe%20the%20issue%20you%20encountered%20with%20AI-generated%20content.") {
                    UIApplication.shared.open(mailtoURL)
                }
            } label: {
                HStack {
                    Image(systemName: "exclamationmark.shield.fill")
                        .foregroundStyle(.red)
                        .frame(width: 20)

                    Text("Report Inappropriate Content")
                        .foregroundStyle(.white)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundStyle(.white.opacity(0.5))
                        .font(.caption)
                }
            }
        }
    }

    // MARK: - App Info Section
    private var appInfoSection: some View {
        Group {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundStyle(.blue)
                    .frame(width: 20)

                Text("Version")
                    .foregroundStyle(.white)

                Spacer()

                Text("1.0.0")
                    .foregroundStyle(.white.opacity(0.7))
            }

            HStack {
                Image(systemName: "envelope.fill")
                    .foregroundStyle(.green)
                    .frame(width: 20)

                Text("Support")
                    .foregroundStyle(.white)

                Spacer()

                Button("Contact") {
                    if let url = URL(string: "mailto:foravaapp@gmail.com") {
                        UIApplication.shared.open(url)
                    }
                }
                .foregroundStyle(.orange)
            }

            HStack {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                    .frame(width: 20)

                Text("Rate Forava")
                    .foregroundStyle(.white)

                Spacer()

                Button("Rate") {
                    // Open App Store for rating
                }
                .foregroundStyle(.orange)
            }
        }
    }

    private func deleteAllUserData() {
        // Implement secure data deletion following Apple guidelines
        // This should include:
        // - Clear all user preferences
        // - Delete payment history
        // - Clear cached data
        // - Reset to default state

        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)

        // Show confirmation
        // In a real app, you might want to restart or show a success message
    }
}

// MARK: - Supporting Views

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            HTMLDocumentView(urlString: "https://kg191.github.io/forava-legal/privacy.html")
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Privacy Policy")
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
}

struct TermsOfServiceView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            HTMLDocumentView(urlString: "https://kg191.github.io/forava-legal/terms.html")
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Terms of Use")
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
}

// MARK: - HTML Document WebView
struct HTMLDocumentView: UIViewRepresentable {
    let urlString: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.contentInsetAdjustmentBehavior = .automatic
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        // Try to load from remote URL first
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        } else {
            // Fallback to local file if URL is invalid
            // Extract filename from urlString (e.g., "privacy" from any path)
            let fileName = urlString.components(separatedBy: "/").last ?? urlString
            if let htmlPath = Bundle.main.path(forResource: fileName, ofType: "html", inDirectory: "Resources") {
                let url = URL(fileURLWithPath: htmlPath)
                let request = URLRequest(url: url)
                webView.load(request)
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(CulturePreferencesManager())
}
