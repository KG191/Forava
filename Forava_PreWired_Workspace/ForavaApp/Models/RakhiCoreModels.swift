import Foundation
import SwiftUI

// MARK: - Rakhi Design Specification
struct RakhiDesignSpec: Identifiable, Codable {
    let id: UUID
    var genre: RakhiGenre
    var elements: [DesignElement]
    var colorPalette: ColorPalette
    var personalMessage: String?
    var targetAgeGroup: AgeGroup
    var createdAt: Date
    var culturallyEnhancedPrompt: String?

    init(
        genre: RakhiGenre = .traditional,
        elements: [DesignElement] = [],
        colorPalette: ColorPalette = .traditional,
        personalMessage: String? = nil,
        targetAgeGroup: AgeGroup = .any
    ) {
        self.id = UUID()
        self.createdAt = Date()
        self.genre = genre
        self.elements = elements
        self.colorPalette = colorPalette
        self.personalMessage = personalMessage
        self.targetAgeGroup = targetAgeGroup
    }
}

// MARK: - Rakhi Genre
enum RakhiGenre: String, CaseIterable, Codable {
    case traditional = "Traditional"
    case modern = "Modern"
    case elegant = "Elegant"
    case spiritual = "Spiritual"
    case unknown = "Unknown"

    var displayName: String {
        return rawValue
    }

    var icon: String {
        switch self {
        case .traditional: return "star.circle.fill"
        case .modern: return "sparkles"
        case .elegant: return "crown.fill"
        case .spiritual: return "leaf.fill"
        case .unknown: return "questionmark.circle"
        }
    }

    var basePrompt: String {
        switch self {
        case .traditional:
            return "traditional Indian rakhi, red thread, gold elements, classic design"
        case .modern:
            return "modern contemporary rakhi, sleek design, innovative materials"
        case .elegant:
            return "elegant sophisticated rakhi, refined details, premium materials"
        case .spiritual:
            return "spiritual sacred rakhi, religious symbols, divine essence"
        case .unknown:
            return "beautiful rakhi"
        }
    }

    var culturalWeight: Double {
        switch self {
        case .traditional: return 1.0
        case .spiritual: return 0.95
        case .elegant: return 0.8
        case .modern: return 0.7
        case .unknown: return 0.5
        }
    }

    var suggestedElements: [String] {
        switch self {
        case .traditional:
            return ["red_thread", "gold_beads", "mauli", "traditional_motifs"]
        case .modern:
            return ["silk_thread", "contemporary_beads", "geometric_patterns", "metallic_accents"]
        case .elegant:
            return ["pearl_beads", "crystal_elements", "refined_patterns", "luxury_thread"]
        case .spiritual:
            return ["sacred_symbols", "rudraksha_beads", "om_symbol", "lotus_motif"]
        case .unknown:
            return []
        }
    }
}

// MARK: - Design Element
struct DesignElement: Identifiable, Codable {
    let id: String
    let displayName: String
    let category: ElementCategory
    let weight: Double
    let culturalSignificance: Double
    let ageAppropriate: [AgeGroup]
    let compatibleGenres: [RakhiGenre]
    let promptTokens: [String]

    init(
        id: String,
        displayName: String,
        category: ElementCategory,
        weight: Double = 1.0,
        culturalSignificance: Double = 0.8,
        ageAppropriate: [AgeGroup] = [.any],
        compatibleGenres: [RakhiGenre] = RakhiGenre.allCases,
        promptTokens: [String] = []
    ) {
        self.id = id
        self.displayName = displayName
        self.category = category
        self.weight = weight
        self.culturalSignificance = culturalSignificance
        self.ageAppropriate = ageAppropriate
        self.compatibleGenres = compatibleGenres
        self.promptTokens = promptTokens
    }
}

// MARK: - Element Category
enum ElementCategory: String, CaseIterable, Codable {
    case thread = "Thread"
    case beads = "Beads"
    case centerPiece = "Center Piece"
    case decorativeElements = "Decorative Elements"
    case symbols = "Symbols"
    case colors = "Colors"
    case patterns = "Patterns"
    case materials = "Materials"

    var icon: String {
        switch self {
        case .thread: return "line.3.horizontal"
        case .beads: return "circle.grid.2x2.fill"
        case .centerPiece: return "star.fill"
        case .decorativeElements: return "sparkles"
        case .symbols: return "character.magnify"
        case .colors: return "paintpalette.fill"
        case .patterns: return "grid"
        case .materials: return "cube.fill"
        }
    }
}

// MARK: - Color Palette
enum ColorPalette: String, CaseIterable, Codable {
    case traditional = "Traditional"
    case modern = "Modern"
    case vibrant = "Vibrant"
    case pastel = "Pastel"
    case earthy = "Earthy"
    case metallic = "Metallic"
    case monochrome = "Monochrome"

