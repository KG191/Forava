import SwiftUI

struct PremiumCulturalPacksView: View {
    @StateObject private var subscriptionManager = SubscriptionManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPack: PremiumCulturalPack?
    @State private var showingPackDetails = false
    @State private var showingPurchaseAlert = false
    
    let culturalContext: CulturalCategory
    
    var availablePacks: [PremiumCulturalPack] {
        PremiumCulturalPack.allCases.filter { pack in
            pack.availableFor.contains(culturalContext)
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    // Header
                    headerSection
                    
                    // Subscription Status
                    subscriptionStatusSection
                    
                    // Premium Packs Grid
                    premiumPacksSection
                    
                    // Benefits Section
                    benefitsSection
                }
                .padding()
            }
            .navigationTitle("Premium Design Packs")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showingPackDetails) {
            if let selectedPack = selectedPack {
                PremiumPackDetailView(pack: selectedPack, culturalContext: culturalContext)
            }
        }
        .alert("Purchase Premium Pack", isPresented: $showingPurchaseAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Purchase") {
                if let pack = selectedPack {
                    Task {
                        await subscriptionManager.purchaseCulturalPack(pack)
                    }
                }
            }
        } message: {
            if let pack = selectedPack {
                Text("Purchase \(pack.displayName) for $\(String(format: "%.2f", pack.price))?")
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: culturalContext.icon)
                    .font(.system(size: 32))
                    .foregroundColor(culturalContext.primaryColor)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(culturalContext.displayName) Premium Packs")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Exclusive designs with authentic cultural elements")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // MARK: - Subscription Status Section
    private var subscriptionStatusSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Your Access Level")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text(subscriptionManager.subscriptionStatus.tier.displayName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(subscriptionManager.subscriptionStatus.tier.primaryColor)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(subscriptionManager.subscriptionStatus.tier.primaryColor.opacity(0.15))
                    .cornerRadius(16)
            }
            
            if !subscriptionManager.subscriptionStatus.tier.premiumCulturalPacks {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "info.circle")
                            .foregroundColor(.blue)
                        Text("Premium subscription required")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    
                    Text("Upgrade to Premium or Family to access all premium cultural design packs included in your subscription.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // MARK: - Premium Packs Section
    private var premiumPacksSection: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 8),
            GridItem(.flexible(), spacing: 8)
        ], spacing: 16) {
            ForEach(availablePacks, id: \.self) { pack in
                PremiumPackCard(
                    pack: pack,
                    culturalContext: culturalContext,
                    isOwned: subscriptionManager.subscriptionStatus.purchasedPacks.contains(pack) ||
                            subscriptionManager.subscriptionStatus.tier.premiumCulturalPacks,
                    canAccess: subscriptionManager.subscriptionStatus.tier.rawValue >= pack.requiresSubscription.rawValue
                ) {
                    selectedPack = pack
                    showingPackDetails = true
                } onPurchase: {
                    selectedPack = pack
                    showingPurchaseAlert = true
                }
            }
        }
    }
    
    // MARK: - Benefits Section
    private var benefitsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Premium Pack Benefits")
                .font(.headline)
                .fontWeight(.bold)
            
            VStack(spacing: 12) {
                BenefitRow(
                    icon: "paintbrush.pointed.fill",
                    title: "Exclusive Designs",
                    description: "Access to unique cultural artwork not available in standard packs",
                    color: .purple
                )
                
                BenefitRow(
                    icon: "sparkles",
                    title: "Higher Cultural Authenticity",
                    description: "Designs with 95-100% cultural authenticity scores",
                    color: .orange
                )
                
                BenefitRow(
                    icon: "crown.fill",
                    title: "Premium Elements",
                    description: "Luxury patterns, textures, and symbolic elements",
                    color: .yellow
                )
                
                BenefitRow(
                    icon: "person.2.fill",
                    title: "Cultural Expert Approved",
                    description: "Reviewed and approved by cultural authenticity experts",
                    color: .green
                )
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Premium Pack Card
struct PremiumPackCard: View {
    let pack: PremiumCulturalPack
    let culturalContext: CulturalCategory
    let isOwned: Bool
    let canAccess: Bool
    let onTap: () -> Void
    let onPurchase: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            // Icon and Badge
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(culturalContext.primaryColor.opacity(0.15))
                    .frame(height: 80)
                
                Image(systemName: pack.icon)
                    .font(.system(size: 32, weight: .light))
                    .foregroundColor(culturalContext.primaryColor)
                
                if isOwned {
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                    .padding(8)
                }
            }
            
            VStack(spacing: 6) {
                Text(pack.displayName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 4) {
                    ForEach(0..<Int(pack.culturalWeight * 5), id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(.orange)
                            .font(.caption2)
                    }
                }
                
                if !isOwned {
                    Text("$\(String(format: "%.2f", pack.price))")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(culturalContext.primaryColor)
                }
            }
            
            // Action Button
            Button(action: isOwned ? onTap : (canAccess ? onPurchase : {})) {
                Text(isOwned ? "View Details" : (canAccess ? "Purchase" : "Requires \(pack.requiresSubscription.displayName)"))
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isOwned ? .primary : (canAccess ? .white : .secondary))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(
                        isOwned ? Color(.systemGray5) :
                        (canAccess ? culturalContext.primaryColor : Color(.systemGray4))
                    )
                    .cornerRadius(8)
            }
            .disabled(!canAccess && !isOwned)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        .onTapGesture {
            onTap()
        }
    }
}

