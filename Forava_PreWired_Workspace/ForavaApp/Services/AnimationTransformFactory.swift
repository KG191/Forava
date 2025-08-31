import Foundation
import SwiftUI

// MARK: - Animation Transform Factory
struct AnimationTransformFactory {

    func createTransform(for type: AnimationType, progress: Double) -> AnimationTransform {
        switch type {
        case .threadWeaving:
            return createBasicTransform(scale: progress)
        case .beadPlacement:
            return createRotatingTransform(scale: min(progress * 1.2, 1.0), rotation: progress * 360)
        case .centerReveal:
            return createBasicTransform(scale: progress)
        case .decoration:
            return createRotatingTransform(scale: progress, rotation: progress * 180)
        case .touch:
            return createTouchTransform(progress: progress)
        case .shake:
            return createShakeTransform(progress: progress)
        case .rotate:
            return createRotatingTransform(scale: 1.0, rotation: progress * 360)
        case .zoom:
            return createBasicTransform(scale: 0.8 + (progress * 0.4))
        case .subtleGlow:
            return createPulseTransform(progress: progress, intensity: 0.02, frequency: 2)
        case .sparkleEffect:
            return createSparkleTransform(progress: progress)
        case .gentlePulse:
            return createPulseTransform(progress: progress, intensity: 0.08, frequency: 2)
        case .threadShimmer:
            return createShimmerTransform(progress: progress)
        case .culturalBlessing:
            return createBlessingTransform(progress: progress)
        case .custom:
            return createDefaultCustomTransform(progress: progress)
        }
    }

    private func createBasicTransform(scale: Double, rotation: Double = 0) -> AnimationTransform {
        return AnimationTransform(scale: scale, rotation: rotation, translation: .zero)
    }

    private func createRotatingTransform(scale: Double, rotation: Double) -> AnimationTransform {
        return AnimationTransform(scale: scale, rotation: rotation, translation: .zero)
    }

    private func createTouchTransform(progress: Double) -> AnimationTransform {
        return AnimationTransform(
            scale: 1.0 + (progress * 0.1),
            rotation: 0,
            translation: CGPoint(x: sin(progress * .pi * 2) * 2, y: 0)
        )
    }

    private func createShakeTransform(progress: Double) -> AnimationTransform {
        return AnimationTransform(
            scale: 1.0,
            rotation: sin(progress * .pi * 8) * 5,
            translation: CGPoint(x: sin(progress * .pi * 16) * 3, y: 0)
        )
    }

    private func createPulseTransform(progress: Double, intensity: Double, frequency: Double) -> AnimationTransform {
        return AnimationTransform(
            scale: 1.0 + (sin(progress * .pi * frequency) * intensity),
            rotation: 0,
            translation: .zero
        )
    }

    private func createSparkleTransform(progress: Double) -> AnimationTransform {
        return AnimationTransform(
            scale: 1.0 + (sin(progress * .pi * 4) * 0.05),
            rotation: progress * 45,
            translation: .zero
        )
    }

    private func createShimmerTransform(progress: Double) -> AnimationTransform {
        return AnimationTransform(
            scale: 1.0,
            rotation: 0,
            translation: CGPoint(x: sin(progress * .pi * 6) * 1, y: 0)
        )
    }

    private func createBlessingTransform(progress: Double) -> AnimationTransform {
        return AnimationTransform(
            scale: 1.0 + (sin(progress * .pi) * 0.1),
            rotation: progress * 15,
            translation: CGPoint(x: 0, y: -sin(progress * .pi) * 3)
        )
    }

    private func createDefaultCustomTransform(progress: Double) -> AnimationTransform {
        return AnimationTransform(
            scale: 1.0 + (sin(progress * .pi * 2) * 0.03),
            rotation: 0,
            translation: .zero
        )
    }
}
