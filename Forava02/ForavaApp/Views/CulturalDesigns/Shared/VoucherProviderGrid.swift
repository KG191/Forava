import SwiftUI

// MARK: - Voucher Provider Grid Component
struct VoucherProviderGrid: View {
    let culturalColor: Color
    let onProviderSelected: (VoucherProvider) -> Void

    @State private var selectedCategory: VoucherCategory = .entertainment

    // Grid layout configuration
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        VStack(spacing: 20) {
            // Category Selector
            categorySelector()

            // Providers Grid
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(VoucherProvider.providers(for: selectedCategory)) { provider in
                        ProviderCard(
                            provider: provider,
                            culturalColor: culturalColor,
                            onTap: {
                                onProviderSelected(provider)
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
    }

    @ViewBuilder
    private func categorySelector() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(VoucherCategory.allCases, id: \.self) { category in
                    CategoryChip(
                        category: category,
                        isSelected: selectedCategory == category,
                        culturalColor: culturalColor
                    ) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedCategory = category
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 12)
    }
}

// MARK: - Category Chip
private struct CategoryChip: View {
    let category: VoucherCategory
    let isSelected: Bool
    let culturalColor: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.system(.subheadline).weight(.semibold))

                Text(category.rawValue)
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
            }
            .foregroundStyle(isSelected ? .white : culturalColor)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        isSelected
                            ? LinearGradient(
                                colors: [Color(hex: "#FF8A00"), Color(hex: "#E05A00")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            : LinearGradient(
                                colors: [culturalColor.opacity(0.12), culturalColor.opacity(0.08)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        isSelected ? Color.clear : culturalColor.opacity(0.3),
                        lineWidth: 1
                    )
            )
            .shadow(
                color: isSelected ? Color(hex: "#FF8A00").opacity(0.4) : .clear,
                radius: 8,
                y: 4
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Provider Card
private struct ProviderCard: View {
    let provider: VoucherProvider
    let culturalColor: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Icon
                ZStack {
                    Circle()
                        .fill(provider.primaryColor.opacity(0.15))
                        .frame(width: 60, height: 60)

                    Image(systemName: provider.icon)
                        .font(.system(size: 28))
                        .foregroundStyle(provider.primaryColor)
                }

                // Name
                Text(provider.name)
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(culturalColor.opacity(0.03))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(culturalColor.opacity(0.25), lineWidth: 1)
                    )
            )
            .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview
#Preview {
    VoucherProviderGrid(
        culturalColor: Color(hex: "#FF6B35"),
        onProviderSelected: { provider in
            print("Selected: \(provider.name)")
        }
    )
}
