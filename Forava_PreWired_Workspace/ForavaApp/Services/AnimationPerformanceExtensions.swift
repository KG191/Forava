import Foundation
import UIKit

// MARK: - Performance Optimization Extensions
extension EnhancedAnimationService {

    func optimizeAnimationForDevice(_ animation: AnimationSequence) -> AnimationSequence {
        var optimizedAnimation = animation

        switch deviceCapabilities.performanceLevel {
        case .high:
            // No optimization needed
            break
        case .medium:
            optimizedAnimation = reduceFPS(optimizedAnimation, targetFPS: 30)
            optimizedAnimation = simplifyEffects(optimizedAnimation)
        case .low:
            optimizedAnimation = reduceFPS(optimizedAnimation, targetFPS: 24)
            optimizedAnimation = removeComplexEffects(optimizedAnimation)
            optimizedAnimation = reduceParticleCount(optimizedAnimation, factor: 0.5)
        }

        return optimizedAnimation
    }

    func preloadAnimation(_ animation: AnimationSequence) {
        let cacheKey = NSString(string: animation.id.uuidString)

        Task {
            let result = try? await processAnimationForCache(animation)
            if let result = result {
                animationCache.setObject(result, forKey: cacheKey)
            }
        }
    }

    func getCachedAnimation(id: UUID) -> AnimationResult? {
        let cacheKey = NSString(string: id.uuidString)
        return animationCache.object(forKey: cacheKey)
    }

    func clearAnimationCache() {
        animationCache.removeAllObjects()
    }

    func getMemoryUsage() -> AnimationMemoryInfo {
        return AnimationMemoryInfo(
            cacheSize: animationCache.totalCostLimit,
            activeAnimations: activeAnimations.count,
            queuedAnimations: animationQueue.count
        )
    }

    // MARK: - Private Optimization Methods

    private func reduceFPS(_ animation: AnimationSequence, targetFPS: Int) -> AnimationSequence {
        let sourceFrames = animation.frames
        let sourceFrameRate = animation.frameRate
        let skipFrames = max(1, Int(sourceFrameRate) / targetFPS)

        var optimizedFrames: [AnimationFrame] = []
        for (index, frame) in sourceFrames.enumerated() {
            if index % skipFrames == 0 {
                optimizedFrames.append(frame)
            }
        }

        var optimizedAnimation = animation
        optimizedAnimation.frames = optimizedFrames
        optimizedAnimation.frameRate = targetFPS

        return optimizedAnimation
    }

    private func simplifyEffects(_ animation: AnimationSequence) -> AnimationSequence {
        var simplifiedAnimation = animation

        for (index, frame) in animation.frames.enumerated() {
            var simplifiedFrame = frame
            simplifiedFrame.effects = frame.effects.filter { effect in
                effect.priority >= .medium
            }
            simplifiedAnimation.frames[index] = simplifiedFrame
        }

        return simplifiedAnimation
    }

    private func removeComplexEffects(_ animation: AnimationSequence) -> AnimationSequence {
        var simplifiedAnimation = animation

        for (index, frame) in animation.frames.enumerated() {
            var simplifiedFrame = frame
            simplifiedFrame.effects = frame.effects.filter { effect in
                effect.complexity <= .medium
            }
            simplifiedAnimation.frames[index] = simplifiedFrame
        }

        return simplifiedAnimation
    }

    private func reduceParticleCount(_ animation: AnimationSequence, factor: Double) -> AnimationSequence {
        var optimizedAnimation = animation

        for (index, frame) in animation.frames.enumerated() {
            var optimizedFrame = frame
            let targetCount = Int(Double(frame.overlayElements.count) * factor)

            if frame.overlayElements.count > targetCount {
                optimizedFrame.overlayElements = Array(frame.overlayElements.prefix(targetCount))
            }

            optimizedAnimation.frames[index] = optimizedFrame
        }

        return optimizedAnimation
    }

    private func processAnimationForCache(_ animation: AnimationSequence) async throws -> AnimationResult {
        // Simulate processing for cache
        let processedFrames = animation.frames.map { frame in
            var cachedFrame = frame
            cachedFrame.isCached = true
            return cachedFrame
        }

        return AnimationResult(
            id: animation.id,
            frames: processedFrames,
            metadata: AnimationMetadata(
                duration: animation.duration,
                frameRate: animation.frameRate,
                quality: animationQuality
            )
        )
    }
}
