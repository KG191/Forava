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

    @State private var isPressed = false

    var body: some View {
        Button(action: {
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred(intensity: 0.7)
            onTap()
        }) {
            VStack(spacing: 0) {
                // Main content area
                VStack(spacing: 8) {
                    // Category Icon (generic SF Symbol)
                    Image(systemName: provider.category.icon)
                        .font(.system(size: 32))
                        .foregroundStyle(provider.primaryColor.opacity(0.6))
                        .padding(.top, 16)

                    // Brand Name (large focal point)
                    Text(provider.name)
                        .font(.system(.headline, design: .rounded).weight(.bold))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .padding(.horizontal, 12)

                    // Category text
                    Text(provider.category.rawValue)
                        .font(.system(.caption, design: .rounded).weight(.medium))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .padding(.bottom, 12)
                }

                // Brand color accent bar at bottom
                Rectangle()
                    .fill(provider.primaryColor)
                    .frame(height: 4)
            }
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: isPressed
                                ? [Color(hex: "#FF8A00").opacity(0.9), Color(hex: "#E05A00").opacity(0.7)]
                                : [Color(hex: "#FF8A00").opacity(0.15), Color(hex: "#E05A00").opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                isPressed
                                    ? Color(hex: "#FF8A00").opacity(0.6)
                                    : Color(hex: "#FF8A00").opacity(0.25),
                                lineWidth: 1
                            )
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(
                color: .black.opacity(isPressed ? 0.15 : 0.08),
                radius: isPressed ? 12 : 8,
                y: 4
            )
            .scaleEffect(isPressed ? 0.94 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isPressed)
        }
        .buttonStyle(.plain)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
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
