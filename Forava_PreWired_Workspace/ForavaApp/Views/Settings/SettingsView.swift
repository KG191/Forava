import SwiftUI

// MARK: - Phase 4: Complete Multi-Cultural Settings Architecture
// Main settings view with proper organization per Apple HIG

struct SettingsView: View {
    @EnvironmentObject private var subscriptionManager: SubscriptionManager
    @EnvironmentObject private var terminologyService: DynamicCulturalTerminologyService
    @EnvironmentObject private var migrationService: CulturalSystemMigrationService

    @State private var showingCulturalPreferences = false
    @State private var showingSubscriptionManagement = false
    @State private var showingPrivacyPolicy = false
    @State private var showingSupport = false
    @State private var notificationsEnabled = true
    @State private var analyticsEnabled = true

    var body: some View {
        NavigationStack {
            List {
                // Profile/Account Section
                accountSection

                // Cultural Preferences Section - PRIMARY
                culturalPreferencesSection

                // Subscription Management Section
                subscriptionSection

                // App Preferences
                appPreferencesSection

                // Privacy & Security
                privacySecuritySection

                // Support & Legal
                supportLegalSection

                // App Information
                appInformationSection

                // Developer Section (for migration status)
                if !migrationService.isMigrationRequired() {
                    developerSection
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingCulturalPreferences) {
                CulturalPreferencesView()
                    .environmentObject(subscriptionManager)
                    .environmentObject(terminologyService)
            }
            .sheet(isPresented: $showingSubscriptionManagement) {
                SubscriptionManagementView()
                    .environmentObject(subscriptionManager)
            }
            .sheet(isPresented: $showingPrivacyPolicy) {
                SafariView(url: URL(string: "https://kg191.github.io/privacy")!)
            }
        }
    }

    // MARK: - Account Section

    private var accountSection: some View {
        Section {
            HStack(spacing: 16) {
                // User Avatar
                Circle()
                    .fill(.orange.gradient)
                    .frame(width: 50, height: 50)
                    .overlay {
                        Text("F")
                            .font(.title2.weight(.semibold))
                            .foregroundStyle(.white)
                    }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Forava User")
                        .font(.headline)

                    Text(subscriptionManager.currentSubscription.displayName)
                        .font(.subheadline)
                        .foregroundStyle(subscriptionManager.isPremiumSubscriber ? .green : .secondary)
                }

                Spacer()

                if subscriptionManager.isPremiumSubscriber {
                    Image(systemName: "crown.fill")
                        .foregroundStyle(.yellow)
                }
            }
            .padding(.vertical, 8)
        }
    }

    // MARK: - Cultural Preferences Section (PRIMARY)

