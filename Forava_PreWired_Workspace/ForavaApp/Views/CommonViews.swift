import SwiftUI

// Common view components used across different views
enum CommonViews {
    struct ContactRow: View {
        let contact: Contact
        let isSelected: Bool
        let onTap: () -> Void

        var body: some View {
            Button(action: onTap) {
                HStack(spacing: 16) {
                    // Avatar
                    Circle()
                        .fill(LinearGradient(
                            colors: [Color.orange.opacity(0.8), Color.red.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 50, height: 50)
                        .overlay {
                            Text(contact.name.prefix(1))
                                .font(.system(.title2, design: .rounded).weight(.bold))
                                .foregroundStyle(.white)
                        }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(contact.name)
                            .font(.system(.body, design: .rounded).weight(.semibold))
                            .foregroundStyle(.primary)

                        Text(contact.relationship.displayName)
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.orange)
                            .font(.title2)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 16))
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? .orange : .clear, lineWidth: 2)
                }
                .scaleEffect(isSelected ? 1.02 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
            }
            .buttonStyle(.plain)
        }
    }
    
    struct RakhiPreviewCard: View {
        let rakhi: GeneratedRakhi
        let isSmall: Bool
        
        var body: some View {
            VStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: rakhi.designSpec.colorPalette.colors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: isSmall ? 100 : 160)

                    VStack(spacing: 6) {
                        Image(systemName: "gift.circle.fill")
                            .font(.system(size: isSmall ? 24 : 40))
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.2), radius: 1)

                        if !isSmall {
                            Text(rakhi.designSpec.genre.displayName)
                                .font(.caption.weight(.medium))
                                .foregroundStyle(.white)
                        }
                    }
                }

                if !isSmall {
                    HStack(spacing: 12) {
                        CulturalScoreView(score: rakhi.culturalScore)
                        QualityScoreView(score: rakhi.qualityScore)
                    }
                }
            }
        }
    }
    
    struct CustomAmountSection: View {
        let amount: Decimal
        let onAmountChange: (Decimal) -> Void
        @State private var showingCustomInput = false
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text("Custom Amount")
                    .font(.headline)
                
                if showingCustomInput {
                    HStack {
                        TextField("Amount", value: .init(get: { amount }, set: { onAmountChange($0) }), format: .currency(code: "USD"))
                            .keyboardType(.decimalPad)
                            .textFieldStyle(.roundedBorder)
                        
                        Button("Done") {
                            showingCustomInput = false
                        }
                    }
                } else {
                    Button {
                        showingCustomInput = true
                    } label: {
                        Text("Enter Custom Amount")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
            }
        }
    }
    
    struct SectionHeader: View {
        let title: String
        let subtitle: String?
        let systemImage: String
        
        init(_ title: String, subtitle: String? = nil, systemImage: String) {
            self.title = title
            self.subtitle = subtitle
            self.systemImage = systemImage
        }
        
        var body: some View {
            HStack {
                Label {
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.headline)
                        if let subtitle = subtitle {
                            Text(subtitle)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                } icon: {
                    Image(systemName: systemImage)
                }
                Spacer()
            }
        }
    }
    
    struct CategoryPill: View {
        let title: String
        let isSelected: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Text(title)
                    .font(.subheadline.weight(.medium))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(isSelected ? .orange : .clear)
                    .foregroundStyle(isSelected ? .white : .primary)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(isSelected ? .clear : .gray.opacity(0.3))
                    )
            }
        }
    }
    
    private struct CulturalScoreView: View {
        let score: Double
        
        var body: some View {
            VStack(spacing: 4) {
                Text(String(format: "%.1f", score))
                    .font(.headline)
                Text("Cultural")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.green.opacity(0.1))
            .cornerRadius(8)
        }
    }
    
    private struct QualityScoreView: View {
        let score: Double
        
        var body: some View {
            VStack(spacing: 4) {
                Text(String(format: "%.1f", score))
                    .font(.headline)
                Text("Quality")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
        }
    }
}
