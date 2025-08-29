import SwiftUI

struct AnimationPreviewView: View {
    let animation: GeneratedAnimation
    @State private var currentFrame = 0
    @State private var isPlaying = false
    @State private var animationTimer: Timer?
    @State private var showingDetails = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Preview Header
            AnimationHeaderView(
                animation: animation,
                isPlaying: isPlaying,
                showingDetails: $showingDetails
            )
            
            // Animation Preview Area
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.regularMaterial)
                    .frame(width: 280, height: 320)
                
                VStack(spacing: 16) {
                    // Watch Frame Simulation
                    WatchFrameView(
                        animation: animation,
                        currentFrame: currentFrame,
                        isPlaying: isPlaying
                    )
                    
                    // Frame Info
                    FrameInfoView(
                        currentFrame: currentFrame,
                        totalFrames: animation.frames.count,
                        duration: animation.duration
                    )
                }
            }
            
            // Control Panel
            AnimationControlsView(
                isPlaying: isPlaying,
                onPlayPause: togglePlayback,
                onRestart: restartAnimation,
                onFrameStep: stepFrame
            )
            
            // Animation Details (if showing)
            if showingDetails {
                AnimationDetailsView(animation: animation)
                    .transition(.slide)
            }
        }
        .padding()
        .onDisappear {
            stopAnimation()
        }
    }
    
    private func togglePlayback() {
        if isPlaying {
            stopAnimation()
        } else {
            startAnimation()
        }
    }
    
    private func startAnimation() {
        isPlaying = true
        let frameDuration = animation.duration / Double(animation.frames.count)
        
        animationTimer = Timer.scheduledTimer(withTimeInterval: frameDuration, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.1)) {
                currentFrame = (currentFrame + 1) % animation.frames.count
            }
        }
    }
    
    private func stopAnimation() {
        isPlaying = false
        animationTimer?.invalidate()
        animationTimer = nil
    }
    
    private func restartAnimation() {
        stopAnimation()
        currentFrame = 0
        startAnimation()
    }
    
    private func stepFrame() {
        currentFrame = (currentFrame + 1) % animation.frames.count
    }
}

struct AnimationHeaderView: View {
    let animation: GeneratedAnimation
    let isPlaying: Bool
    @Binding var showingDetails: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(animation.animationType.displayName)
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)
                
                Text("Apple Watch Preview")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                // Battery impact indicator
                BatteryImpactIndicator(impact: animation.metadata.batteryImpact)
                
                // Details toggle
                Button(action: { showingDetails.toggle() }) {
                    Image(systemName: showingDetails ? "info.circle.fill" : "info.circle")
                        .font(.system(.title3))
                        .foregroundStyle(.orange)
                }
            }
        }
    }
}

struct WatchFrameView: View {
    let animation: GeneratedAnimation
    let currentFrame: Int
    let isPlaying: Bool
    
    var body: some View {
        ZStack {
            // Apple Watch frame simulation
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black)
                .frame(width: 200, height: 240)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                }
            
            // Animation content area
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .frame(width: 180, height: 220)
                .overlay {
                    AnimationFrameContent(
                        animation: animation,
                        frameIndex: currentFrame,
                        isPlaying: isPlaying
                    )
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))
            
            // Watch crown simulation
            Circle()
                .fill(Color.gray)
                .frame(width: 12, height: 12)
                .offset(x: 106, y: -20)
            
            // Digital crown
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray)
                .frame(width: 8, height: 16)
                .offset(x: 108, y: 20)
        }
    }
}

struct AnimationFrameContent: View {
    let animation: GeneratedAnimation
    let frameIndex: Int
    let isPlaying: Bool
    
