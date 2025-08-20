import SwiftUI
import WatchKit

struct EnhancedRakhiWatchView: View {
    @StateObject private var displayService = EnhancedRakhiWatchDisplayService.shared
    @StateObject private var localization = SimpleLocalizationService.shared
    @State private var showingModeSelector = false
    @State private var currentIndex = 0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if displayService.displayedRakhis.isEmpty {
                    EmptyWatchState()
                } else {
                    // Display based on current mode
                    switch displayService.displayMode {
                    case .gallery:
                        GalleryModeView()
                    case .single:
                        SingleModeView()
                    case .carousel:
                        CarouselModeView()
                    case .minimal:
                        MinimalModeView()
                    }
                }
            }
            .navigationTitle(localization.getString("app_name"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingModeSelector = true
                    } label: {
                        Image(systemName: "square.grid.2x2")
                            .font(.caption)
                    }
                }
            }
            .sheet(isPresented: $showingModeSelector) {
                DisplayModeSelector()
            }
        }
    }
}

// MARK: - Display Modes

struct GalleryModeView: View {
    @StateObject private var displayService = EnhancedRakhiWatchDisplayService.shared
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(displayService.displayedRakhis) { rakhi in
                    CompactRakhiCard(rakhi: rakhi)
                        .onTapGesture {
                            displayService.selectRakhi(rakhi)
                        }
                }
            }
            .padding(.horizontal, 4)
        }
    }
}

struct SingleModeView: View {
    @StateObject private var displayService = EnhancedRakhiWatchDisplayService.shared
    
    var body: some View {
        VStack(spacing: 0) {
            if let currentRakhi = displayService.currentRakhi {
                DetailedRakhiCard(rakhi: currentRakhi)
            }
            
            // Navigation controls
            if displayService.displayedRakhis.count > 1 {
                RakhiNavigationControls()
            }
        }
    }
}

struct CarouselModeView: View {
    @StateObject private var displayService = EnhancedRakhiWatchDisplayService.shared
    @State private var selectedIndex = 0
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(Array(displayService.displayedRakhis.enumerated()), id: \.element.id) { index, rakhi in
                MediumRakhiCard(rakhi: rakhi)
                    .tag(index)
                    .onTapGesture {
                        displayService.selectRakhi(rakhi)
                    }
            }
        }
        .tabViewStyle(.page)
        .onAppear {
            if let currentRakhi = displayService.currentRakhi,
               let index = displayService.displayedRakhis.firstIndex(where: { $0.id == currentRakhi.id }) {
                selectedIndex = index
            }
        }
    }
}

struct MinimalModeView: View {
    @StateObject private var displayService = EnhancedRakhiWatchDisplayService.shared
    
