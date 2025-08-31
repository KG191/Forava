import Foundation

// MARK: - Cultural Animation Frame Generator
class CulturalAnimationGenerator {
    static let shared = CulturalAnimationGenerator()

    private init() {}

    func generateFrames(
        for imageResult: CulturalImageResult,
        with style: CulturalAnimationStyle,
        in context: CulturalContext
    ) async throws -> [CulturalAnimationFrame] {
        var frames: [CulturalAnimationFrame] = []
        let frameCount = Int(style.duration * 30) // 30 FPS

        for frameIndex in 0..<frameCount {
            let progress = Double(frameIndex) / Double(frameCount)

            var frame = CulturalAnimationFrame(
                timestamp: progress,
                culturalContext: context.identifier,
                effectTemplates: []
            )

            // Add effects based on cultural animation style
            frame.effectTemplates = generateEffectTemplates(
                for: style.effects,
                at: progress,
                frameIndex: frameIndex,
                frameCount: frameCount,
                context: context
            )

            frames.append(frame)
        }

        return frames
    }

    private func generateEffectTemplates(
        for effects: [String],
        at progress: Double,
        frameIndex: Int,
        frameCount: Int,
        context: CulturalContext
    ) -> [AnimationEffectTemplate] {
        var templates: [AnimationEffectTemplate] = []

        for effectType in effects {
            switch effectType {
            case "fade":
                templates.append(createFadeEffect(progress: progress))
            case "glow":
                if let glowEffect = createGlowEffect(progress: progress, frameIndex: frameIndex, frameCount: frameCount) {
                    templates.append(glowEffect)
                }
            case "sparkle":
                if let sparkleEffect = createSparkleEffect(progress: progress) {
                    templates.append(sparkleEffect)
                }
            case "blessing":
                if let blessingEffect = createBlessingEffect(progress: progress, context: context) {
                    templates.append(blessingEffect)
                }
            default:
                break
            }
        }

        return templates
    }

    private func createFadeEffect(progress: Double) -> AnimationEffectTemplate {
        return AnimationEffectTemplate(
            effectType: "fade",
            startTime: progress,
            endTime: min(progress + 0.5, 1.0),
            maxIntensity: min(progress * 2, 1.0)
        )
    }

    private func createGlowEffect(progress: Double, frameIndex: Int, frameCount: Int) -> AnimationEffectTemplate? {
        guard frameIndex > frameCount / 2 else { return nil }

        let glowIntensity = sin((progress - 0.5) * 2 * .pi) * 0.3 + 0.3
        return AnimationEffectTemplate(
            effectType: "glow",
            startTime: progress,
            endTime: min(progress + 0.3, 1.0),
            maxIntensity: glowIntensity,
            parameters: ["type": "elegant"]
        )
    }

    private func createSparkleEffect(progress: Double) -> AnimationEffectTemplate? {
        guard progress > 0.3 else { return nil }

        return AnimationEffectTemplate(
            effectType: "sparkle",
            startTime: progress,
            endTime: min(progress + 0.2, 1.0),
            maxIntensity: progress * 0.5
        )
    }

    private func createBlessingEffect(progress: Double, context: CulturalContext) -> AnimationEffectTemplate? {
        guard context.identifier == "rakhi_indian" && progress > 0.6 else { return nil }

        return AnimationEffectTemplate(
            effectType: "blessing",
            startTime: progress,
            endTime: 1.0,
            maxIntensity: (progress - 0.6) * 2.5,
            parameters: ["cultural": "rakhi_indian"]
        )
    }
}