    var body: some View {
        ZStack {
            // Base Rakhi image
            RakhiImageView(rakhi: animation.baseRakhi)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Animation effects overlay
            if frameIndex < animation.frames.count {
                EffectsOverlayView(
                    effects: animation.frames[frameIndex].effects,
                    isPlaying: isPlaying
                )
            }
            
            // Cultural elements indicator
            if !animation.metadata.culturalElements.isEmpty {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        CulturalElementsIndicator(elements: animation.metadata.culturalElements)
                    }
                }
                .padding(8)
            }
        }
    }
}

struct RakhiImageView: View {
    let rakhi: GeneratedRakhi
    
    var body: some View {
        // Placeholder for actual Rakhi image
        ZStack {
            LinearGradient(
                colors: [.orange.opacity(0.3), .red.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 8) {
                Image(systemName: "circle.badge.checkmark.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(.orange)
                
                Text("Generated Rakhi")
                    .font(.system(.caption, design: .rounded).weight(.medium))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct EffectsOverlayView: View {
    let effects: [FrameEffect]
    let isPlaying: Bool
    
    var body: some View {
        ZStack {
            ForEach(Array(effects.enumerated()), id: \.offset) { index, effect in
                EffectView(effect: effect, isPlaying: isPlaying)
            }
        }
    }
}

struct EffectView: View {
    let effect: FrameEffect
    let isPlaying: Bool
    
    var body: some View {
        switch effect {
        case .glow(let intensity, let color, let radius):
            GlowEffectView(intensity: intensity, color: color, radius: radius, isPlaying: isPlaying)
            
        case .sparkle(let density, let size, let points):
            SparkleEffectView(density: density, size: size, points: points, isPlaying: isPlaying)
            
        case .scale(let factor, let anchor):
            ScaleEffectView(factor: factor, anchor: anchor)
            
        case .opacity(let alpha):
            OpacityEffectView(alpha: alpha)
            
        case .shimmer(let direction, let speed, let intensity, let regions):
            ShimmerEffectView(direction: direction, speed: speed, intensity: intensity, regions: regions, isPlaying: isPlaying)
            
        case .aura(let color, let intensity, let pulseDuration):
            AuraEffectView(color: color, intensity: intensity, pulseDuration: pulseDuration, isPlaying: isPlaying)
            
        case .particle(let type, let count, let lifetime):
            ParticleEffectView(type: type, count: count, lifetime: lifetime, isPlaying: isPlaying)
        }
    }
}

struct GlowEffectView: View {
    let intensity: Float
    let color: Color
    let radius: Float
    let isPlaying: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(color.opacity(0.1))
            .blur(radius: CGFloat(radius))
            .opacity(isPlaying ? Double(intensity) : 0.5)
            .animation(.easeInOut(duration: 0.3), value: isPlaying)
    }
}

struct SparkleEffectView: View {
    let density: Float
    let size: Float
    let points: [CGPoint]
    let isPlaying: Bool
    
    var body: some View {
        ZStack {
            ForEach(0..<Int(density * 10), id: \.self) { index in
                Circle()
                    .fill(.white)
                    .frame(width: CGFloat(size), height: CGFloat(size))
                    .position(x: CGFloat.random(in: 0...180), y: CGFloat.random(in: 0...220))
                    .opacity(isPlaying ? Double.random(in: 0.3...1.0) : 0.5)
                    .animation(
                        .easeInOut(duration: Double.random(in: 0.5...1.5)).repeatForever(autoreverses: true),
                        value: isPlaying
                    )
            }
        }
    }
}

struct ScaleEffectView: View {
    let factor: Float
    let anchor: UnitPoint
    
    var body: some View {
        Color.clear
            .scaleEffect(CGFloat(factor), anchor: anchor)
    }
}

struct OpacityEffectView: View {
    let alpha: Float
    
    var body: some View {
        Color.clear
            .opacity(Double(alpha))
    }
}

struct ShimmerEffectView: View {
    let direction: ShimmerDirection
    let speed: Float
    let intensity: Float
    let regions: [CGRect]
    let isPlaying: Bool
    
    @State private var shimmerOffset: CGFloat = -200
    
    var body: some View {
        ZStack {
            ForEach(Array(regions.enumerated()), id: \.offset) { _, region in
                RoundedRectangle(cornerRadius: 4)
                    .fill(
                        LinearGradient(
                            colors: [.clear, .white.opacity(Double(intensity)), .clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: region.width, height: region.height)
                    .position(x: region.midX, y: region.midY)
                    .offset(x: shimmerOffset)
            }
        }
        .onAppear {
            if isPlaying {
                startShimmer()
            }
        }
        .onChange(of: isPlaying) { _, newValue in
            if newValue {
                startShimmer()
            }
        }
    }
    
    private func startShimmer() {
        withAnimation(.linear(duration: Double(2.0 / speed)).repeatForever(autoreverses: false)) {
            shimmerOffset = 200
        }
    }
}

struct AuraEffectView: View {
    let color: Color
    let intensity: Float
    let pulseDuration: TimeInterval
    let isPlaying: Bool
    
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [color.opacity(Double(intensity)), .clear],
                    center: .center,
                    startRadius: 20,
                    endRadius: 80
                )
            )
            .scaleEffect(pulseScale)
            .onAppear {
                if isPlaying {
                    startPulse()
                }
            }
            .onChange(of: isPlaying) { _, newValue in
                if newValue {
                    startPulse()
                }
            }
    }
    
    private func startPulse() {
        withAnimation(.easeInOut(duration: pulseDuration).repeatForever(autoreverses: true)) {
            pulseScale = 1.2
        }
    }
}

struct ParticleEffectView: View {
    let type: ParticleType
    let count: Int
    let lifetime: TimeInterval
    let isPlaying: Bool
    
    var body: some View {
        ZStack {
            ForEach(0..<count, id: \.self) { index in
                ParticleView(type: type, lifetime: lifetime, isPlaying: isPlaying)
            }
        }
    }
}

struct ParticleView: View {
    let type: ParticleType
    let lifetime: TimeInterval
    let isPlaying: Bool
    
    @State private var offset = CGSize.zero
    @State private var opacity: Double = 1.0
    
    var body: some View {
        particleShape
            .offset(offset)
            .opacity(opacity)
            .onAppear {
                if isPlaying {
                    startParticleAnimation()
                }
            }
            .onChange(of: isPlaying) { _, newValue in
                if newValue {
                    startParticleAnimation()
                }
            }
    }
    
    @ViewBuilder
    private var particleShape: some View {
        switch type {
        case .blessing:
            Image(systemName: "sparkles")
                .font(.system(.caption))
                .foregroundStyle(.gold)
        case .sparkle:
            Circle()
                .fill(.white)
                .frame(width: 3, height: 3)
        case .light:
            Circle()
                .fill(.yellow)
                .frame(width: 2, height: 2)
        }
    }
    
    private func startParticleAnimation() {
        let randomOffset = CGSize(
            width: CGFloat.random(in: -50...50),
            height: CGFloat.random(in: -100...100)
        )
        
        withAnimation(.easeOut(duration: lifetime)) {
            offset = randomOffset
            opacity = 0.0
        }
    }
}

struct FrameInfoView: View {
    let currentFrame: Int
    let totalFrames: Int
    let duration: TimeInterval
    
    var body: some View {
        HStack(spacing: 16) {
            Text("Frame \(currentFrame + 1)/\(totalFrames)")
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Text("\(duration, specifier: "%.1f")s")
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 20)
    }
}

struct AnimationControlsView: View {
    let isPlaying: Bool
    let onPlayPause: () -> Void
    let onRestart: () -> Void
    let onFrameStep: () -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            Button(action: onRestart) {
                Image(systemName: "arrow.counterclockwise")
                    .font(.system(.title2))
                    .foregroundStyle(.orange)
            }
            
            Button(action: onFrameStep) {
                Image(systemName: "step.forward")
                    .font(.system(.title2))
                    .foregroundStyle(.orange)
            }
            
            Button(action: onPlayPause) {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(.title))
                    .foregroundStyle(.white)
                    .frame(width: 50, height: 50)
                    .background(.orange, in: Circle())
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct BatteryImpactIndicator: View {
    let impact: BatteryImpact
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: batteryIcon)
                .font(.system(.caption))
                .foregroundStyle(impact.color)
            
            Text(impact.description)
                .font(.system(.caption2, design: .rounded))
                .foregroundStyle(impact.color)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(impact.color.opacity(0.1), in: Capsule())
    }
    
    private var batteryIcon: String {
        switch impact {
        case .minimal: return "battery.100"
        case .moderate: return "battery.75"
        case .high: return "battery.25"
        }
    }
}

struct CulturalElementsIndicator: View {
    let elements: [CulturalElement]
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.circle.fill")
                .font(.system(.caption2))
                .foregroundStyle(.gold)
            
            Text("\(elements.count) cultural")
                .font(.system(.caption2, design: .rounded))
                .foregroundStyle(.gold)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(.gold.opacity(0.1), in: Capsule())
    }
}

struct AnimationDetailsView: View {
    let animation: GeneratedAnimation
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Animation Details")
                .font(.system(.headline, design: .rounded).weight(.semibold))
                .foregroundStyle(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                DetailItem(label: "Frames", value: "\(animation.frames.count)")
                DetailItem(label: "Duration", value: "\(animation.duration, specifier: "%.1f")s")
                DetailItem(label: "Device", value: animation.targetDevice.rawValue)
                DetailItem(label: "Size", value: formatBytes(animation.metadata.totalSize))
            }
            
            if !animation.metadata.culturalElements.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Cultural Elements")
                        .font(.system(.subheadline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)
                    
                    ForEach(animation.metadata.culturalElements, id: \.self) { element in
                        Text("• \(element.significance)")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding(20)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
    
    private func formatBytes(_ bytes: Int) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(bytes))
    }
}

struct DetailItem: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(.title3, design: .rounded).weight(.bold))
                .foregroundStyle(.primary)
            
