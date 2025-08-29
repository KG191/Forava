import SwiftUI
import PassKit
import WatchConnectivity

struct SettingsView: View {
    @StateObject private var watchConnectivity = WatchConnectivityManager.shared
    @State private var notificationsEnabled = true
    @State private var soundEnabled = true
    @State private var hapticEnabled = true
    @State private var autoApprovePayments = false
    @State private var maxPaymentAmount = 100.0
    @State private var showingDeleteConfirmation = false
    @State private var showingPrivacyPolicy = false
    @State private var showingTermsOfService = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                // Apple Pay Section
                Section {
                    applePaySection
                } header: {
                    Text("Apple Pay")
                } footer: {
                    Text("Apple Pay allows secure payments for Rakhi gifts. All transactions are encrypted and protected by Touch ID or Face ID.")
                }
                
                // Watch Connectivity Section
                Section {
                    watchConnectivitySection
                } header: {
                    Text("Apple Watch")
                } footer: {
                    Text("Connect your Apple Watch to receive Rakhi notifications and manage payments directly from your wrist.")
                }
                
                // Notifications Section
                Section {
                    notificationsSection
                } header: {
                    Text("Notifications")
                } footer: {
                    Text("Control how you receive notifications for Rakhi gifts and payment requests.")
                }
                
                // Security Section
                Section {
                    securitySection
                } header: {
                    Text("Security & Privacy")
                } footer: {
                    Text("Forava follows Apple's strict privacy guidelines. Your data is encrypted and never shared with third parties.")
                }
                
                // Data Management Section
                Section {
                    dataManagementSection
                } header: {
                    Text("Data Management")
                }
                
                // Legal Section
                Section {
                    legalSection
                } header: {
                    Text("Legal")
                }
                