// MARK: - Benefit Row
struct BenefitRow: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
    }
}

// MARK: - Premium Pack Detail View
struct PremiumPackDetailView: View {
    let pack: PremiumCulturalPack
    let culturalContext: CulturalCategory
    @Environment(\.dismiss) private var dismiss
    @StateObject private var subscriptionManager = SubscriptionManager.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header with large icon
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(culturalContext.primaryColor.opacity(0.15))
                                .frame(width: 120, height: 120)
                            
                            Image(systemName: pack.icon)
                                .font(.system(size: 48, weight: .light))
                                .foregroundColor(culturalContext.primaryColor)
                        }
                        
                        Text(pack.displayName)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        HStack(spacing: 4) {
                            ForEach(0..<Int(pack.culturalWeight * 5), id: \.self) { _ in
                                Image(systemName: "star.fill")
                                    .foregroundColor(.orange)
                                    .font(.subheadline)
                            }
                            Text("\(String(format: "%.1f", pack.culturalWeight * 5))/5 Cultural Authenticity")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.leading, 4)
                        }
                    }
                    
                    // Description and details
                    VStack(alignment: .leading, spacing: 16) {
                        Text("About This Pack")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text("This premium cultural design pack contains exclusive \(culturalContext.displayName) elements with the highest level of cultural authenticity. Each design is carefully crafted and reviewed by cultural experts.")
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        // Available cultures
                        Text("Available For")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 8) {
                            ForEach(pack.availableFor, id: \.self) { culture in
                                HStack {
                                    Image(systemName: culture.icon)
                                        .foregroundColor(culture.primaryColor)
                                    Text(culture.displayName)
                                        .font(.caption)
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Purchase section
                    if !subscriptionManager.subscriptionStatus.purchasedPacks.contains(pack) &&
                       !subscriptionManager.subscriptionStatus.tier.premiumCulturalPacks {
                        VStack(spacing: 12) {
                            Text("$\(String(format: "%.2f", pack.price))")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(culturalContext.primaryColor)
                            
                            if subscriptionManager.subscriptionStatus.tier.rawValue >= pack.requiresSubscription.rawValue {
                                Button(action: {
                                    Task {
                                        await subscriptionManager.purchaseCulturalPack(pack)
                                    }
                                }) {
                                    HStack {
                                        if subscriptionManager.isLoading {
                                            ProgressView()
                                                .scaleEffect(0.8)
                                        } else {
                                            Text("Purchase Pack")
                                                .fontWeight(.semibold)
                                        }
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(culturalContext.primaryColor)
                                    .cornerRadius(12)
                                }
                                .disabled(subscriptionManager.isLoading)
                            } else {
                                VStack(spacing: 8) {
                                    Text("Requires \(pack.requiresSubscription.displayName) Subscription")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.orange)
                                    
                                    Button("Upgrade Subscription") {
                                        // Handle upgrade action
                                    }
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    } else {
                        VStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.title2)
                            
                            Text("You Own This Pack")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text("This premium pack is available in your cultural design studio")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(12)
                    }
                    
                    if let errorMessage = subscriptionManager.errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                }
                .padding()
            }
            .navigationTitle("")
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
    PremiumCulturalPacksView(culturalContext: .hindu)
}