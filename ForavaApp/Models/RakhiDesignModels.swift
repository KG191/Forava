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

// MARK: - Design Elements Database
class DesignElementsDatabase {
    static let shared = DesignElementsDatabase()
    
    private let elements: [DesignElement] = [
        // Thread Elements
        DesignElement(
            id: "red_thread",
            displayName: "Red Thread (Mauli)",
            category: .thread,
            weight: 1.0,
            culturalSignificance: 1.0,
            ageAppropriate: [.any],
            compatibleGenres: [.traditional, .spiritual],
            promptTokens: ["red thread", "mauli", "sacred thread", "traditional thread"]
        ),
        DesignElement(
            id: "silk_thread",
            displayName: "Silk Thread",
            category: .thread,
            weight: 0.9,
            culturalSignificance: 0.8,
            ageAppropriate: [.adult, .elder],
            compatibleGenres: [.elegant, .modern],
            promptTokens: ["silk thread", "smooth thread", "premium thread", "lustrous thread"]
        ),
        
        // Bead Elements
        DesignElement(
            id: "gold_beads",
            displayName: "Gold Beads",
            category: .beads,
            weight: 0.8,
            culturalSignificance: 0.9,
            ageAppropriate: [.any],
            compatibleGenres: [.traditional, .elegant],
            promptTokens: ["gold beads", "golden spheres", "metallic beads"]
        ),
        DesignElement(
            id: "pearl_beads",
            displayName: "Pearl Beads",
            category: .beads,
            weight: 0.7,
            culturalSignificance: 0.7,
            ageAppropriate: [.adult, .elder],
            compatibleGenres: [.elegant, .modern],
            promptTokens: ["pearl beads", "white pearls", "lustrous beads"]
        ),
        DesignElement(
            id: "rudraksha_beads",
            displayName: "Rudraksha Beads",
            category: .beads,
            weight: 0.9,
            culturalSignificance: 1.0,
            ageAppropriate: [.adult, .elder],
            compatibleGenres: [.spiritual, .traditional],
            promptTokens: ["rudraksha beads", "sacred beads", "spiritual beads", "brown beads"]
        ),
        
        // Center Piece Elements
        DesignElement(
            id: "om_symbol",
            displayName: "Om Symbol",
            category: .centerPiece,
            weight: 0.9,
            culturalSignificance: 1.0,
            ageAppropriate: [.adult, .elder],
            compatibleGenres: [.spiritual, .traditional],
            promptTokens: ["om symbol", "sacred om", "hindu om", "spiritual symbol"]
        ),
        DesignElement(
            id: "lotus_motif",
            displayName: "Lotus Motif",
            category: .centerPiece,
            weight: 0.8,
            culturalSignificance: 0.9,
            ageAppropriate: [.any],
            compatibleGenres: [.traditional, .spiritual, .elegant],
            promptTokens: ["lotus flower", "lotus petals", "sacred lotus", "pink lotus"]
        ),
        DesignElement(
            id: "geometric_center",
            displayName: "Geometric Design",
            category: .centerPiece,
            weight: 0.7,
            culturalSignificance: 0.6,
            ageAppropriate: [.young, .adult],
            compatibleGenres: [.modern, .elegant],
            promptTokens: ["geometric pattern", "modern design", "abstract shape", "symmetrical"]
        ),
        
        // Decorative Elements
        DesignElement(
            id: "tassels",
            displayName: "Tassels",
            category: .decorativeElements,
            weight: 0.6,
            culturalSignificance: 0.7,
            ageAppropriate: [.any],
            compatibleGenres: [.traditional, .elegant],
            promptTokens: ["tassels", "hanging threads", "decorative tassels", "flowing threads"]
        ),
        DesignElement(
            id: "mirrors",
            displayName: "Mirror Work",
            category: .decorativeElements,
            weight: 0.5,
            culturalSignificance: 0.8,
            ageAppropriate: [.young, .adult],
            compatibleGenres: [.traditional, .elegant],
            promptTokens: ["mirror work", "reflective elements", "shiny mirrors", "embedded mirrors"]
        ),
        
        // Symbols
        DesignElement(
            id: "swastika",
            displayName: "Swastika (Auspicious Symbol)",
            category: .symbols,
            weight: 0.8,
            culturalSignificance: 1.0,
            ageAppropriate: [.adult, .elder],
            compatibleGenres: [.traditional, .spiritual],
            promptTokens: ["swastika symbol", "auspicious swastika", "hindu swastika", "traditional symbol"]
        ),
        DesignElement(
            id: "peacock_motif",
            displayName: "Peacock Motif",
            category: .symbols,
            weight: 0.7,
            culturalSignificance: 0.8,
            ageAppropriate: [.any],
            compatibleGenres: [.traditional, .elegant],
            promptTokens: ["peacock design", "peacock feathers", "colorful peacock", "bird motif"]
        ),
        
        // EXPANDED DECORATIVE ELEMENTS (10x more options)
        DesignElement(
            id: "silk_ribbons",
            displayName: "Silk Ribbons",
            category: .decorativeElements,
            weight: 0.6,
            culturalSignificance: 0.7,
            ageAppropriate: [.any],
            compatibleGenres: [.elegant, .modern],
            promptTokens: ["silk ribbons", "flowing ribbons", "satin ribbons", "decorative ribbons"]
        ),
        DesignElement(
            id: "zardozi_work",
            displayName: "Zardozi Embroidery",
            category: .decorativeElements,
            weight: 0.8,
            culturalSignificance: 0.9,
            ageAppropriate: [.adult, .elder],
            compatibleGenres: [.traditional, .elegant],
            promptTokens: ["zardozi embroidery", "gold thread work", "metallic embroidery", "royal embroidery"]
        ),
        DesignElement(
            id: "sequins",
            displayName: "Sequins",
            category: .decorativeElements,
            weight: 0.5,
            culturalSignificance: 0.6,
            ageAppropriate: [.young, .adult],
            compatibleGenres: [.modern, .elegant],
            promptTokens: ["sequins", "sparkly discs", "shimmering sequins", "decorative discs"]
        ),
        DesignElement(
            id: "bells",
            displayName: "Small Bells",
            category: .decorativeElements,
            weight: 0.6,
            culturalSignificance: 0.8,
            ageAppropriate: [.any],
            compatibleGenres: [.traditional, .spiritual],
            promptTokens: ["small bells", "tiny bells", "jingling bells", "decorative bells"]
        ),
        DesignElement(
            id: "crystal_beads",
            displayName: "Crystal Beads",
            category: .decorativeElements,
            weight: 0.5,
            culturalSignificance: 0.5,
            ageAppropriate: [.young, .adult],
            compatibleGenres: [.modern, .elegant],
            promptTokens: ["crystal beads", "transparent beads", "sparkling crystals", "glass beads"]
        ),
        DesignElement(
            id: "feathers",
            displayName: "Decorative Feathers",
            category: .decorativeElements,
            weight: 0.4,
            culturalSignificance: 0.6,
            ageAppropriate: [.young, .adult],
            compatibleGenres: [.modern, .elegant],
            promptTokens: ["decorative feathers", "colorful feathers", "soft feathers", "ornamental feathers"]
        ),
        DesignElement(
            id: "lace_trim",
            displayName: "Lace Trim",
            category: .decorativeElements,
            weight: 0.5,
            culturalSignificance: 0.5,
            ageAppropriate: [.young, .adult],
            compatibleGenres: [.elegant, .modern],
            promptTokens: ["lace trim", "delicate lace", "decorative lace", "fabric lace"]
        ),
        DesignElement(
            id: "brocade_patches",
            displayName: "Brocade Patches",
            category: .decorativeElements,
            weight: 0.7,
            culturalSignificance: 0.8,
            ageAppropriate: [.adult, .elder],
            compatibleGenres: [.traditional, .elegant],
            promptTokens: ["brocade fabric", "decorative patches", "rich fabric", "ornate brocade"]
        ),
        DesignElement(
            id: "kundan_work",
            displayName: "Kundan Work",
            category: .decorativeElements,
            weight: 0.8,
            culturalSignificance: 0.9,
            ageAppropriate: [.adult, .elder],
            compatibleGenres: [.traditional, .elegant],
            promptTokens: ["kundan work", "precious stones", "royal kundan", "traditional stones"]
        ),
        DesignElement(
            id: "gota_work",
            displayName: "Gota Work",
            category: .decorativeElements,
            weight: 0.7,
            culturalSignificance: 0.8,
            ageAppropriate: [.any],
            compatibleGenres: [.traditional, .elegant],
            promptTokens: ["gota work", "gold lace", "metallic trim", "decorative gota"]
        ),
        
        // COLORS CATEGORY (Brand new)
        DesignElement(
            id: "saffron_orange",
            displayName: "Saffron Orange",
            category: .colors,
            weight: 0.9,
            culturalSignificance: 1.0,
            ageAppropriate: [.any],
            compatibleGenres: [.traditional, .spiritual],
            promptTokens: ["saffron color", "sacred orange", "hindu orange", "traditional saffron"]
        ),
        DesignElement(
            id: "deep_red",
            displayName: "Deep Red",
            category: .colors,
            weight: 0.9,
            culturalSignificance: 0.9,
            ageAppropriate: [.any],
            compatibleGenres: [.traditional, .spiritual],
            promptTokens: ["deep red", "crimson red", "traditional red", "rich red"]
        ),
        DesignElement(
            id: "royal_gold",
            displayName: "Royal Gold",
            category: .colors,
            weight: 0.8,
            culturalSignificance: 0.9,
            ageAppropriate: [.any],
            compatibleGenres: [.traditional, .elegant],
            promptTokens: ["royal gold", "bright gold", "metallic gold", "lustrous gold"]
        ),
        DesignElement(
            id: "emerald_green",
            displayName: "Emerald Green",
            category: .colors,
            weight: 0.7,
            culturalSignificance: 0.7,
            ageAppropriate: [.any],
            compatibleGenres: [.traditional, .elegant],
            promptTokens: ["emerald green", "rich green", "jewel green", "deep green"]
        ),
        DesignElement(
            id: "peacock_blue",
            displayName: "Peacock Blue",
            category: .colors,
            weight: 0.7,
            culturalSignificance: 0.8,
            ageAppropriate: [.any],
            compatibleGenres: [.traditional, .elegant],
            promptTokens: ["peacock blue", "vibrant blue", "rich blue", "royal blue"]
        ),
        DesignElement(
            id: "sunset_pink",
            displayName: "Sunset Pink",
            category: .colors,
            weight: 0.6,
            culturalSignificance: 0.6,
            ageAppropriate: [.young, .adult],
            compatibleGenres: [.modern, .elegant],
            promptTokens: ["sunset pink", "warm pink", "coral pink", "soft pink"]
        ),
        DesignElement(
            id: "ivory_white",
            displayName: "Ivory White",
            category: .colors,
            weight: 0.7,
            culturalSignificance: 0.8,
            ageAppropriate: [.any],
            compatibleGenres: [.elegant, .spiritual],
            promptTokens: ["ivory white", "cream white", "pure white", "elegant white"]
        ),
        DesignElement(
            id: "maroon_burgundy",
            displayName: "Maroon Burgundy",
            category: .colors,
            weight: 0.8,
            culturalSignificance: 0.8,
            ageAppropriate: [.adult, .elder],
            compatibleGenres: [.traditional, .elegant],
            promptTokens: ["maroon color", "burgundy red", "deep maroon", "wine color"]
        ),
        DesignElement(
            id: "mustard_yellow",
            displayName: "Mustard Yellow",
            category: .colors,
            weight: 0.7,
            culturalSignificance: 0.8,
            ageAppropriate: [.any],
            compatibleGenres: [.traditional, .elegant],
            promptTokens: ["mustard yellow", "turmeric yellow", "golden yellow", "warm yellow"]
        ),
        DesignElement(
            id: "silver_metallic",
            displayName: "Silver Metallic",
            category: .colors,
            weight: 0.6,
            culturalSignificance: 0.6,
            ageAppropriate: [.any],
            compatibleGenres: [.modern, .elegant],
            promptTokens: ["silver color", "metallic silver", "shiny silver", "lustrous silver"]
        ),
        
        // PATTERNS CATEGORY (Brand new)
        DesignElement(
            id: "paisley_pattern",
            displayName: "Paisley Pattern",
            category: .patterns,
            weight: 0.8,
            culturalSignificance: 0.9,
            ageAppropriate: [.any],
            compatibleGenres: [.traditional, .elegant],
            promptTokens: ["paisley pattern", "traditional paisley", "curved paisley", "decorative paisley"]
        ),
        DesignElement(
            id: "mandala_pattern",
            displayName: "Mandala Pattern",
            category: .patterns,
            weight: 0.9,
            culturalSignificance: 1.0,
            ageAppropriate: [.adult, .elder],
            compatibleGenres: [.spiritual, .traditional],
            promptTokens: ["mandala pattern", "circular mandala", "spiritual mandala", "sacred geometry"]
        ),
        DesignElement(
            id: "geometric_diamond",
            displayName: "Diamond Geometric",
            category: .patterns,
            weight: 0.6,
            culturalSignificance: 0.5,
            ageAppropriate: [.young, .adult],
            compatibleGenres: [.modern, .elegant],
            promptTokens: ["diamond pattern", "geometric diamonds", "angular pattern", "modern geometry"]
        ),
        DesignElement(
            id: "floral_vine",
            displayName: "Floral Vine",
            category: .patterns,
            weight: 0.7,
            culturalSignificance: 0.7,
            ageAppropriate: [.any],
            compatibleGenres: [.traditional, .elegant],
            promptTokens: ["floral vine", "flower pattern", "botanical design", "decorative flowers"]
        ),
        DesignElement(
            id: "wave_pattern",
            displayName: "Wave Pattern",
            category: .patterns,
            weight: 0.5,
            culturalSignificance: 0.5,
            ageAppropriate: [.any],
            compatibleGenres: [.modern, .elegant],
            promptTokens: ["wave pattern", "flowing waves", "curved lines", "rhythmic pattern"]
        ),
        DesignElement(
            id: "checker_board",
            displayName: "Checker Pattern",
            category: .patterns,
            weight: 0.4,
            culturalSignificance: 0.3,
            ageAppropriate: [.young, .adult],
            compatibleGenres: [.modern],
            promptTokens: ["checker pattern", "checkered design", "square pattern", "alternating squares"]
        ),
        DesignElement(
            id: "spiral_pattern",
            displayName: "Spiral Pattern",
            category: .patterns,
            weight: 0.6,
            culturalSignificance: 0.6,
            ageAppropriate: [.any],
            compatibleGenres: [.spiritual, .modern],
            promptTokens: ["spiral pattern", "swirling design", "curved spiral", "flowing spiral"]
        ),
        DesignElement(
            id: "hexagonal_honeycomb",
            displayName: "Honeycomb Pattern",
            category: .patterns,
            weight: 0.5,
            culturalSignificance: 0.4,
            ageAppropriate: [.young, .adult],
            compatibleGenres: [.modern],
            promptTokens: ["hexagonal pattern", "honeycomb design", "geometric hexagons", "nature pattern"]
        ),
        DesignElement(
            id: "border_pattern",
            displayName: "Traditional Border",
            category: .patterns,
            weight: 0.7,
            culturalSignificance: 0.8,
            ageAppropriate: [.any],
            compatibleGenres: [.traditional, .elegant],
            promptTokens: ["border pattern", "decorative border", "traditional edging", "ornamental border"]
        ),
        DesignElement(
            id: "star_burst",
            displayName: "Star Burst",
            category: .patterns,
            weight: 0.6,
            culturalSignificance: 0.6,
            ageAppropriate: [.any],
            compatibleGenres: [.modern, .spiritual],
            promptTokens: ["star burst", "radiating pattern", "stellar design", "burst pattern"]
        ),
        
        // MATERIALS CATEGORY (Brand new)
        DesignElement(
            id: "pure_silk",
            displayName: "Pure Silk",
            category: .materials,
            weight: 0.9,
            culturalSignificance: 0.8,
            ageAppropriate: [.adult, .elder],
            compatibleGenres: [.elegant, .traditional],
            promptTokens: ["pure silk", "silk fabric", "lustrous silk", "premium silk"]
        ),
        DesignElement(
            id: "cotton_thread",
            displayName: "Cotton Thread",
            category: .materials,
            weight: 0.7,
            culturalSignificance: 0.7,
            ageAppropriate: [.any],
            compatibleGenres: [.traditional, .modern],
            promptTokens: ["cotton thread", "natural cotton", "soft cotton", "breathable cotton"]
        ),
        DesignElement(
            id: "velvet_fabric",
            displayName: "Velvet",
            category: .materials,
            weight: 0.8,
            culturalSignificance: 0.7,
            ageAppropriate: [.adult, .elder],
            compatibleGenres: [.elegant, .traditional],
            promptTokens: ["velvet fabric", "soft velvet", "plush velvet", "luxurious velvet"]
        ),
        DesignElement(
            id: "satin_ribbon",
            displayName: "Satin",
            category: .materials,
            weight: 0.6,
            culturalSignificance: 0.6,
            ageAppropriate: [.any],
            compatibleGenres: [.elegant, .modern],
            promptTokens: ["satin material", "smooth satin", "shiny satin", "glossy satin"]
        ),
        DesignElement(
            id: "metallic_thread",
            displayName: "Metallic Thread",
            category: .materials,
            weight: 0.7,
            culturalSignificance: 0.8,
            ageAppropriate: [.any],
            compatibleGenres: [.traditional, .elegant],
            promptTokens: ["metallic thread", "gold thread", "silver thread", "shimmery thread"]
        ),
        DesignElement(
            id: "jute_fiber",
            displayName: "Jute Fiber",
            category: .materials,
            weight: 0.5,
            culturalSignificance: 0.6,
            ageAppropriate: [.any],
            compatibleGenres: [.traditional, .modern],
            promptTokens: ["jute fiber", "natural jute", "rustic jute", "eco-friendly jute"]
        ),
        DesignElement(
            id: "bamboo_fiber",
            displayName: "Bamboo Fiber",
            category: .materials,
            weight: 0.5,
            culturalSignificance: 0.5,
            ageAppropriate: [.any],
            compatibleGenres: [.modern, .traditional],
            promptTokens: ["bamboo fiber", "natural bamboo", "sustainable bamboo", "eco bamboo"]
        ),
        DesignElement(
            id: "organza_fabric",
            displayName: "Organza",
            category: .materials,
            weight: 0.6,
            culturalSignificance: 0.6,
            ageAppropriate: [.young, .adult],
            compatibleGenres: [.elegant, .modern],
            promptTokens: ["organza fabric", "transparent organza", "delicate organza", "flowing organza"]
        ),
        DesignElement(
            id: "leather_cord",
            displayName: "Leather Cord",
            category: .materials,
            weight: 0.4,
            culturalSignificance: 0.4,
            ageAppropriate: [.young, .adult],
            compatibleGenres: [.modern],
            promptTokens: ["leather cord", "natural leather", "brown leather", "rustic leather"]
        ),
        DesignElement(
            id: "hemp_rope",
            displayName: "Hemp Rope",
            category: .materials,
            weight: 0.4,
            culturalSignificance: 0.5,
            ageAppropriate: [.any],
            compatibleGenres: [.modern, .traditional],
            promptTokens: ["hemp rope", "natural hemp", "eco-friendly hemp", "rustic hemp"]
        ),
        
        // EXPANDED SYMBOLS CATEGORY
        DesignElement(
            id: "ganesha_symbol",
            displayName: "Ganesha Symbol",
            category: .symbols,
            weight: 0.9,
            culturalSignificance: 1.0,
            ageAppropriate: [.any],
            compatibleGenres: [.spiritual, .traditional],
            promptTokens: ["ganesha symbol", "elephant god", "hindu ganesha", "remover obstacles"]
        ),
        DesignElement(
            id: "trishul_symbol",
            displayName: "Trishul Symbol",
            category: .symbols,
            weight: 0.8,
            culturalSignificance: 0.9,
            ageAppropriate: [.adult, .elder],
            compatibleGenres: [.spiritual, .traditional],
            promptTokens: ["trishul symbol", "trident symbol", "shiva trishul", "spiritual weapon"]
        ),
        DesignElement(
            id: "kalash_symbol",
            displayName: "Kalash Symbol",
            category: .symbols,
            weight: 0.8,
            culturalSignificance: 0.9,
            ageAppropriate: [.any],
            compatibleGenres: [.spiritual, .traditional],
            promptTokens: ["kalash symbol", "sacred pot", "auspicious pot", "holy vessel"]
        ),
        DesignElement(
            id: "sun_symbol",
            displayName: "Sun Symbol",
            category: .symbols,
            weight: 0.7,
            culturalSignificance: 0.8,
            ageAppropriate: [.any],
            compatibleGenres: [.spiritual, .traditional],
            promptTokens: ["sun symbol", "solar design", "bright sun", "radiant sun"]
        ),
        DesignElement(
            id: "moon_symbol",
            displayName: "Moon Symbol",
            category: .symbols,
            weight: 0.7,
            culturalSignificance: 0.8,
            ageAppropriate: [.any],
            compatibleGenres: [.spiritual, .traditional],
            promptTokens: ["moon symbol", "crescent moon", "lunar design", "night symbol"]
        ),
        DesignElement(
            id: "heart_symbol",
            displayName: "Heart Symbol",
            category: .symbols,
            weight: 0.6,
            culturalSignificance: 0.6,
            ageAppropriate: [.any],
            compatibleGenres: [.modern, .elegant],
            promptTokens: ["heart symbol", "love heart", "romantic heart", "caring heart"]
        ),
        DesignElement(
            id: "infinity_symbol",
            displayName: "Infinity Symbol",
            category: .symbols,
            weight: 0.5,
            culturalSignificance: 0.5,
            ageAppropriate: [.young, .adult],
            compatibleGenres: [.modern, .spiritual],
            promptTokens: ["infinity symbol", "eternal symbol", "endless loop", "infinite bond"]
        ),
        DesignElement(
            id: "tree_of_life",
            displayName: "Tree of Life",
            category: .symbols,
            weight: 0.7,
            culturalSignificance: 0.7,
            ageAppropriate: [.any],
            compatibleGenres: [.spiritual, .modern],
            promptTokens: ["tree of life", "sacred tree", "life tree", "family tree"]
        ),
        DesignElement(
            id: "hamsa_hand",
            displayName: "Hamsa Hand",
            category: .symbols,
            weight: 0.7,
            culturalSignificance: 0.8,
            ageAppropriate: [.any],
            compatibleGenres: [.spiritual, .traditional],
            promptTokens: ["hamsa hand", "protective hand", "blessing hand", "spiritual hand"]
        ),
        DesignElement(
            id: "ankh_symbol",
            displayName: "Ankh Symbol",
            category: .symbols,
            weight: 0.6,
            culturalSignificance: 0.6,
            ageAppropriate: [.adult, .elder],
            compatibleGenres: [.spiritual, .modern],
            promptTokens: ["ankh symbol", "life symbol", "eternal life", "ancient symbol"]
        )
    ]
    
