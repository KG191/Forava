import Foundation
import SwiftUI

// MARK: - Mock Generation Extensions for Demo
extension AIRakhiService {

    internal func generateMockImage(prompt: AIPrompt) async throws -> AIImageResult {
        print("[AIRakhiService] Using mock generation for demo purposes")

        // Simulate API delay
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        generationProgress = 0.5

        try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
        generationProgress = 0.8

        // Create mock image data
        let mockImageData = createMockImageData()

        return AIImageResult(
            imageData: mockImageData,
            width: 512,
            height: 512,
            format: "png",
            qualityScore: 0.85,
            seed: Int.random(in: 1...100000),
            model: "mock-model-v1"
        )
    }

    private func createMockImageData() -> Data {
        // Create a simple colored rectangle as mock image data
        let size = CGSize(width: 512, height: 512)
        let renderer = UIGraphicsImageRenderer(size: size)

        let image = renderer.image { context in
            // Create a gradient background
            let colors = [UIColor.orange, UIColor.red, UIColor.yellow]
            let locations: [CGFloat] = [0, 0.5, 1]

            guard let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: colors.map { $0.cgColor } as CFArray,
                locations: locations
            ) else { return }

            context.cgContext.drawRadialGradient(
                gradient,
                startCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                startRadius: 0,
                endCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                endRadius: min(size.width, size.height) / 2,
                options: []
            )

            // Add some decorative elements
            context.cgContext.setFillColor(UIColor.gold.cgColor)
            let circleSize: CGFloat = 40
            for index in 0..<8 {
                let angle = Double(index) * .pi / 4
                let centerX = size.width / 2 + cos(angle) * 100
                let centerY = size.height / 2 + sin(angle) * 100

                let circle = CGRect(
                    x: centerX - circleSize / 2,
                    y: centerY - circleSize / 2,
                    width: circleSize,
                    height: circleSize
                )
                context.cgContext.fillEllipse(in: circle)
            }

            // Add central element
            context.cgContext.setFillColor(UIColor.darkRed.cgColor)
            let centerRect = CGRect(
                x: size.width / 2 - 30,
                y: size.height / 2 - 30,
                width: 60,
                height: 60
            )
            context.cgContext.fillEllipse(in: centerRect)
        }

        return image.pngData() ?? Data()
    }

    internal func generateAnimationFrames(for imageResult: AIImageResult) async throws -> [AnimationFrame] {
        // Create simple animation frames
        var frames: [AnimationFrame] = []
        let frameCount = 30 // 1 second at 30 FPS

        for frameIndex in 0..<frameCount {
            let progress = Double(frameIndex) / Double(frameCount)

            var frame = AnimationFrame(timestamp: progress)
            frame.effects.append(FadeEffect(alpha: min(progress * 2, 1.0)))

            if frameIndex > 15 {
                let glowIntensity = sin((progress - 0.5) * 2 * .pi) * 0.3 + 0.3
                frame.effects.append(GlowEffect(type: .elegant, intensity: glowIntensity))
            }

            frames.append(frame)
        }

        return frames
    }
}

// MARK: - Color Extensions
extension UIColor {
    static let gold = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
    static let darkRed = UIColor(red: 0.8, green: 0.1, blue: 0.1, alpha: 1.0)
}
