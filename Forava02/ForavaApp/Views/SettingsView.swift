import SwiftUI
import PassKit
import WebKit

struct SettingsView: View {
    @EnvironmentObject var preferences: CulturePreferencesManager
    @State private var notificationsEnabled = true
    @State private var soundEnabled = true
    @State private var hapticEnabled = true
    @State private var autoApprovePayments = false
    @State private var maxPaymentAmount = 100.0
    @State private var showingDeleteConfirmation = false
    @State private var showingPrivacyPolicy = false
    @State private var showingTermsOfService = false
    @State private var showingMinimumSelectionAlert = false
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
            }
        }
        .sheet(isPresented: $showingPrivacyPolicy) {
            PrivacyPolicyView()
        }
        .sheet(isPresented: $showingTermsOfService) {
            TermsOfServiceView()
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

        return ForEach(sortedEvents) { event in
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
            NavigationLink {
                DataExportView()
            } label: {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundStyle(.blue)
                        .frame(width: 20)

                    Text("Export Data")
                        .foregroundStyle(.white)
                }
            }

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

struct DataExportView: View {
    var body: some View {
        List {
            Section {
                Text("Export your Rakhi gift history and data")
                    .foregroundStyle(.secondary)
            } header: {
                Text("Export Options")
            }
        }
        .navigationTitle("Export Data")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            HTMLDocumentView(fileName: "privacy-policy")
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
            HTMLDocumentView(fileName: "terms-of-use")
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
    let fileName: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.contentInsetAdjustmentBehavior = .automatic
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        if let htmlPath = Bundle.main.path(forResource: fileName, ofType: "html", inDirectory: "Resources") {
            let url = URL(fileURLWithPath: htmlPath)
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(CulturePreferencesManager())
}
