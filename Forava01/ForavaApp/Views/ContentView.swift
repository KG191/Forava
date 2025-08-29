import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: Background gradient — orange → light‑orange → deeper orange
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color(hex: "#FF8A00"), location: 0.00),  // vivid orange (top)
                        .init(color: Color(hex: "#FFC170"), location: 0.52),  // light amber (middle)
                        .init(color: Color(hex: "#E05A00"), location: 1.00)   // deeper orange (bottom)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Push content toward the top area
                    Spacer().frame(height: 24)

                    // MARK: Large, centered Rakhi hero
                    Image("rakhi_hero")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 399, height: 280) // ⬅️ tweak these to taste (keeps aspect via scaledToFit)
                        .shadow(color: .black.opacity(0.18), radius: 16, y: 6)
                        .frame(maxWidth: .infinity, alignment: .center) // ensure horizontal centering
                        .padding(.top, 6)

                    // MARK: Title with dynamic color glance effect
                    AnimatedTitleView()
                        .padding(.top, 18)

                    // Push buttons to the bottom
                    Spacer()

                    // MARK: CTA buttons
                    VStack(spacing: 16) {
                        NavigationLink {
                            OnboardingView()
                        } label: {
                            Text("Start a Connection")
                                .font(.system(.title3, design: .rounded).weight(.semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 30)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(ForavaPrimaryButton())

                        NavigationLink {
                            SettingsView()
                        } label: {
                            Text("Settings")
                                .font(.system(.title3, design: .rounded).weight(.semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 30)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(ForavaSecondaryButton())
                    }
                    .padding(.horizontal, 28)
                    .padding(.bottom, 42)
                }
            }
            .toolbar(.hidden, for: .navigationBar) // clean landing page
        }
    }
}

// MARK: - Button Styles

struct ForavaPrimaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(Color(hex: "#C9431A")) // warm red‑orange text
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color(hex: "#FFF0DC")) // warm cream (avoid stark white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(.white.opacity(configuration.isPressed ? 0.35 : 0.22), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .shadow(color: .black.opacity(0.18), radius: 14, y: 8)
    }
}

struct ForavaSecondaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.white)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(.white.opacity(0.20)) // frosted orange
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(.white.opacity(configuration.isPressed ? 0.35 : 0.22), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .shadow(color: .black.opacity(0.10), radius: 12, y: 6)
    }
}

// MARK: - Animated Title View with Dynamic Color Glance
struct AnimatedTitleView: View {
    @State private var animationOffset: CGFloat = -250
    @State private var glowIntensity: Double = 0.2
    
    var body: some View {
        ZStack {
            // Base title text (white)
            Text("Forava")
                .font(.system(size: 99, weight: .semibold, design: .serif))
                .kerning(0.5)
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.12), radius: 6, y: 2)
            
            // Dynamic color overlay with animated glance effect
            Text("Forava")
                .font(.system(size: 99, weight: .semibold, design: .serif))
                .kerning(0.5)
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .clear,
                            Color(red: 0.9, green: 0.2, blue: 0.1), // Deep red
                            Color(red: 1.0, green: 0.4, blue: 0.0), // Vibrant orange
                            Color(red: 0.95, green: 0.3, blue: 0.05), // Red-orange blend
                            .clear
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .mask(
                    // Moving glance effect - wider for more noticeable color
                    Rectangle()
                        .frame(width: 180)  // Wider glance area
                        .blur(radius: 20)   // Softer edges for smooth transition
                        .offset(x: animationOffset)
                )
                .shadow(color: Color(red: 1.0, green: 0.4, blue: 0.0).opacity(glowIntensity), radius: 12, y: 0)
                .onAppear {
                    startAnimation()
                }
        }
    }
    
    private func startAnimation() {
        // Initial delay before first glance
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            performGlanceAnimation()
        }
    }
    
    private func performGlanceAnimation() {
        // Animate the glance effect - slow and noticeable
        withAnimation(.easeInOut(duration: 2.5)) {
            animationOffset = 250  // Move further right to fully clear the text
            glowIntensity = 1.0    // Maximum intensity for very noticeable colors
        }
        
        // Reset and schedule next animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            // Instantly reset position without animation to prevent reverse flicker
            animationOffset = -300  // Reset to start position immediately
            glowIntensity = 0.0     // Clear any residual color instantly
            
            // Restore base glow and schedule next glance
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                glowIntensity = 0.2
                
                // Schedule next glance with longer pause
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    performGlanceAnimation()
                }
            }
        }
    }
}

// MARK: - Hex Color helper
extension Color {
    init(hex: String) {
        let s = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var i: UInt64 = 0
        Scanner(string: s).scanHexInt64(&i)
        let a, r, g, b: UInt64
        switch s.count {
        case 3: (a, r, g, b) = (255, (i >> 8) * 17, ((i >> 4) & 0xF) * 17, (i & 0xF) * 17)
        case 6: (a, r, g, b) = (255, i >> 16, (i >> 8) & 0xFF, i & 0xFF)
        case 8: (a, r, g, b) = (i >> 24, (i >> 16) & 0xFF, (i >> 8) & 0xFF, i & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

#Preview {
    ContentView()
}
