import SwiftUI

struct SubscriptionTierView: View {
    @StateObject private var subscriptionManager = SubscriptionManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTier: SubscriptionTier = .basic
    @State private var isAnnual: Bool = false
    @State private var showingPurchaseConfirmation = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    headerSection
                    
                    // Current Status
                    currentStatusSection
                    
                    // Billing Toggle
                    billingToggleSection
                    
                    // Subscription Tiers
                    subscriptionTiersSection
                    
                    // Features Comparison
                    featuresComparisonSection
                    
                    // Action Buttons
                    actionButtonsSection
                }
                .padding()
            }
            .navigationTitle("Subscription Plans")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .task {
            await subscriptionManager.loadProducts()
        }
        .alert("Confirm Purchase", isPresented: $showingPurchaseConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Purchase") {
                Task {
                    await subscriptionManager.upgradeSubscription(to: selectedTier)
                }
            }
        } message: {
            let price = isAnnual ? selectedTier.annualPrice : selectedTier.monthlyPrice
            let period = isAnnual ? "year" : "month"
            Text("Upgrade to \(selectedTier.displayName) for $\(String(format: "%.2f", price)) per \(period)?")
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "sparkles")
                .font(.system(size: 48, weight: .light))
                .foregroundColor(.purple)
            
            Text("Unlock Premium Cultural Experiences")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("Access all cultural contexts and premium design packs")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical)
    }
    
    // MARK: - Current Status Section
    private var currentStatusSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Current Plan")
                    .font(.headline)
                Spacer()
                
                HStack(spacing: 8) {
                    Circle()
                        .fill(subscriptionManager.subscriptionStatus.isActive ? .green : .gray)
                        .frame(width: 8, height: 8)
                    
                    Text(subscriptionManager.subscriptionStatus.tier.displayName)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
            }
            
            // Usage Progress
            let remaining = subscriptionManager.subscriptionStatus.generationsRemaining
            let total = subscriptionManager.subscriptionStatus.tier.monthlyGenerationsIncluded
            let used = total - remaining
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("AI Generations Used")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(used)/\(total)")
                        .font(.caption)
                        .fontWeight(.medium)
                }
                
                ProgressView(value: Double(used), total: Double(total))
                    .tint(subscriptionManager.subscriptionStatus.tier.primaryColor)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // MARK: - Billing Toggle Section
    private var billingToggleSection: some View {
        HStack {
            Text("Monthly")
                .fontWeight(isAnnual ? .regular : .bold)
                .foregroundColor(isAnnual ? .secondary : .primary)
            
            Spacer()
            
            Toggle("", isOn: $isAnnual)
                .toggleStyle(SwitchToggleStyle(tint: .purple))
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("Annual")
                    .fontWeight(isAnnual ? .bold : .regular)
                    .foregroundColor(isAnnual ? .primary : .secondary)
                
                Text("Save 17%")
                    .font(.caption)
                    .foregroundColor(.green)
                    .opacity(isAnnual ? 1 : 0.6)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // MARK: - Subscription Tiers Section
    private var subscriptionTiersSection: some View {
        VStack(spacing: 16) {
            ForEach(SubscriptionTier.allCases.filter { $0 != .free }, id: \.self) { tier in
                SubscriptionTierCard(
                    tier: tier,
                    isAnnual: isAnnual,
                    isSelected: selectedTier == tier,
                    isCurrent: subscriptionManager.subscriptionStatus.tier == tier
                ) {
                    selectedTier = tier
                }
            }
        }
    }
    
    // MARK: - Features Comparison Section
    private var featuresComparisonSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("What's Included")
                .font(.headline)
                .fontWeight(.bold)
            
            VStack(spacing: 12) {
                ForEach(selectedTier.features, id: \.self) { feature in
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text(feature)
                            .font(.subheadline)
                        Spacer()
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // MARK: - Action Buttons Section
    private var actionButtonsSection: some View {
        VStack(spacing: 12) {
            if selectedTier != subscriptionManager.subscriptionStatus.tier {
                Button(action: {
                    showingPurchaseConfirmation = true
                }) {
                    HStack {
                        if subscriptionManager.isLoading {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Text("Upgrade to \(selectedTier.displayName)")
                                .fontWeight(.semibold)
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedTier.primaryColor)
                    .cornerRadius(12)
                }
                .disabled(subscriptionManager.isLoading)
            }
            
            Button(action: {
                Task {
                    await subscriptionManager.restorePurchases()
                }
            }) {
                Text("Restore Purchases")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            
            if let errorMessage = subscriptionManager.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
            }
        }
        .padding(.vertical)
    }
}

// MARK: - Subscription Tier Card
struct SubscriptionTierCard: View {
    let tier: SubscriptionTier
    let isAnnual: Bool
    let isSelected: Bool
    let isCurrent: Bool
    let onTap: () -> Void
    
    private var price: Double {
        isAnnual ? tier.annualPrice : tier.monthlyPrice
    }
    
    private var period: String {
        isAnnual ? "year" : "month"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(tier.displayName)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    if isCurrent {
                        Text("Current Plan")
                            .font(.caption)
                            .foregroundColor(.green)
                            .fontWeight(.medium)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    HStack(alignment: .bottom, spacing: 2) {
                        Text("$\(String(format: "%.2f", price))")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("/ \(period)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    if isAnnual && tier != .free {
                        Text("$\(String(format: "%.2f", tier.monthlyPrice))/month")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            // Key features preview
            VStack(alignment: .leading, spacing: 6) {
                ForEach(Array(tier.features.prefix(3)), id: \.self) { feature in
                    HStack {
                        Image(systemName: "checkmark")
                            .foregroundColor(.green)
                            .font(.caption)
                        Text(feature)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            isSelected ? tier.primaryColor : Color(.systemGray4),
                            lineWidth: isSelected ? 2 : 1
                        )
                )
        )
        .onTapGesture {
            onTap()
        }
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    SubscriptionTierView()
}