import SwiftUI
import WatchConnectivity
import Combine

// MARK: - Supporting Types for Watch Animations

struct GeneratedAnimation {
    let id: UUID
    let frames: [AnimationFrame]
    let duration: Double
    let type: AnimationType
    
    enum AnimationType {
        case blessing
        case sparkle
        case pulse
        case cultural
    }
}

struct AnimationFrame {
    let timestamp: Double
    let effects: [FrameEffect]
}

struct FrameEffect {
    let type: EffectType
    let position: CGPoint
    let opacity: Double
    let scale: Double
    
    enum EffectType {
        case sparkle
        case blessing
        case pulse
        case glow
    }
}

// MARK: - Rakhi Watch Face View

struct RakhiWatchFaceView: View {
    let rakhi: RakhiGift
    @State private var isAnimating = false
    @State private var showingPaymentOptions = false
    @State private var currentAnimation: GeneratedAnimation?
    @State private var animationFrame = 0
    @State private var animationTimer: Timer?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Spacer()
                
                // Enhanced Rakhi Display with Animation Support
                ZStack {
                    // Base Rakhi Design
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [.orange, .red, .yellow],
                                center: .center,
                                startRadius: 5,
                                endRadius: 50
                            )
                        )
                        .frame(width: 100, height: 100)
                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
                    
                    // Center Symbol
                    Image(systemName: "gift.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 2)
                    
                    // Animation overlay
                    if let animation = currentAnimation {
                        AnimationOverlay(animation: animation, frame: animationFrame)
                    }
                }
                .onAppear {
                    startAnimation()
                }
                .onDisappear {
                    stopAnimation()
                }
                
                // Rakhi Info
                VStack(spacing: 8) {
                    Text(rakhi.rakhi.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                    
                    Text("From: \(rakhi.sender)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if let amount = rakhi.paymentAmount {
                        Text("₹\(amount, specifier: "%.0f")")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                }
                
                Spacer()
                
                // Action Button
                Button {
                    showingPaymentOptions = true
                } label: {
                    Text("Open Gift")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(.orange, in: RoundedRectangle(cornerRadius: 25))
                }
                .buttonStyle(.plain)
            }
            .padding()
            .navigationTitle("Rakhi Gift")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.caption)
                }
            }
        }
        .sheet(isPresented: $showingPaymentOptions) {
            PaymentOptionsView(rakhi: rakhi)
        }
    }
    
    private func startAnimation() {
        isAnimating = true
        currentAnimation = createSampleAnimation()
        
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            animationFrame = (animationFrame + 1) % 60 // 6 second loop
        }
    }
    
    private func stopAnimation() {
        isAnimating = false
        animationTimer?.invalidate()
        animationTimer = nil
    }
    
    private func createSampleAnimation() -> GeneratedAnimation {
        var frames: [AnimationFrame] = []
        
        for frameIndex in 0..<60 {
            let frame = AnimationFrame(
                timestamp: Double(frameIndex) * 0.1,
                effects: [
                    FrameEffect(
                        type: .sparkle,
                        position: CGPoint(x: 50, y: 50),
                        opacity: 0.7,
                        scale: 1.0
                    )
                ]
            )
            frames.append(frame)
        }
        
        return GeneratedAnimation(
            id: UUID(),
            frames: frames,
            duration: 6.0,
            type: .blessing
        )
    }
}

// MARK: - Animation Overlay

struct AnimationOverlay: View {
    let animation: GeneratedAnimation
    let frame: Int
    
    var currentFrame: AnimationFrame? {
        guard frame < animation.frames.count else { return nil }
        return animation.frames[frame]
    }
    
    var body: some View {
        ZStack {
            if let frame = currentFrame {
                ForEach(frame.effects.indices, id: \.self) { index in
                    EffectView(effect: frame.effects[index])
                }
            }
        }
    }
}

struct EffectView: View {
    let effect: FrameEffect
    
    var body: some View {
        Group {
            switch effect.type {
            case .sparkle:
                Text("✨")
                    .font(.caption)
            case .blessing:
                Text("🙏")
                    .font(.caption)
            case .pulse:
                Circle()
                    .stroke(.white.opacity(0.6), lineWidth: 1)
                    .frame(width: 20, height: 20)
            case .glow:
                Circle()
                    .fill(.white.opacity(0.3))
                    .frame(width: 15, height: 15)
                    .blur(radius: 3)
            }
        }
        .position(effect.position)
        .opacity(effect.opacity)
        .scaleEffect(effect.scale)
    }
}

// MARK: - Payment Options View

struct PaymentOptionsView: View {
    let rakhi: RakhiGift
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Rakhi summary
                VStack(spacing: 12) {
                    Text("🎊")
                        .font(.system(size: 48))
                    
                    Text(rakhi.rakhi.name)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    
                    Text("From \(rakhi.sender)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Payment amount
                if let amount = rakhi.paymentAmount {
                    VStack(spacing: 8) {
                        Text("Gift Amount")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("₹\(amount, specifier: "%.0f")")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                    .padding()
                    .background(.green.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
                }
                
                Spacer()
                
                // Action buttons
                VStack(spacing: 12) {
                    Button {
                        // Handle payment acceptance
                        dismiss()
                    } label: {
                        Text("Accept Gift")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(.green, in: RoundedRectangle(cornerRadius: 25))
                    }
                    .buttonStyle(.plain)
                    
                    Button("View Details") {
                        // Show more details
                    }
                    .font(.subheadline)
                    .foregroundColor(.blue)
                }
            }
            .padding()
            .navigationTitle("Payment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .font(.caption)
                }
            }
        }
    }
}

#Preview {
    RakhiWatchFaceView(
        rakhi: RakhiGift(
            rakhi: Rakhi(
                name: "Traditional Gold Thread",
                imageName: "rakhi_gold",
                description: "Beautiful traditional rakhi",
                price: 25.0,
                category: .traditional,
                colors: ["Gold", "Red"]
            ),
            sender: "Priya",
            recipient: "You",
            sentDate: Date(),
            status: .sent,
            paymentAmount: 101.0,
            message: "Happy Raksha Bandhan!"
        )
    )
}