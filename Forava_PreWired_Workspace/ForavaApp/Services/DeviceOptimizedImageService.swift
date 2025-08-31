import Foundation
import SwiftUI
import UIKit

// MARK: - Device Optimized Image Service
@MainActor
class DeviceOptimizedImageService: ObservableObject {
    static let shared = DeviceOptimizedImageService()
    
    private init() {}
    
    // MARK: - Device Format Specifications
    
    struct DeviceImageSpec {
        let width: Int
        let height: Int
        let aspectRatio: Double
        let cornerRadius: CGFloat
        let format: String
        let compressionQuality: CGFloat
        
        static let watchFace = DeviceImageSpec(
            width: 368, height: 448, 
            aspectRatio: 368.0/448.0,
            cornerRadius: 24, 
            format: "watch_face",
            compressionQuality: 0.9
        )
        
        static let phoneWallpaper = DeviceImageSpec(
            width: 1179, height: 2556,
            aspectRatio: 1179.0/2556.0,
            cornerRadius: 0,
            format: "phone_wallpaper", 
            compressionQuality: 0.95
        )
        
        static let phoneLockscreen = DeviceImageSpec(
            width: 1179, height: 2556,
            aspectRatio: 1179.0/2556.0,
            cornerRadius: 0,
            format: "phone_lockscreen",
            compressionQuality: 0.95
        )
    }
    
    // MARK: - Device-Optimized Generation
    
    func generateDeviceOptimizedImages(from culturalSpec: CulturalDesignSpec) async throws -> DeviceOptimizedImageSet {
        let culturalAIService = CulturalAIService.shared
        
        // Generate base cultural artwork
        let baseArtwork = try await culturalAIService.generateArtwork(from: culturalSpec)
        
        // Create device-specific versions
        let watchFaceImage = try await createWatchFaceVersion(from: baseArtwork)
        let phoneWallpaperImage = try await createPhoneWallpaperVersion(from: baseArtwork)
        let phoneLockscreenImage = try await createPhoneLockscreenVersion(from: baseArtwork)
        
        return DeviceOptimizedImageSet(
            baseArtwork: baseArtwork,
            watchFace: watchFaceImage,
            phoneWallpaper: phoneWallpaperImage,
            phoneLockscreen: phoneLockscreenImage,
            generatedAt: Date()
        )
    }
    
    // MARK: - Watch Face Optimization
    
    private func createWatchFaceVersion(from artwork: CulturalGeneratedArtwork) async throws -> DeviceSpecificImage {
        let spec = DeviceImageSpec.watchFace
        
        // Enhanced prompt for watch face suitability
        let watchOptimizedPrompt = buildWatchFacePrompt(from: artwork)
        
        // Generate watch-optimized image
        let watchImage = try await generateDeviceSpecificImage(
            prompt: watchOptimizedPrompt,
            spec: spec,
            culturalContext: artwork.culturalContext
        )
        
        return DeviceSpecificImage(
            image: watchImage,
            deviceType: .watchFace,
            spec: spec,
            culturalContext: artwork.culturalContext,
            optimizations: [
                "centered_design",
                "high_contrast",
                "rounded_corners",
                "clear_visibility",
                "minimal_text"
            ]
        )
    }
    
    private func buildWatchFacePrompt(from artwork: CulturalGeneratedArtwork) -> String {
        let basePrompt = artwork.metadata.prompt
        
        let watchOptimizations = [
            "watch face design",
            "centered composition", 
            "high contrast",
            "clear visibility at small size",
            "rounded rectangular format",
            "minimal text elements",
            "suitable for Apple Watch",
            "clean readable design",
            "optimized for wrist display",
            "professional watch face",
            "elegant timepiece background",
            "appropriate for daily wear"
        ]
        
        return basePrompt + ", " + watchOptimizations.joined(separator: ", ")
    }
    
    // MARK: - Phone Wallpaper Optimization
    
    private func createPhoneWallpaperVersion(from artwork: CulturalGeneratedArtwork) async throws -> DeviceSpecificImage {
        let spec = DeviceImageSpec.phoneWallpaper
        
        // Enhanced prompt for phone wallpaper suitability
        let wallpaperOptimizedPrompt = buildPhoneWallpaperPrompt(from: artwork)
        
        // Generate wallpaper-optimized image
        let wallpaperImage = try await generateDeviceSpecificImage(
            prompt: wallpaperOptimizedPrompt,
            spec: spec,
            culturalContext: artwork.culturalContext
        )
        
        return DeviceSpecificImage(
            image: wallpaperImage,
            deviceType: .phoneWallpaper,
            spec: spec,
            culturalContext: artwork.culturalContext,
            optimizations: [
                "vertical_composition",
                "app_icon_safe_areas",
                "gradient_fade",
                "wallpaper_optimized",
                "portrait_orientation"
            ]
        )
    }
    