    var colors: [Color] {
        switch self {
        case .traditional:
            return [.red, .orange, .yellow, Color(red: 0.8, green: 0.4, blue: 0.0)]
        case .modern:
            return [.blue, .indigo, .cyan, Color(red: 0.5, green: 0.5, blue: 0.5)]
        case .vibrant:
            return [.pink, .purple, .blue, .green]
        case .pastel:
            return [Color(red: 1.0, green: 0.8, blue: 0.8), Color(red: 0.8, green: 1.0, blue: 0.8),
                   Color(red: 0.8, green: 0.8, blue: 1.0), Color(red: 1.0, green: 1.0, blue: 0.8)]
        case .earthy:
            return [Color(red: 0.6, green: 0.4, blue: 0.2), Color(red: 0.4, green: 0.6, blue: 0.2),
                   Color(red: 0.8, green: 0.7, blue: 0.5), Color(red: 0.5, green: 0.3, blue: 0.1)]
        case .metallic:
            return [Color(red: 0.8, green: 0.8, blue: 0.0), Color(red: 0.7, green: 0.7, blue: 0.7),
                   Color(red: 0.6, green: 0.4, blue: 0.2), Color(red: 0.4, green: 0.4, blue: 0.4)]
        case .monochrome:
            return [.black, .white, .gray, Color(red: 0.3, green: 0.3, blue: 0.3)]
        }
    }

    var promptTokens: [String] {
        switch self {
        case .traditional:
            return ["red", "orange", "gold", "traditional colors"]
        case .modern:
            return ["blue", "contemporary colors", "sleek", "modern palette"]
        case .vibrant:
            return ["bright colors", "vivid", "colorful", "rainbow"]
        case .pastel:
            return ["soft colors", "pastel tones", "gentle", "light colors"]
        case .earthy:
            return ["brown", "earth tones", "natural colors", "organic palette"]
        case .metallic:
            return ["gold", "silver", "metallic", "shimmering"]
        case .monochrome:
            return ["black and white", "monochrome", "grayscale", "minimal colors"]
        }
    }
}

// MARK: - Age Group
enum AgeGroup: String, CaseIterable, Codable {
    case young = "Young" // 5-18
    case adult = "Adult" // 18-50
    case elder = "Elder" // 50+
    case any = "Any"

    var ageRange: String {
        switch self {
        case .young: return "5-18 years"
        case .adult: return "18-50 years"
        case .elder: return "50+ years"
        case .any: return "All ages"
        }
    }

    var preferences: [String] {
        switch self {
        case .young:
            return ["colorful", "playful", "modern", "fun"]
        case .adult:
            return ["elegant", "sophisticated", "meaningful", "quality"]
        case .elder:
            return ["traditional", "spiritual", "classic", "respectful"]
        case .any:
            return ["universal", "timeless", "beautiful", "appropriate"]
        }
    }
}

// MARK: - Generated Rakhi Models
struct GeneratedRakhi: Identifiable, Codable {
    let id: UUID
    let designSpec: RakhiDesignSpec
    let mainImage: AIImageResult
    let animationFrames: [AIImageResult]
    let prompt: AIPrompt
    let createdAt: Date
    let culturalScore: Double
    let qualityScore: Double

    init(
        id: UUID = UUID(),
        designSpec: RakhiDesignSpec,
        mainImage: AIImageResult,
        animationFrames: [AIImageResult] = [],
        prompt: AIPrompt,
        createdAt: Date = Date(),
        culturalScore: Double = 0.8,
        qualityScore: Double = 0.9
    ) {
        self.id = id
        self.designSpec = designSpec
        self.mainImage = mainImage
        self.animationFrames = animationFrames
        self.prompt = prompt
        self.createdAt = createdAt
        self.culturalScore = culturalScore
        self.qualityScore = qualityScore
    }
}

struct AIImageResult: Identifiable, Codable {
    let id: UUID
    let imageData: Data
    let timestamp: Date

    init(imageData: Data, timestamp: Date = Date()) {
        self.id = UUID()
        self.imageData = imageData
        self.timestamp = timestamp
    }
}

struct AIPrompt: Codable {
    let positive: String
    let negative: String
    let cfgScale: Float
    let steps: Int
    let seed: Int64
    let width: Int
    let height: Int

    init(
        positive: String,
        negative: String = "",
        cfgScale: Float = 7.5,
        steps: Int = 20,
        seed: Int64 = 12345,
        width: Int = 512,
        height: Int = 512
    ) {
        self.positive = positive
        self.negative = negative
        self.cfgScale = cfgScale
        self.steps = steps
        self.seed = seed
        self.width = width
        self.height = height
    }
}