    private init() {}
    
    func getAllElements() -> [DesignElement] {
        return elements
    }
    
    func getElements(for category: ElementCategory) -> [DesignElement] {
        return elements.filter { $0.category == category }
    }
    
    func getElements(for genre: RakhiGenre) -> [DesignElement] {
        return elements.filter { $0.compatibleGenres.contains(genre) }
    }
    
    func getElements(for ageGroup: AgeGroup) -> [DesignElement] {
        if ageGroup == .any {
            return elements
        }
        return elements.filter { $0.ageAppropriate.contains(ageGroup) || $0.ageAppropriate.contains(.any) }
    }
    
    func getElement(by id: String) -> DesignElement? {
        return elements.first { $0.id == id }
    }
    
    func searchElements(query: String) -> [DesignElement] {
        let lowercaseQuery = query.lowercased()
        return elements.filter {
            $0.displayName.lowercased().contains(lowercaseQuery) ||
            $0.promptTokens.contains { $0.lowercased().contains(lowercaseQuery) }
        }
    }
}

// MARK: - Cultural Validator
class CulturalValidator {
    static let shared = CulturalValidator()
    
    private let inappropriateElements: Set<String> = [
        // Add any culturally inappropriate element IDs here
        // This would be populated based on cultural expert consultation
    ]
    