            Text(label)
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    AnimationPreviewView(
        animation: GeneratedAnimation(
            id: UUID(),
            baseRakhi: GeneratedRakhi(
                id: UUID(),
                designSpec: RakhiDesignSpec(genre: .traditional),
                mainImage: AIImageResult(
                    imageURL: "https://example.com/rakhi.jpg",
                    metadata: GenerationMetadata(
                        seed: 12345,
                        cfg_scale: 7.5,
                        steps: 30,
                        model: "sdxl_base_1.0",
                        timestamp: Date()
                    ),
                    processingTime: 2.0
                ),
                animationFrames: [],
                prompt: AIPrompt(
                    positive: "beautiful rakhi",
                    negative: "blurry",
                    cfg_scale: 7.5,
                    steps: 30,
                    seed: 12345,
                    width: 1024,
                    height: 1024
                ),
                createdAt: Date(),
                culturalScore: 0.8,
                qualityScore: 0.9
            ),
            animationType: .subtle_glow,
            frames: Array(0..<12).map { i in
                OptimizedAnimationFrame(
                    frameNumber: i,
                    timestamp: TimeInterval(i) * 0.25,
                    imageData: Data(),
                    compressionLevel: .medium,
                    effects: [.glow(intensity: Float(sin(Double(i) * 0.5)) * 0.5 + 0.5, color: .orange, radius: 10.0)]
                )
            },
            duration: 3.0,
            targetDevice: .series9_45mm,
            metadata: AnimationMetadata(
                frameCount: 12,
                totalSize: 245760,
                batteryImpact: .minimal,
                culturalElements: [.sacredCenter, .protectionThread]
            )
        )
    )
    .background(Color(.systemGroupedBackground))
}