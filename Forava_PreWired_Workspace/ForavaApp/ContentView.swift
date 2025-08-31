import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: Background gradient — orange → light‑orange → deeper orange
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color(hex: "#FF8A00"), location: 0.00),  // vivid orange (top)
                        .init(color: Color(hex: "#FFC170"), location: 0.75),  // light amber (middle)
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

                    // MARK: Title directly under the hero
                    Text("Forava")
                        .font(.system(size: 99, weight: .semibold, design: .serif))
                        .kerning(0.5)
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.12), radius: 6, y: 2)
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