    private let sensitiveElements: Set<String> = [
        "swastika" // Requires careful context
    ]
    
    private init() {}
    
    func isInappropriate(_ element: DesignElement) -> Bool {
        return inappropriateElements.contains(element.id)
    }
    
    func isSensitive(_ element: DesignElement) -> Bool {
        return sensitiveElements.contains(element.id)
    }
    
    func validateDesignSpec(_ spec: RakhiDesignSpec) -> CulturalValidationResult {
        var warnings: [String] = []
        var errors: [String] = []
        
        for element in spec.elements {
            if isInappropriate(element) {
                errors.append("Element '\(element.displayName)' is culturally inappropriate")
            } else if isSensitive(element) {
                warnings.append("Element '\(element.displayName)' requires cultural sensitivity")
            }
        }
        
        // Check age appropriateness
        let ageInappropriate = spec.elements.filter { element in
            !element.ageAppropriate.contains(spec.targetAgeGroup) && 
            !element.ageAppropriate.contains(.any)
        }
        
        for element in ageInappropriate {
            warnings.append("Element '\(element.displayName)' may not be age-appropriate for \(spec.targetAgeGroup.rawValue)")
        }
        
        return CulturalValidationResult(
            isValid: errors.isEmpty,
            warnings: warnings,
            errors: errors,
            culturalScore: calculateCulturalScore(spec)
        )
    }
    
    private func calculateCulturalScore(_ spec: RakhiDesignSpec) -> Double {
        let genreScore = spec.genre.culturalWeight
        let elementScores = spec.elements.map { $0.culturalSignificance }
        let avgElementScore = elementScores.isEmpty ? 0.5 : elementScores.reduce(0, +) / Double(elementScores.count)
        
        return (genreScore * 0.3) + (avgElementScore * 0.7)
    }
}

struct CulturalValidationResult {
    let isValid: Bool
    let warnings: [String]
    let errors: [String]
    let culturalScore: Double
}