import SwiftUI

// MARK: - Phase 5: Cultural Preferences Settings View
// Allows users to select their primary cultural occasion and secondary occasions

struct CulturalPreferencesView: View {
    @StateObject private var terminologyService = DynamicCulturalTerminologyService.shared
    @Environment(\.dismiss) private var dismiss

    @State private var selectedPrimaryOccasion: String
    @State private var selectedSecondaryOccasions: Set<String> = []
    @State private var culturalDisplayLanguage = "English"
    @State private var showingPreview = false

    init() {
        let currentOccasion = DynamicCulturalTerminologyService.shared.selectedOccasion
        _selectedPrimaryOccasion = State(initialValue: currentOccasion)

        // Load secondary occasions from UserDefaults
        let savedSecondary = UserDefaults.standard.stringArray(forKey: "secondary_cultural_occasions") ?? []
        _selectedSecondaryOccasions = State(initialValue: Set(savedSecondary))
    }

    var body: some View {
        NavigationStack {
            List {
                // Primary Occasion Selection
                primaryOccasionSection

                // Secondary Occasions Selection
                secondaryOccasionsSection

                // Cultural Display Language
                languageSection

                // Preview Section
                previewSection

                // Cultural Information
                culturalInfoSection
            }
            .navigationTitle("Cultural Preferences")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(.orange)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveCulturalPreferences()
                        dismiss()
                    }
                    .foregroundStyle(.orange)
                    .fontWeight(.semibold)
                }
            }
        }
        .sheet(isPresented: $showingPreview) {
            CulturalPreviewView(
                occasion: selectedPrimaryOccasion,
                secondaryOccasions: Array(selectedSecondaryOccasions)
            )
        }
    }

    // MARK: - Primary Occasion Section

    private var primaryOccasionSection: some View {
        Section {
            ForEach(DynamicCulturalTerminologyService.supportedOccasions) { occasion in
                primaryOccasionRow(occasion)
            }
        } header: {
            Label("Primary Occasion", systemImage: "star.fill")
                .foregroundStyle(.orange)
        } footer: {
            Text("Your primary occasion determines the main cultural theme for gift creation and UI elements.")
        }
    }

    private func primaryOccasionRow(_ occasion: CulturalOccasion) -> some View {
        Button {
            selectedPrimaryOccasion = occasion.id
            // Remove from secondary if selected as primary
            selectedSecondaryOccasions.remove(occasion.id)
        } label: {
            HStack(spacing: 12) {
                // Cultural symbol
                Text(occasion.symbol)
                    .font(.title2)
                    .frame(width: 30, height: 30)
                    .background(
                        Circle()
                            .fill(occasion.primaryColor.opacity(0.2))
                    )

                VStack(alignment: .leading, spacing: 3) {
                    Text(occasion.displayName)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text("Digital \(occasion.displayName) Gift")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if selectedPrimaryOccasion == occasion.id {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.orange)
                        .font(.title3)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Secondary Occasions Section

    private var secondaryOccasionsSection: some View {
        Section {
            ForEach(DynamicCulturalTerminologyService.supportedOccasions.filter { $0.id != selectedPrimaryOccasion }) { occasion in
                secondaryOccasionRow(occasion)
            }
        } header: {
            Label("Secondary Occasions", systemImage: "list.bullet")
                .foregroundStyle(.blue)
        } footer: {
            Text("Select additional occasions you celebrate. These will be available as quick options when creating gifts.")
        }
    }

    private func secondaryOccasionRow(_ occasion: CulturalOccasion) -> some View {
        Button {
            if selectedSecondaryOccasions.contains(occasion.id) {
                selectedSecondaryOccasions.remove(occasion.id)
            } else {
                selectedSecondaryOccasions.insert(occasion.id)
            }
        } label: {
            HStack(spacing: 12) {
                // Cultural symbol (smaller for secondary)
                Text(occasion.symbol)
                    .font(.headline)
                    .frame(width: 24, height: 24)
                    .background(
                        Circle()
                            .fill(occasion.primaryColor.opacity(0.15))
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(occasion.displayName)
                        .font(.body)
                        .foregroundStyle(.primary)

                    Text("Secondary option")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if selectedSecondaryOccasions.contains(occasion.id) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.blue)
                        .font(.body)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Language Section

    private var languageSection: some View {
        Section {
            HStack {
                Image(systemName: "globe")
                    .foregroundStyle(.green)
                    .frame(width: 20)

                Text("Cultural Display Language")

                Spacer()

                Picker("Language", selection: $culturalDisplayLanguage) {
                    Text("English").tag("English")
                    Text("हिन्दी").tag("Hindi")
                    Text("中文").tag("Chinese")
                    Text("العربية").tag("Arabic")
                }
                .pickerStyle(.menu)
            }
        } header: {
            Label("Display Language", systemImage: "textformat")
                .foregroundStyle(.green)
        } footer: {
            Text("Language for cultural greetings and blessings. The main app remains in your system language.")
        }
    }

    // MARK: - Preview Section

    private var previewSection: some View {
        Section {
            Button {
                showingPreview = true
            } label: {
                HStack {
                    Image(systemName: "eye.fill")
                        .foregroundStyle(.purple)
                        .frame(width: 20)

                    Text("Preview Cultural Experience")
                        .foregroundStyle(.primary)

                    Spacer()

                    Image(systemName: "arrow.up.right")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                }
            }
        } header: {
            Label("Preview", systemImage: "sparkles")
                .foregroundStyle(.purple)
        } footer: {
            Text("See how your selected cultural preferences will appear in the app.")
        }
    }

    // MARK: - Cultural Info Section

    private var culturalInfoSection: some View {
        Section {
            if let currentOccasion = DynamicCulturalTerminologyService.supportedOccasions.first(where: { $0.id == selectedPrimaryOccasion }) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(currentOccasion.symbol)
                            .font(.title)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(currentOccasion.displayName)
                                .font(.headline)

                            Text("Your Primary Cultural Occasion")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()
                    }

                    Text("Cultural Theme: Digital \(currentOccasion.displayName) Gift")
                        .font(.body)
                        .foregroundStyle(.primary)

                    HStack {
                        Text("Colors:")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        HStack(spacing: 4) {
                            ForEach(Array(currentOccasion.colors.prefix(4).enumerated()), id: \.offset) { _, color in
                                Circle()
                                    .fill(color)
                                    .frame(width: 16, height: 16)
                            }
                        }

                        Spacer()
                    }
                }
                .padding(.vertical, 8)
            }
        } header: {
            Label("Current Selection", systemImage: "info.circle")
                .foregroundStyle(.orange)
        }
    }

    // MARK: - Save Functionality

    private func saveCulturalPreferences() {
        // Update terminology service
        let selectedOccasion = DynamicCulturalTerminologyService.supportedOccasions.first { $0.id == selectedPrimaryOccasion }
        let culturalContext = selectedOccasion?.culturalContext ?? "rakhi_indian"

        terminologyService.updateCulturalSettings(
            occasion: selectedPrimaryOccasion,
            context: culturalContext
        )

        // Save secondary occasions
        UserDefaults.standard.set(Array(selectedSecondaryOccasions), forKey: "secondary_cultural_occasions")

        // Save language preference
        UserDefaults.standard.set(culturalDisplayLanguage, forKey: "cultural_display_language")

        // Post notification for UI updates
        NotificationCenter.default.post(
            name: NSNotification.Name("CulturalPreferencesUpdated"),
            object: nil,
            userInfo: [
                "primaryOccasion": selectedPrimaryOccasion,
                "secondaryOccasions": Array(selectedSecondaryOccasions),
                "language": culturalDisplayLanguage
            ]
        )
    }
}

// MARK: - Cultural Preview View

struct CulturalPreviewView: View {
    let occasion: String
    let secondaryOccasions: [String]

    @Environment(\.dismiss) private var dismiss

    private var previewOccasion: CulturalOccasion? {
        DynamicCulturalTerminologyService.supportedOccasions.first { $0.id == occasion }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header Preview
                    if let occasion = previewOccasion {
                        headerPreview(occasion)
                    }

                    // UI Elements Preview
                    uiElementsPreview

                    // Text Examples Preview
                    textExamplesPreview
                }
                .padding()
            }
            .navigationTitle("Cultural Preview")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(.orange)
                }
            }
        }
    }

    private func headerPreview(_ occasion: CulturalOccasion) -> some View {
        VStack(spacing: 16) {
            Text(occasion.symbol)
                .font(.system(size: 60))

            Text("Digital \(occasion.displayName) Gift")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)

            Text(DynamicCulturalTerminologyService.shared.getCulturalBlessing(for: occasion.id))
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(occasion.primaryColor.opacity(0.1))
        )
    }

    private var uiElementsPreview: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("UI Elements Preview")
                .font(.headline)

            VStack(spacing: 12) {
                // Button Preview
                Button("Create a Digital \(previewOccasion?.displayName ?? "Special") Gift") {
                    // Preview only
                }
                .buttonStyle(.borderedProminent)
                .tint(previewOccasion?.primaryColor ?? .orange)

                // Secondary Button Preview
                Button("Send Digital \(previewOccasion?.displayName ?? "Special") Gift") {
                    // Preview only
                }
                .buttonStyle(.bordered)
                .tint(previewOccasion?.secondaryColor ?? .blue)

                // List Row Preview
                HStack {
                    Image(systemName: "gift.fill")
                        .foregroundStyle(previewOccasion?.primaryColor ?? .orange)

                    Text("Your \(previewOccasion?.displayName ?? "Special") Gift History")

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
            }
        }
    }

    private var textExamplesPreview: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Text Examples")
                .font(.headline)

            VStack(alignment: .leading, spacing: 8) {
                previewTextRow("Create Action:", "Create a Digital \(previewOccasion?.displayName ?? "Special") Gift")
                previewTextRow("Send Action:", "Send Digital \(previewOccasion?.displayName ?? "Special") Gift")
                previewTextRow("Ready Message:", "Your Digital \(previewOccasion?.displayName ?? "Special") Gift is Ready!")
                previewTextRow("History:", "\(previewOccasion?.displayName ?? "Special") Gift History")
                previewTextRow("Notifications:", "\(previewOccasion?.displayName ?? "Special") gift notifications")
            }
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
        }
    }

    private func previewTextRow(_ label: String, _ example: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption.weight(.medium))
                .foregroundStyle(.secondary)

            Text(example)
                .font(.body)
        }
    }
}

#Preview {
    CulturalPreferencesView()
}
