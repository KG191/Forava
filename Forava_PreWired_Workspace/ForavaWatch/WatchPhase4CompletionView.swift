import SwiftUI
import WatchKit

/// Phase 4 Completion: Advanced Features & Polish Implementation
/// This view demonstrates all Phase 4 features integrated together
struct WatchPhase4CompletionView: View {
    @StateObject private var syncManager = WatchSyncManager.shared
    @StateObject private var paymentManager = WatchPaymentManager.shared
    @StateObject private var displayService = EnhancedRakhiWatchDisplayService.shared
    @StateObject private var hapticManager = WatchHapticManager.shared

    @State private var showingCulturalPayment = false
    @State private var showingSyncStatus = false
    @State private var selectedCulturalGift: WatchCulturalGift?
    @State private var animationsEnabled = true

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    // Phase 4: Advanced Watch Experience Header
                    phase4HeaderView

                    // Phase 4: Real-time Sync Status
                    syncStatusCard

                    // Phase 4: Cultural Gifts Display
                    culturalGiftsSection

                    // Phase 4: Advanced Payment Features
                    paymentFeaturesSection

                    // Phase 4: Battery & Performance Optimization
                    optimizationSection

                    // Phase 4: Cross-Device Synchronization
                    crossDeviceSyncSection
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 16)
            }
            .navigationTitle("Forava Watch")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        hapticManager.playHaptic(.selection)
                        showingSyncStatus = true
                    } label: {
                        syncStatusIcon
                    }
                }
            }
        }
        .sheet(isPresented: $showingCulturalPayment) {
            if let gift = selectedCulturalGift {
                CulturalWatchPaymentView(
                    culturalGift: gift,
                    senderName: gift.senderName,
                    relationship: "sibling",
                    occasion: gift.occasion
                )
            }
        }
        .sheet(isPresented: $showingSyncStatus) {
            WatchSyncStatusView()
        }
        .onAppear {
            initializePhase4Features()
        }
    }

    // MARK: - Phase 4: Advanced Header

    private var phase4HeaderView: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Cultural Gifts")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)

                    Text("AI-Powered • Multi-Cultural")
                        .font(.caption2)
                        .foregroundStyle(.orange)
                }

                Spacer()

                // Phase 4: Advanced Animation Toggle
                Button {
                    animationsEnabled.toggle()
                    displayService.watchDisplaySettings.animationsEnabled = animationsEnabled
                    hapticManager.playHaptic(.selection)
                } label: {
                    Image(systemName: animationsEnabled ? "sparkles" : "sparkles.rectangle.stack")
                        .font(.caption)
                        .foregroundStyle(animationsEnabled ? .orange : .secondary)
                }
            }

            // Phase 4: Performance Indicator
            HStack(spacing: 8) {
                performanceIndicator("Battery", value: getBatteryLevel(), color: getBatteryColor())
                Spacer()
                performanceIndicator("Sync", value: getSyncPerformance(), color: .blue)
                Spacer()
                performanceIndicator("Display", value: getDisplayPerformance(), color: .green)
            }
        }
        .padding(12)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }

    private func performanceIndicator(_ title: String, value: Double, color: Color) -> some View {
        VStack(spacing: 2) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)

            Text("\(Int(value * 100))%")
                .font(.caption.weight(.semibold))
                .foregroundStyle(color)
        }
    }

    // MARK: - Phase 4: Sync Status

    private var syncStatusCard: some View {
        HStack(spacing: 8) {
            syncStatusIcon
                .font(.caption)

            VStack(alignment: .leading, spacing: 2) {
                Text(syncStatusText)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.primary)

                if let lastSync = syncManager.lastSyncTime {
                    Text("Last sync: \(lastSync, style: .relative)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            if syncManager.pendingSyncItems.count > 0 {
                Text("\(syncManager.pendingSyncItems.count)")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(.orange, in: Capsule())
            }
        }
        .padding(10)
        .background(syncStatusColor.opacity(0.1), in: RoundedRectangle(cornerRadius: 10))
        .onTapGesture {
            hapticManager.playHaptic(.selection)
            Task {
                await syncManager.requestFullSync()
            }
        }
    }

    private var syncStatusIcon: some View {
        Group {
            switch syncManager.syncStatus {
            case .connected:
                Image(systemName: "checkmark.icloud")
                    .foregroundStyle(.green)
            case .connecting, .syncing:
                Image(systemName: "icloud.and.arrow.up")
                    .foregroundStyle(.orange)
            case .disconnected:
                Image(systemName: "icloud.slash")
                    .foregroundStyle(.red)
            case .error:
                Image(systemName: "exclamationmark.icloud")
                    .foregroundStyle(.red)
            }
        }
    }

    // MARK: - Phase 4: Cultural Gifts

    private var culturalGiftsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Recent Gifts")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary)

                Spacer()

                if !syncManager.culturalGifts.isEmpty {
                    Text("\(syncManager.culturalGifts.count)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }

            if syncManager.culturalGifts.isEmpty {
                emptyGiftsView
            } else {
                LazyVStack(spacing: 6) {
                    ForEach(syncManager.culturalGifts.prefix(3)) { gift in
                        culturalGiftCard(gift)
                    }
                }
            }
        }
    }

    private var emptyGiftsView: some View {
        VStack(spacing: 8) {
            Image(systemName: "gift.circle")
                .font(.title2)
                .foregroundStyle(.secondary)

            Text("No cultural gifts yet")
                .font(.caption)
                .foregroundStyle(.secondary)

            Text("Create on iPhone to see here")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))
    }

    private func culturalGiftCard(_ gift: WatchCulturalGift) -> some View {
        Button {
            selectedCulturalGift = gift
            showingCulturalPayment = true
            hapticManager.playHaptic(.selection)
        } label: {
            HStack(spacing: 8) {
                // Cultural symbol
                Text(getCulturalSymbol(for: gift.occasion))
                    .font(.title3)

                VStack(alignment: .leading, spacing: 2) {
                    Text(gift.senderName)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    HStack(spacing: 4) {
                        Text(getOccasionName(gift.occasion))
                            .font(.caption2)
                            .foregroundStyle(.orange)

                        Spacer()

                        Text("\(gift.culturalScore, specifier: "%.1f") ⭐")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Phase 4: Payment Features

    private var paymentFeaturesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Payment Intelligence")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary)

            VStack(spacing: 6) {
                paymentFeatureRow("Smart Amounts", "Based on cultural context", systemImage: "dollarsign.circle")
                paymentFeatureRow("Cross-Device Sync", "iPhone ↔ Watch", systemImage: "arrow.triangle.2.circlepath")
                paymentFeatureRow("Gratitude Expressions", "Beautiful animations", systemImage: "heart.circle")
            }
        }
    }

    private func paymentFeatureRow(_ title: String, _ description: String, systemImage: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.caption)
                .foregroundStyle(.orange)
                .frame(width: 16)

            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.primary)

                Text(description)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
    }

    // MARK: - Phase 4: Optimization

    private var optimizationSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Performance")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary)

            HStack(spacing: 12) {
                optimizationToggle(
                    "Battery",
                    isOn: displayService.batteryOptimizationEnabled,
                    systemImage: "battery.100"
                ) {
                    if displayService.batteryOptimizationEnabled {
                        displayService.disableBatteryOptimization()
                    } else {
                        displayService.enableBatteryOptimization()
                    }
                    hapticManager.playHaptic(.selection)
                }

                Spacer()

                optimizationToggle(
                    "Animations",
                    isOn: animationsEnabled,
                    systemImage: "sparkles"
                ) {
                    animationsEnabled.toggle()
                    displayService.watchDisplaySettings.animationsEnabled = animationsEnabled
                    hapticManager.playHaptic(.selection)
                }
            }
        }
    }

    private func optimizationToggle(_ title: String, isOn: Bool, systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: systemImage)
                    .font(.caption)
                    .foregroundStyle(isOn ? .green : .secondary)

                Text(title)
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(isOn ? .green : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(isOn ? .green.opacity(0.1) : .clear, in: RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isOn ? .green.opacity(0.3) : .clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Phase 4: Cross-Device Sync

    private var crossDeviceSyncSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Cross-Device Sync")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary)

            HStack {
                deviceSyncIndicator("iPhone", connected: syncManager.syncStatus == .connected)

                Image(systemName: "arrow.left.arrow.right")
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                deviceSyncIndicator("Watch", connected: true)

                Spacer()

                Button {
                    hapticManager.playHaptic(.selection)
                    Task {
                        await syncManager.requestFullSync()
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
            }
        }
    }

    private func deviceSyncIndicator(_ name: String, connected: Bool) -> some View {
        VStack(spacing: 2) {
            Image(systemName: name == "iPhone" ? "iphone" : "applewatch")
                .font(.caption)
                .foregroundStyle(connected ? .green : .secondary)

            Text(name)
                .font(.caption2)
                .foregroundStyle(connected ? .green : .secondary)
        }
    }

    // MARK: - Helper Methods

    private func initializePhase4Features() {
        // Initialize all Phase 4 advanced features
        hapticManager.playHaptic(.start)

        Task {
            await syncManager.requestFullSync()
        }

        // Load user preferences
        animationsEnabled = displayService.watchDisplaySettings.animationsEnabled
    }

    private var syncStatusText: String {
        switch syncManager.syncStatus {
        case .connected: return "Connected"
        case .connecting: return "Connecting..."
        case .syncing: return "Syncing..."
        case .disconnected: return "Disconnected"
        case .error(let message): return "Error: \(message)"
        }
    }

    private var syncStatusColor: Color {
        switch syncManager.syncStatus {
        case .connected: return .green
        case .connecting, .syncing: return .orange
        case .disconnected, .error: return .red
        }
    }

    private func getBatteryLevel() -> Double {
        WKInterfaceDevice.current().batteryLevel
    }

    private func getBatteryColor() -> Color {
        let level = getBatteryLevel()
        if level > 0.5 { return .green }
        if level > 0.2 { return .orange }
        return .red
    }

    private func getSyncPerformance() -> Double {
        switch syncManager.syncStatus {
        case .connected: return 1.0
        case .connecting, .syncing: return 0.5
        default: return 0.0
        }
    }

    private func getDisplayPerformance() -> Double {
        displayService.batteryOptimizationEnabled ? 0.6 : 1.0
    }

    private func getCulturalSymbol(for occasion: String) -> String {
        switch occasion.lowercased() {
        case "raksha_bandhan", "rakhi": return "🎊"
        case "diwali": return "🪔"
        case "chinese_new_year": return "🧧"
        case "christmas": return "🎄"
        case "eid": return "🌙"
        case "vesak": return "🪷"
        case "hanukkah": return "🕎"
        case "holi": return "🌈"
        case "birthday": return "🎂"
        default: return "🎁"
        }
    }

    private func getOccasionName(_ occasion: String) -> String {
        switch occasion.lowercased() {
        case "raksha_bandhan": return "Raksha Bandhan"
        case "chinese_new_year": return "Chinese New Year"
        case "mid_autumn_festival": return "Mid-Autumn Festival"
        case "rosh_hashanah": return "Rosh Hashanah"
        default: return occasion.capitalized
        }
    }
}

// MARK: - Sync Status Detail View

struct WatchSyncStatusView: View {
    @StateObject private var syncManager = WatchSyncManager.shared
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Current Status
                    VStack(spacing: 8) {
                        Text("Sync Status")
                            .font(.headline.weight(.semibold))

                        syncStatusDetail
                    }

                    // Last Sync Info
                    if let lastSync = syncManager.lastSyncTime {
                        VStack(spacing: 4) {
                            Text("Last Sync")
                                .font(.caption.weight(.medium))
                                .foregroundStyle(.secondary)

                            Text(lastSync, style: .complete)
                                .font(.caption)
                                .foregroundStyle(.primary)
                        }
                        .padding(12)
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))
                    }

                    // Pending Items
                    if !syncManager.pendingSyncItems.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Pending Sync (\(syncManager.pendingSyncItems.count))")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.primary)

                            Text("Items waiting to sync to iPhone")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        .padding(12)
                        .background(.orange.opacity(0.1), in: RoundedRectangle(cornerRadius: 10))
                    }

                    // Manual Sync Button
                    Button {
                        Task {
                            await syncManager.requestFullSync()
                        }
                    } label: {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Sync Now")
                        }
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(.orange, in: RoundedRectangle(cornerRadius: 16))
                    }
                    .disabled(syncManager.syncStatus == .syncing)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
            .navigationTitle("Sync Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.caption)
                }
            }
        }
    }

    private var syncStatusDetail: some View {
        VStack(spacing: 6) {
            Image(systemName: syncStatusIcon)
                .font(.title2)
                .foregroundStyle(syncStatusColor)

            Text(syncStatusText)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.primary)

            if case .error(let message) = syncManager.syncStatus {
                Text(message)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(16)
        .background(syncStatusColor.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
    }

    private var syncStatusIcon: String {
        switch syncManager.syncStatus {
        case .connected: return "checkmark.icloud.fill"
        case .connecting: return "icloud.and.arrow.up"
        case .syncing: return "arrow.clockwise.icloud"
        case .disconnected: return "icloud.slash.fill"
        case .error: return "exclamationmark.triangle.fill"
        }
    }

    private var syncStatusText: String {
        switch syncManager.syncStatus {
        case .connected: return "Connected to iPhone"
        case .connecting: return "Connecting to iPhone..."
        case .syncing: return "Syncing data..."
        case .disconnected: return "Not connected to iPhone"
        case .error: return "Sync error occurred"
        }
    }

    private var syncStatusColor: Color {
        switch syncManager.syncStatus {
        case .connected: return .green
        case .connecting, .syncing: return .orange
        case .disconnected, .error: return .red
        }
    }
}

#Preview {
    WatchPhase4CompletionView()
}