                // App Information Section
                Section {
                    appInfoSection
                } header: {
                    Text("About")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(.orange)
                }
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
    }
    
    // MARK: - Apple Pay Section
    private var applePaySection: some View {
        Group {
            HStack {
                Image(systemName: "creditcard.fill")
                    .foregroundStyle(.green)
                    .frame(width: 20)
                
                Text("Apple Pay Status")
                
                Spacer()
                
                if PKPaymentAuthorizationViewController.canMakePayments() {
                    Text("Available")
                        .foregroundStyle(.green)
                        .font(.system(.caption, design: .rounded).weight(.medium))
                } else {
                    Text("Unavailable")
                        .foregroundStyle(.red)
                        .font(.system(.caption, design: .rounded).weight(.medium))
                }
            }
            
            NavigationLink {
                PaymentSettingsView()
            } label: {
                HStack {
                    Image(systemName: "gear")
                        .foregroundStyle(.blue)
                        .frame(width: 20)
                    
                    Text("Payment Settings")
                }
            }
        }
    }
    
    // MARK: - Watch Connectivity Section
    private var watchConnectivitySection: some View {
        Group {
            HStack {
                Image(systemName: "applewatch")
                    .foregroundStyle(.orange)
                    .frame(width: 20)
                
                Text("Connection Status")
                
                Spacer()
                
                Circle()
                    .fill(watchConnectivity.isConnected ? .green : .red)
                    .frame(width: 8, height: 8)
                
                Text(watchConnectivity.isConnected ? "Connected" : "Disconnected")
                    .foregroundStyle(watchConnectivity.isConnected ? .green : .red)
                    .font(.system(.caption, design: .rounded).weight(.medium))
            }
            
            if watchConnectivity.isWatchAppInstalled {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .frame(width: 20)
                    
                    Text("Forava Watch App")
                    
                    Spacer()
                    
                    Text("Installed")
                        .foregroundStyle(.green)
                        .font(.system(.caption, design: .rounded).weight(.medium))
                }
            } else {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.orange)
                        .frame(width: 20)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Forava Watch App")
                        Text("Install on Apple Watch for full experience")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
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
                }
            }
            
            if notificationsEnabled {
                Toggle(isOn: $soundEnabled) {
                    HStack {
                        Image(systemName: "speaker.wave.2.fill")
                            .foregroundStyle(.purple)
                            .frame(width: 20)
                        
                        Text("Sound")
                    }
                }
                
                Toggle(isOn: $hapticEnabled) {
                    HStack {
                        Image(systemName: "iphone.radiowaves.left.and.right")
                            .foregroundStyle(.pink)
                            .frame(width: 20)
                        
                        Text("Haptic Feedback")
                    }
                }
            }
        }
    }
    
    // MARK: - Security Section
    private var securitySection: some View {
        Group {
            Toggle(isOn: $autoApprovePayments) {
                HStack {
                    Image(systemName: "checkmark.shield.fill")
                        .foregroundStyle(.green)
                        .frame(width: 20)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Auto-Approve Small Payments")
                        Text("Payments under $\(Int(maxPaymentAmount))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            if autoApprovePayments {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "dollarsign.circle")
                            .foregroundStyle(.green)
                            .frame(width: 20)
                        
                        Text("Max Auto Amount: $\(Int(maxPaymentAmount))")
                    }
                    
                    Slider(value: $maxPaymentAmount, in: 10...200, step: 10)
                        .accentColor(.orange)
                }
            }
            
            NavigationLink {
                BiometricSettingsView()
            } label: {
                HStack {
                    Image(systemName: "faceid")
                        .foregroundStyle(.blue)
                        .frame(width: 20)
                    
                    Text("Biometric Authentication")
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
                        .foregroundStyle(.red)
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
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
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
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
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
                
                Spacer()
                
                Text("1.0.0")
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                Image(systemName: "envelope.fill")
                    .foregroundStyle(.green)
                    .frame(width: 20)
                
                Text("Support")
                
                Spacer()
                
                Button("Contact") {
                    if let url = URL(string: "mailto:support@forava.com") {
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

struct PaymentSettingsView: View {
    var body: some View {
        List {
            Section {
                Text("Payment settings and preferences will be managed here")
                    .foregroundStyle(.secondary)
            } header: {
                Text("Payment Preferences")
            }
        }
        .navigationTitle("Payment Settings")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct BiometricSettingsView: View {
    var body: some View {
        List {
            Section {
                Text("Biometric authentication settings for secure payments")
                    .foregroundStyle(.secondary)
            } header: {
                Text("Authentication")
            }
        }
        .navigationTitle("Biometric Settings")
        .navigationBarTitleDisplayMode(.large)
    }
}

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
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Privacy Policy")
                        .font(.largeTitle.bold())
                    
                    Text("Forava is committed to protecting your privacy and ensuring the security of your personal information.")
                    
                    Group {
                        Text("Data Collection")
                            .font(.headline)
                        Text("We collect minimal data necessary for app functionality, including payment information processed securely through Apple Pay.")
                        
                        Text("Data Usage")
                            .font(.headline)
                        Text("Your data is used solely for providing Rakhi gifting services and is never shared with third parties.")
                        
                        Text("Security")
                            .font(.headline)
                        Text("All data is encrypted and stored securely following Apple's security guidelines.")
                    }
                }
                .padding()
            }
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

struct TermsOfServiceView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Terms of Service")
                        .font(.largeTitle.bold())
                    
                    Text("By using Forava, you agree to these terms and conditions.")
                    
                    Group {
                        Text("Service Description")
                            .font(.headline)
                        Text("Forava provides a platform for sending digital Rakhi gifts with secure payment processing.")
                        
                        Text("User Responsibilities")
                            .font(.headline)
                        Text("Users are responsible for accurate payment information and appropriate use of the service.")
                        
                        Text("Limitation of Liability")
                            .font(.headline)
                        Text("Forava is not liable for issues arising from third-party payment processors or network connectivity.")
                    }
                }
                .padding()
            }
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

#Preview {
    SettingsView()
}