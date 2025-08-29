import SwiftUI

struct SimpleLanguageSettingsView: View {
    @StateObject private var localization = SimpleLocalizationService.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 16) {
                    Image(systemName: "globe")
                        .font(.system(size: 60))
                        .foregroundStyle(.orange)
                    
                    Text("Language & Cultural Settings")
                        .font(.system(.title2, design: .rounded).weight(.bold))
                        .multilineTextAlignment(.center)
                    
                    Text("Choose your preferred language and cultural preferences")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                
                // Language Selection
                VStack(spacing: 16) {
                    SectionHeader(title: "Language", icon: "textformat.abc")
                    
                    VStack(spacing: 12) {
                        ForEach(AppLanguage.allCases, id: \.self) { language in
                            LanguageOption(
                                language: language,
                                isSelected: localization.currentLanguage == language
                            ) {
                                localization.changeLanguage(to: language)
                            }
                        }
                    }
                }
                
                // Cultural Preferences
                VStack(spacing: 16) {
                    SectionHeader(title: "Cultural Preferences", icon: "star.circle")
                    
                    VStack(spacing: 12) {
                        SettingToggle(
                            title: "Show Hindi Greetings",
                            subtitle: "Display 'नमस्ते' instead of 'Namaste'",
                            isOn: $localization.showHindiGreetings
                        )
                        
                        SettingToggle(
                            title: "Cultural Context",
                            subtitle: "Use traditional greetings and cultural elements",
                            isOn: $localization.useCulturalContext
                        )
                    }
                }
                
                // Preview Section
                PreviewSection()
                
                Spacer()
            }
            .padding(16)
            .navigationTitle("Language")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(localization.getString("done")) {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Language Option

struct LanguageOption: View {
    let language: AppLanguage
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 16) {
                // Flag
                Text(language.flag)
                    .font(.system(size: 28))
                
                // Language Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(language.displayName)
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)
                    
                    Text(getSampleText(for: language))
                        .font(.system(.subheadline))
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                // Selection indicator
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(.title3))
                        .foregroundStyle(.orange)
                }
            }
            .padding(16)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? .orange : .clear, lineWidth: 2)
            }
        }
        .buttonStyle(.plain)
    }
    
    private func getSampleText(for language: AppLanguage) -> String {
        switch language {
        case .english: return "Create Your Rakhi"
        case .hindi: return "अपनी राखी बनाएं"
        }
    }
}

// MARK: - Setting Toggle

struct SettingToggle: View {
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(.subheadline, design: .rounded).weight(.medium))
                    .foregroundStyle(.primary)
                
                Text(subtitle)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .tint(.orange)
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Preview Section

struct PreviewSection: View {
    @StateObject private var localization = SimpleLocalizationService.shared
    
    var body: some View {
        VStack(spacing: 16) {
            SectionHeader(title: "Preview", icon: "eye")
            
            VStack(spacing: 12) {
                PreviewCard(
                    label: "Greeting",
                    value: localization.getCulturalGreeting()
                )
                
                PreviewCard(
                    label: "App Name",
                    value: localization.getString("app_name")
                )
                
                PreviewCard(
                    label: "Festival Message",
                    value: localization.getFestivalMessage()
                )
                
                PreviewCard(
                    label: "Currency",
                    value: localization.formatCurrency(299.0)
                )
            }
        }
    }
}

struct PreviewCard: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
                
                Text(value)
                    .font(.system(.subheadline).weight(.medium))
                    .foregroundStyle(.primary)
            }
            
            Spacer()
        }
        .padding(12)
        .background(.orange.opacity(0.05), in: RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Section Header

struct SectionHeader: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(.subheadline))
                .foregroundStyle(.orange)
            
            Text(title)
                .font(.system(.headline, design: .rounded).weight(.semibold))
                .foregroundStyle(.primary)
            
            Spacer()
        }
    }
}

#Preview {
    SimpleLanguageSettingsView()
}