    private func buildPhoneWallpaperPrompt(from artwork: CulturalGeneratedArtwork) -> String {
        let basePrompt = artwork.metadata.prompt
        
        let wallpaperOptimizations = [
            "phone wallpaper design",
            "vertical portrait composition",
            "suitable for iPhone background",
            "app icon compatible",
            "gradient background",
            "elegant phone wallpaper",
            "professional mobile background",
            "beautiful phone wallpaper",
            "suitable for home screen",
            "optimized for mobile display",
            "clean mobile wallpaper",
            "premium wallpaper quality"
        ]
        
        return basePrompt + ", " + wallpaperOptimizations.joined(separator: ", ")
    }
    
    // MARK: - Phone Lockscreen Optimization
    
    private func createPhoneLockscreenVersion(from artwork: CulturalGeneratedArtwork) async throws -> DeviceSpecificImage {
        let spec = DeviceImageSpec.phoneLockscreen
        
        // Enhanced prompt for lockscreen suitability
        let lockscreenOptimizedPrompt = buildPhoneLockscreenPrompt(from artwork)
        
        // Generate lockscreen-optimized image
        let lockscreenImage = try await generateDeviceSpecificImage(
            prompt: lockscreenOptimizedPrompt,
            spec: spec,
            culturalContext: artwork.culturalContext
        )
        
        return DeviceSpecificImage(
            image: lockscreenImage,
            deviceType: .phoneLockscreen,
            spec: spec,
            culturalContext: artwork.culturalContext,
            optimizations: [
                "lockscreen_safe_areas",
                "clock_compatible",
                "notification_friendly",
                "unlock_optimized",
                "privacy_appropriate"
            ]
        )
    }
    
    private func buildPhoneLockscreenPrompt(from artwork: CulturalGeneratedArtwork) -> String {
        let basePrompt = artwork.metadata.prompt
        
        let lockscreenOptimizations = [
            "phone lockscreen wallpaper",
            "vertical portrait composition",
            "suitable for iPhone lock screen",
            "clock and notification compatible",
            "elegant lockscreen background",
            "professional mobile lockscreen",
            "beautiful lock screen wallpaper",
            "suitable for daily use",
            "optimized for lock screen display",
            "clean lockscreen design",
            "premium lockscreen quality",
            "privacy-appropriate imagery"
        ]
        
        return basePrompt + ", " + lockscreenOptimizations.joined(separator: ", ")
    }
    
    // MARK: - Device-Specific Image Generation
    
    private func generateDeviceSpecificImage(
        prompt: String,
        spec: DeviceImageSpec,
        culturalContext: String
    ) async throws -> UIImage {
        
        // Use Replicate API for device-optimized generation
        let parameters: [String: Any] = [
            "prompt": prompt,
            "negative_prompt": buildDeviceNegativePrompt(for: spec),
            "width": spec.width,
            "height": spec.height,
            "guidance_scale": 7.5,
            "num_inference_steps": 30,
            "scheduler": "K_EULER",
            "num_outputs": 1,
            "high_noise_frac": 0.8
        ]
        
        // Mock implementation for demonstration
        // In production, this would call the actual Replicate API
        return try await generateMockDeviceImage(spec: spec, culturalContext: culturalContext)
    }
    
    private func buildDeviceNegativePrompt(for spec: DeviceImageSpec) -> String {
        var negativePrompts = [
            "blurry", "low quality", "distorted", "nsfw", "inappropriate content",
            "text overlays", "watermarks", "signatures"
        ]
        
        switch spec.format {
        case "watch_face":
            negativePrompts.append(contentsOf: [
                "too busy", "cluttered", "hard to read", "low contrast",
                "inappropriate for wrist", "unprofessional"
            ])
        case "phone_wallpaper", "phone_lockscreen":
            negativePrompts.append(contentsOf: [
                "horizontal orientation", "landscape", "inappropriate for mobile",
                "low resolution", "pixelated"
            ])
        default:
            break
        }
        
        return negativePrompts.joined(separator: ", ")
    }
    
    private func generateMockDeviceImage(spec: DeviceImageSpec, culturalContext: String) async throws -> UIImage {
        // Create a mock image with appropriate dimensions and cultural styling
        let size = CGSize(width: spec.width, height: spec.height)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let image = renderer.image { context in
            // Create gradient background based on cultural context
            let colors = getCulturalColors(for: culturalContext)
            let locations: [CGFloat] = [0.0, 1.0]
            
            if let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: colors as CFArray,
                locations: locations
            ) {
                context.cgContext.drawLinearGradient(
                    gradient,
                    start: CGPoint(x: 0, y: 0),
                    end: CGPoint(x: size.width, y: size.height),
                    options: []
                )
            }
            
            // Add device-specific styling
            if spec.format == "watch_face" {
                // Add rounded corners for watch face
                let path = UIBezierPath(
                    roundedRect: CGRect(origin: .zero, size: size),
                    cornerRadius: spec.cornerRadius
                )
                path.addClip()
                
                // Add centered cultural symbol
                addCulturalSymbol(to: context.cgContext, size: size, context: culturalContext)
            }
        }
        