    var body: some View {
        VStack(spacing: 12) {
            if let currentRakhi = displayService.currentRakhi {
                // Minimal rakhi display
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: currentRakhi.colors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                    
                    VStack(spacing: 4) {
                        Image(systemName: "gift.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(.white)
                        
                        Text("✨")
                            .font(.caption)
                    }
                }
                
                // Minimal info
                VStack(spacing: 2) {
                    Text(currentRakhi.title.components(separatedBy: " • ").first ?? "Rakhi")
                        .font(.system(.caption, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    
                    Text("\(currentRakhi.culturalScore, specifier: "%.1f") ⭐")
                        .font(.system(.caption2, design: .rounded))
                        .foregroundStyle(.orange)
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Rakhi Cards

struct CompactRakhiCard: View {
    let rakhi: WatchRakhiDisplay
    
    var body: some View {
        HStack(spacing: 8) {
            // Rakhi preview
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: rakhi.colors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 32, height: 32)
                
                Image(systemName: "gift.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(.white)
            }
            
            // Rakhi info
            VStack(alignment: .leading, spacing: 2) {
                Text(rakhi.title.components(separatedBy: " • ").first ?? "")
                    .font(.system(.caption, design: .rounded).weight(.medium))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                
                HStack(spacing: 6) {
                    Text("\(rakhi.culturalScore, specifier: "%.1f")")
                        .font(.system(.caption2, design: .rounded).weight(.bold))
                        .foregroundStyle(.orange)
                    
                    Text("⭐")
                        .font(.system(.caption2))
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
    }
}

struct MediumRakhiCard: View {
    let rakhi: WatchRakhiDisplay
    
    var body: some View {
        VStack(spacing: 8) {
            // Rakhi display
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: rakhi.colors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 80)
                
                VStack(spacing: 4) {
                    Image(systemName: "gift.circle.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(.white)
                    
                    if let blessing = rakhi.title.components(separatedBy: " • ").last {
                        Text(blessing)
                            .font(.system(.caption2, design: .rounded))
                            .foregroundStyle(.white.opacity(0.9))
                    }
                }
            }
            
            // Rakhi details
            VStack(spacing: 4) {
                Text(rakhi.title.components(separatedBy: " • ").first ?? "")
                    .font(.system(.caption, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                
                HStack {
                    Text("⭐ \(rakhi.culturalScore, specifier: "%.1f")")
                        .font(.system(.caption2, design: .rounded))
                        .foregroundStyle(.orange)
                    
                    Spacer()
                    
                    Text(rakhi.createdAt, style: .relative)
                        .font(.system(.caption2, design: .rounded))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(8)
    }
}

struct DetailedRakhiCard: View {
    let rakhi: WatchRakhiDisplay
    @StateObject private var displayService = EnhancedRakhiWatchDisplayService.shared
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Main rakhi display
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            RadialGradient(
                                colors: rakhi.colors + [rakhi.colors.first?.opacity(0.3) ?? .clear],
                                center: .center,
                                startRadius: 20,
                                endRadius: 80
                            )
                        )
                        .frame(height: 120)
                    
                    VStack(spacing: 8) {
                        Image(systemName: "gift.circle.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.3), radius: 2)
                        
                        if let animation = rakhi.animation, displayService.watchDisplaySettings.animationsEnabled {
                            AnimationIndicator(animation: animation)
                        }
                    }
                }
                
                // Rakhi details
                VStack(spacing: 8) {
                    Text(rakhi.title.components(separatedBy: " • ").first ?? "")
                        .font(.system(.subheadline, design: .rounded).weight(.bold))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing: 12) {
                        ScoreBadge(
                            label: "Cultural",
                            score: rakhi.culturalScore,
                            color: .green
                        )
                        
                        ScoreBadge(
                            label: "Elements",
                            score: Double(rakhi.culturalElements.count),
                            color: .blue,
                            isCount: true
                        )
                    }
                    
                    Text(rakhi.createdAt, style: .relative)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                }
                
                // Cultural elements (if space allows)
                if !rakhi.culturalElements.isEmpty && displayService.watchDisplaySettings.maxVisibleElements > 3 {
                    CulturalElementsPreview(elements: rakhi.culturalElements)
                }
            }
            .padding(8)
        }
    }
}

// MARK: - Supporting Views

struct EmptyWatchState: View {
    @StateObject private var localization = SimpleLocalizationService.shared
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "applewatch")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            
            Text("No Rakhis on Watch")
                .font(.system(.subheadline, design: .rounded).weight(.semibold))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
            
            Text("Create a Rakhi on your iPhone to see it here")
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct RakhiNavigationControls: View {
    @StateObject private var displayService = EnhancedRakhiWatchDisplayService.shared
    
    private var currentIndex: Int {
        guard let current = displayService.currentRakhi else { return 0 }
        return displayService.displayedRakhis.firstIndex(where: { $0.id == current.id }) ?? 0
    }
    
    var body: some View {
        HStack {
            Button {
                navigateToPrevious()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.caption)
            }
            .disabled(currentIndex == 0)
            
            Spacer()
            
            Text("\(currentIndex + 1) of \(displayService.displayedRakhis.count)")
                .font(.system(.caption2, design: .rounded))
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Button {
                navigateToNext()
            } label: {
                Image(systemName: "chevron.right")
                    .font(.caption)
            }
            .disabled(currentIndex >= displayService.displayedRakhis.count - 1)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    private func navigateToPrevious() {
        guard currentIndex > 0 else { return }
        let newRakhi = displayService.displayedRakhis[currentIndex - 1]
        displayService.selectRakhi(newRakhi)
    }
    
    private func navigateToNext() {
        guard currentIndex < displayService.displayedRakhis.count - 1 else { return }
        let newRakhi = displayService.displayedRakhis[currentIndex + 1]
        displayService.selectRakhi(newRakhi)
    }
}

struct AnimationIndicator: View {
    let animation: WatchAnimation
    @State private var isAnimating = false
    
    var body: some View {
        Group {
            switch animation.type {
            case .pulse:
                Circle()
                    .stroke(.white.opacity(0.6), lineWidth: 2)
                    .frame(width: 60, height: 60)
                    .scaleEffect(isAnimating ? 1.2 : 1.0)
                    .opacity(isAnimating ? 0.3 : 0.8)
            case .glow:
                Circle()
                    .fill(.white.opacity(0.2))
                    .frame(width: 70, height: 70)
                    .blur(radius: isAnimating ? 10 : 5)
            case .shimmer:
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [.clear, .white.opacity(0.4), .clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 60, height: 2)
                    .offset(x: isAnimating ? 30 : -30)
            case .subtle:
                Circle()
                    .stroke(.white.opacity(0.3), lineWidth: 1)
                    .frame(width: 65, height: 65)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
            }
        }
        .animation(
            .easeInOut(duration: animation.duration).repeatForever(autoreverses: true),
            value: isAnimating
        )
        .onAppear {
            isAnimating = true
        }
    }
}

struct ScoreBadge: View {
    let label: String
    let score: Double
    let color: Color
    var isCount: Bool = false
    
    var body: some View {
        VStack(spacing: 2) {
            Text(isCount ? "\(Int(score))" : "\(score, specifier: "%.1f")")
                .font(.system(.caption2, design: .rounded).weight(.bold))
                .foregroundStyle(color)
            
            Text(label)
                .font(.system(.caption2, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 4)
        .background(color.opacity(0.15), in: RoundedRectangle(cornerRadius: 6))
    }
}

struct CulturalElementsPreview: View {
    let elements: [WatchCulturalElement]
    
    private var topElements: [WatchCulturalElement] {
        Array(elements.sorted { $0.significance > $1.significance }.prefix(3))
    }
    
    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text("Cultural Elements")
                    .font(.system(.caption, design: .rounded).weight(.medium))
                    .foregroundStyle(.primary)
                
                Spacer()
            }
            
            HStack(spacing: 4) {
                ForEach(topElements, id: \.name) { element in
                    Text(getElementSymbol(element.category))
                        .font(.caption2)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(.orange.opacity(0.2), in: RoundedRectangle(cornerRadius: 4))
                }
                
                if elements.count > 3 {
                    Text("+\(elements.count - 3)")
                        .font(.system(.caption2, design: .rounded))
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
    }
    
    private func getElementSymbol(_ category: WatchElementCategory) -> String {
        switch category {
        case .focal: return "⭐"
        case .ornamental: return "💎"
        case .binding: return "🧵"
        case .accent: return "✨"
        case .symbolic: return "🕉️"
        case .sacred: return "🙏"
        }
    }
}

// MARK: - Display Mode Selector

struct DisplayModeSelector: View {
    @StateObject private var displayService = EnhancedRakhiWatchDisplayService.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                ForEach(WatchDisplayMode.allCases, id: \.self) { mode in
                    DisplayModeButton(
                        mode: mode,
                        isSelected: displayService.displayMode == mode
                    ) {
                        displayService.switchDisplayMode(to: mode)
                        dismiss()
                    }
                }
            }
            .padding(.horizontal, 8)
            .navigationTitle("Display")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.caption)
                }
            }
        }
    }
}

struct DisplayModeButton: View {
    let mode: WatchDisplayMode
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack {
                Image(systemName: getModeIcon())
                    .font(.caption)
                    .foregroundStyle(isSelected ? .orange : .primary)
                
                Text(mode.displayName)
                    .font(.system(.caption, design: .rounded).weight(.medium))
                    .foregroundStyle(isSelected ? .orange : .primary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.caption2)
                        .foregroundStyle(.orange)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? .orange.opacity(0.1) : .clear, in: RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
    
    private func getModeIcon() -> String {
        switch mode {
        case .gallery: return "square.grid.2x2"
        case .single: return "rectangle"
        case .carousel: return "circle.grid.cross"
        case .minimal: return "circle"
        }
    }
}

#Preview {
    EnhancedRakhiWatchView()
}