    private var culturalPreferencesSection: some View {
        Section {
            // Primary Occasion Display
            HStack {
                Image(systemName: getCurrentOccasionIcon())
                    .foregroundStyle(.orange)
                    .frame(width: 24)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Cultural Preferences")
                        .font(.body)

                    Text("Primary: \(getCurrentOccasionName())")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                showingCulturalPreferences = true
            }

            // Quick occasion switcher
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(getQuickSwitchOccasions(), id: \.id) { occasion in
                        quickOccasionButton(occasion)
                    }
                }
                .padding(.horizontal, 4)
                .padding(.vertical, 8)
            }
        } header: {
            Label("Cultural Settings", systemImage: "globe")
        } footer: {
            Text("Customize your cultural experience and select primary occasion for gift creation.")
        }
    }

    private func quickOccasionButton(_ occasion: CulturalOccasion) -> some View {
        let isSelected = terminologyService.selectedOccasion == occasion.id

        return Button {
            terminologyService.updateCulturalSettings(
                occasion: occasion.id,
                context: occasion.culturalContext
            )
        } label: {
            VStack(spacing: 4) {
                Text(occasion.symbol)
                    .font(.title3)

                Text(occasion.shortName)
                    .font(.caption2)
                    .lineLimit(1)
            }
            .frame(width: 60, height: 50)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? .orange : Color(.systemGray6))
            )
            .foregroundStyle(isSelected ? .white : .primary)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Subscription Section

    private var subscriptionSection: some View {
        Section {
            HStack {
                Image(systemName: subscriptionManager.isPremiumSubscriber ? "crown.fill" : "creditcard.fill")
                    .foregroundStyle(subscriptionManager.isPremiumSubscriber ? .yellow : .blue)
                    .frame(width: 24)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Subscription Management")
                        .font(.body)

                    HStack {
                        Text(subscriptionManager.currentSubscription.displayName)
                            .font(.caption)
                            .foregroundStyle(subscriptionManager.isPremiumSubscriber ? .green : .secondary)

                        if subscriptionManager.regenerationCredits > 0 {
                            Text("• \(subscriptionManager.regenerationCredits) credits")
                                .font(.caption)
                                .foregroundStyle(.orange)
                        }
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                showingSubscriptionManagement = true
            }

            // Usage summary
            let stats = subscriptionManager.getUsageStats()
            HStack(spacing: 20) {
                VStack {
                    Text("\(stats.generationsThisMonth)")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.blue)
                    Text("This Month")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                VStack {
                    Text("\(stats.totalGenerations)")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.green)
                    Text("Total")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                if stats.creditsRemaining > 0 {
                    VStack {
                        Text("\(stats.creditsRemaining)")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.orange)
                        Text("Credits")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()
            }
            .padding(.vertical, 4)
        } header: {
            Label("Subscription", systemImage: "creditcard")
        }
    }

    // MARK: - App Preferences Section

    private var appPreferencesSection: some View {
        Section {
            // Notifications
            HStack {
                Image(systemName: "bell.fill")
                    .foregroundStyle(.red)
                    .frame(width: 24)

                Text("Notifications")

                Spacer()

                Toggle("", isOn: $notificationsEnabled)
                    .tint(.orange)
            }

            // Analytics
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundStyle(.green)
                    .frame(width: 24)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Analytics")
                    Text("Help improve the app")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Toggle("", isOn: $analyticsEnabled)
                    .tint(.orange)
            }

            // App Language (separate from cultural language)
            HStack {
                Image(systemName: "textformat.abc")
                    .foregroundStyle(.blue)
                    .frame(width: 24)

                Text("App Language")

                Spacer()

                Text("English")
                    .foregroundStyle(.secondary)

                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
        } header: {
            Label("App Preferences", systemImage: "gear")
        }
    }

    // MARK: - Privacy & Security Section

    private var privacySecuritySection: some View {
        Section {
            settingsRow("Privacy Policy", "hand.raised.fill", .blue) {
                showingPrivacyPolicy = true
            }

            settingsRow("Data & Privacy", "shield.fill", .green) {
                openPrivacySettings()
            }

            settingsRow("Cultural Sensitivity", "heart.fill", .pink) {
                showCulturalSensitivityInfo()
            }
        } header: {
            Label("Privacy & Security", systemImage: "lock.shield")
        }
    }

    // MARK: - Support & Legal Section

    private var supportLegalSection: some View {
        Section {
            settingsRow("Help & Support", "questionmark.circle.fill", .orange) {
                showingSupport = true
            }

            settingsRow("Terms of Service", "doc.text.fill", .gray) {
                openTermsOfService()
            }

            settingsRow("Rate Forava", "star.fill", .yellow) {
                rateApp()
            }

            settingsRow("Share App", "square.and.arrow.up.fill", .blue) {
                shareApp()
            }
        } header: {
            Label("Support", systemImage: "questionmark.circle")
        }
    }

    // MARK: - App Information Section

    private var appInformationSection: some View {
        Section {
            HStack {
                Text("Version")
                Spacer()
                Text(getAppVersion())
                    .foregroundStyle(.secondary)
            }

            HStack {
                Text("Build")
                Spacer()
                Text(getBuildNumber())
                    .foregroundStyle(.secondary)
            }

            HStack {
                Text("Cultural Agents")
                Spacer()
                Text("12 Active")
                    .foregroundStyle(.green)
            }
        } header: {
            Label("App Information", systemImage: "info.circle")
        }
    }

    // MARK: - Developer Section (Migration Status)

    private var developerSection: some View {
        Section {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)

                Text("Cultural System Migration")

                Spacer()

                Text("Complete")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(.green.opacity(0.2), in: Capsule())
                    .foregroundStyle(.green)
            }

            Button("Reset Migration (Debug)") {
                migrationService.resetMigration()
            }
            .foregroundStyle(.orange)
        } header: {
            Label("Developer", systemImage: "hammer.fill")
        } footer: {
            Text("Migration completed successfully. All cultural systems are integrated.")
                .font(.caption2)
        }
    }

    // MARK: - Helper Methods

    private func settingsRow(_ title: String, _ icon: String, _ color: Color, _ action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(color)
                    .frame(width: 24)

                Text(title)
                    .foregroundStyle(.primary)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
        }
        .buttonStyle(.plain)
    }

    private func getCurrentOccasionIcon() -> String {
        let occasion = DynamicCulturalTerminologyService.supportedOccasions.first {
            $0.id == terminologyService.selectedOccasion
        }
        return occasion?.icon ?? "gift.fill"
    }

    private func getCurrentOccasionName() -> String {
        let occasion = DynamicCulturalTerminologyService.supportedOccasions.first {
            $0.id == terminologyService.selectedOccasion
        }
        return occasion?.displayName ?? "Raksha Bandhan"
    }

    private func getQuickSwitchOccasions() -> [CulturalOccasion] {
        return Array(DynamicCulturalTerminologyService.supportedOccasions.prefix(6))
    }

    // MARK: - Actions

    private func openPrivacySettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }

    private func showCulturalSensitivityInfo() {
        // Show cultural sensitivity information
        print("Show cultural sensitivity info")
    }

    private func openTermsOfService() {
        if let url = URL(string: "https://kg191.github.io/terms") {
            UIApplication.shared.open(url)
        }
    }

    private func rateApp() {
        // Implement App Store rating request
        print("Request app store rating")
    }

    private func shareApp() {
        // Implement app sharing
        print("Share app")
    }

    private func getAppVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }

    private func getBuildNumber() -> String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
}

// MARK: - Safari View for Web Content

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // No updates needed
    }
}

import SafariServices

#Preview {
    NavigationStack {
        SettingsView()
            .environmentObject(SubscriptionManager.shared)
            .environmentObject(DynamicCulturalTerminologyService.shared)
            .environmentObject(CulturalSystemMigrationService.shared)
    }
}