        return image
    }
    
    private func getCulturalColors(for contextId: String) -> [CGColor] {
        switch contextId {
        case "hindu_festivals":
            return [UIColor.orange.cgColor, UIColor.purple.cgColor]
        case "chinese_traditional":
            return [UIColor.red.cgColor, UIColor.yellow.cgColor]
        case "christian_traditional":
            return [UIColor.red.cgColor, UIColor.green.cgColor]
        case "jewish_traditional":
            return [UIColor.blue.cgColor, UIColor.white.cgColor]
        case "buddhist_traditional":
            return [UIColor.orange.cgColor, UIColor.blue.cgColor]
        default:
            return [UIColor.blue.cgColor, UIColor.purple.cgColor]
        }
    }
    
    private func addCulturalSymbol(to context: CGContext, size: CGSize, context culturalContext: String) {
        let centerX = size.width / 2
        let centerY = size.height / 2
        let radius = min(size.width, size.height) * 0.15
        
        context.setFillColor(UIColor.white.withAlphaComponent(0.3).cgColor)
        context.fillEllipse(in: CGRect(
            x: centerX - radius,
            y: centerY - radius,
            width: radius * 2,
            height: radius * 2
        ))
    }
}

// MARK: - Supporting Types

struct DeviceOptimizedImageSet {
    let baseArtwork: CulturalGeneratedArtwork
    let watchFace: DeviceSpecificImage
    let phoneWallpaper: DeviceSpecificImage
    let phoneLockscreen: DeviceSpecificImage
    let generatedAt: Date
}

struct DeviceSpecificImage {
    let image: UIImage
    let deviceType: DeviceType
    let spec: DeviceOptimizedImageService.DeviceImageSpec
    let culturalContext: String
    let optimizations: [String]
}

enum DeviceType: String, CaseIterable {
    case watchFace = "watch_face"
    case phoneWallpaper = "phone_wallpaper"
    case phoneLockscreen = "phone_lockscreen"
    
    var displayName: String {
        switch self {
        case .watchFace: return "Apple Watch Face"
        case .phoneWallpaper: return "Phone Wallpaper"
        case .phoneLockscreen: return "Phone Lock Screen"
        }
    }
    
    var icon: String {
        switch self {
        case .watchFace: return "applewatch"
        case .phoneWallpaper: return "iphone"
        case .phoneLockscreen: return "lock.iphone"
        }
    }
}

// MARK: - Device Format Validation

extension DeviceOptimizedImageService {
    
    func validateImageForDevice(_ image: UIImage, deviceType: DeviceType) -> DeviceValidationResult {
        let spec = getSpecForDevice(deviceType)
        var issues: [String] = []
        var recommendations: [String] = []
        
        // Check dimensions
        if image.size.width != CGFloat(spec.width) || image.size.height != CGFloat(spec.height) {
            issues.append("Image dimensions don't match device requirements")
            recommendations.append("Resize to \(spec.width)×\(spec.height) pixels")
        }
        
        // Check aspect ratio
        let imageRatio = image.size.width / image.size.height
        let expectedRatio = CGFloat(spec.aspectRatio)
        if abs(imageRatio - expectedRatio) > 0.01 {
            issues.append("Aspect ratio doesn't match device requirements")
            recommendations.append("Adjust aspect ratio to \(String(format: "%.3f", spec.aspectRatio))")
        }
        
        // Device-specific checks
        switch deviceType {
        case .watchFace:
            if !isWatchFaceSuitable(image) {
                issues.append("Image may not be suitable for watch face display")
                recommendations.append("Ensure high contrast and centered design")
            }
        case .phoneWallpaper, .phoneLockscreen:
            if !isPhoneWallpaperSuitable(image) {
                issues.append("Image may not be suitable for phone display")
                recommendations.append("Ensure vertical orientation and appropriate content")
            }
        }
        
        return DeviceValidationResult(
            isValid: issues.isEmpty,
            deviceType: deviceType,
            issues: issues,
            recommendations: recommendations
        )
    }
    
    private func getSpecForDevice(_ deviceType: DeviceType) -> DeviceImageSpec {
        switch deviceType {
        case .watchFace: return .watchFace
        case .phoneWallpaper: return .phoneWallpaper
        case .phoneLockscreen: return .phoneLockscreen
        }
    }
    
    private func isWatchFaceSuitable(_ image: UIImage) -> Bool {
        // Basic suitability checks for watch faces
        let size = image.size
        return size.width > 300 && size.height > 300 && size.width < size.height
    }
    
    private func isPhoneWallpaperSuitable(_ image: UIImage) -> Bool {
        // Basic suitability checks for phone wallpapers
        let size = image.size
        return size.width < size.height // Portrait orientation
    }
}

struct DeviceValidationResult {
    let isValid: Bool
    let deviceType: DeviceType
    let issues: [String]
    let recommendations: [String]
}