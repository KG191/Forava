import SwiftUI

// MARK: - Shared Button Styles

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

// MARK: - Legacy Button Styles (for backward compatibility)

struct ForavaPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        ForavaPrimaryButton().makeBody(configuration: configuration)
    }
}

struct ForavaSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        ForavaSecondaryButton().makeBody(configuration: configuration)
    }
}

// Note: Color extension is already defined in ContentView.swift