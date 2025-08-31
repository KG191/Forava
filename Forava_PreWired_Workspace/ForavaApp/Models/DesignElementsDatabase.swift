import Foundation

// MARK: - Design Elements Database
class DesignElementsDatabase {
    static let shared = DesignElementsDatabase()

    private let elements: [DesignElement] = [
        // 🧵 THREAD ELEMENTS (15+ options)
        DesignElement(
            id: "red_thread_mauli",
            displayName: "Red Thread (Mauli)",
            category: .thread,
            weight: 1.0,
            culturalSignificance: 1.0,
            ageAppropriate: [.any],
            compatibleGenres: [.traditional, .spiritual],
            promptTokens: ["red thread", "mauli", "sacred thread", "traditional red thread", "holy thread"]
        ),
        DesignElement(
            id: "saffron_thread",
            displayName: "Saffron Thread",
            category: .thread,
            weight: 0.95,
            culturalSignificance: 0.95,
            ageAppropriate: [.any],
            compatibleGenres: [.traditional, .spiritual],
            promptTokens: ["saffron thread", "orange thread", "hindu thread", "sacred saffron"]
        ),
        DesignElement(
            id: "silk_thread_premium",
            displayName: "Premium Silk Thread",
            category: .thread,
            weight: 0.9,
            culturalSignificance: 0.8,
            ageAppropriate: [.adult, .elder],
            compatibleGenres: [.elegant, .modern],
            promptTokens: ["silk thread", "premium thread", "lustrous silk", "smooth thread"]
        ),
        DesignElement(
            id: "golden_thread",
            displayName: "Golden Thread (Zari)",
            category: .thread,
            weight: 0.85,
            culturalSignificance: 0.9,
            ageAppropriate: [.any],
            compatibleGenres: [.traditional, .elegant],
            promptTokens: ["golden thread", "zari thread", "metallic thread", "gold woven thread"]
        ),
        DesignElement(
            id: "cotton_thread_white",
            displayName: "Pure White Cotton",
            category: .thread,
            weight: 0.8,
            culturalSignificance: 0.85,
            ageAppropriate: [.any],
            compatibleGenres: [.traditional, .spiritual],
            promptTokens: ["white cotton thread", "pure white thread", "cotton thread", "clean white thread"]
        ),
        DesignElement(
            id: "multi_colored_thread",
            displayName: "Multi-Colored Thread",
            category: .thread,
            weight: 0.75,
            culturalSignificance: 0.7,
            ageAppropriate: [.young, .adult],
            compatibleGenres: [.modern, .traditional],
            promptTokens: ["multi colored thread", "rainbow thread", "colorful thread", "vibrant thread"]
        ),
        DesignElement(
            id: "silver_thread",
            displayName: "Silver Thread",
            category: .thread,
            weight: 0.7,
            culturalSignificance: 0.75,
            ageAppropriate: [.any],
            compatibleGenres: [.elegant, .modern],
            promptTokens: ["silver thread", "metallic silver", "shiny thread", "silver woven"]
        ),
        DesignElement(
            id: "twisted_rope_thread",
            displayName: "Twisted Rope Thread",
            category: .thread,
            weight: 0.8,
            culturalSignificance: 0.8,
            ageAppropriate: [.any],
            compatibleGenres: [.traditional, .elegant],
            promptTokens: ["twisted thread", "rope thread", "braided thread", "thick twisted thread"]
        ),
        DesignElement(
            id: "velvet_thread",
            displayName: "Velvet Thread",
            category: .thread,
            weight: 0.65,
            culturalSignificance: 0.6,
            ageAppropriate: [.adult, .elder],
            compatibleGenres: [.elegant, .modern],
            promptTokens: ["velvet thread", "soft thread", "luxurious thread", "plush thread"]
        ),
        DesignElement(
            id: "jute_thread_natural",
            displayName: "Natural Jute Thread",
            category: .thread,
            weight: 0.7,
            culturalSignificance: 0.7,
            ageAppropriate: [.adult, .elder],
            compatibleGenres: [.traditional, .spiritual],
            promptTokens: ["jute thread", "natural thread", "rustic thread", "eco thread"]
        ),
        DesignElement(
            id: "crystal_thread",
            displayName: "Crystal Embedded Thread",
            category: .thread,
            weight: 0.6,
            culturalSignificance: 0.5,
            ageAppropriate: [.young, .adult],
            compatibleGenres: [.modern, .elegant],
            promptTokens: ["crystal thread", "sparkly thread", "gem thread", "jeweled thread"]
        ),
        DesignElement(
            id: "satin_thread",
            displayName: "Satin Thread",
            category: .thread,
            weight: 0.65,
            culturalSignificance: 0.6,
            ageAppropriate: [.adult, .elder],
            compatibleGenres: [.elegant, .modern],
            promptTokens: ["satin thread", "glossy thread", "shiny satin", "smooth satin thread"]
        ),
        DesignElement(
            id: "hemp_thread",
            displayName: "Hemp Thread",
            category: .thread,
            weight: 0.7,
            culturalSignificance: 0.75,
            ageAppropriate: [.adult, .elder],
            compatibleGenres: [.traditional, .spiritual],
            promptTokens: ["hemp thread", "natural hemp", "organic thread", "eco friendly thread"]
        ),
        DesignElement(
            id: "nylon_thread_durable",
            displayName: "Durable Nylon Thread",
            category: .thread,
            weight: 0.6,
            culturalSignificance: 0.4,
            ageAppropriate: [.young, .adult],
            compatibleGenres: [.modern],
            promptTokens: ["nylon thread", "synthetic thread", "durable thread", "modern thread"]
        ),
        DesignElement(
            id: "embroidery_thread",
            displayName: "Embroidery Thread",
            category: .thread,
            weight: 0.75,
            culturalSignificance: 0.8,
            ageAppropriate: [.any],
            compatibleGenres: [.traditional, .elegant],
            promptTokens: ["embroidery thread", "decorative thread", "artistic thread", "craft thread"]
        ),

        // 📿 BEAD ELEMENTS (8 options)
        DesignElement(
            id: "gold_beads_traditional",
            displayName: "Traditional Gold Beads",
            category: .beads,
            weight: 0.9,
            culturalSignificance: 0.95,
            ageAppropriate: [.any],
            compatibleGenres: [.traditional, .elegant],
            promptTokens: ["gold beads", "golden spheres", "metallic beads", "traditional gold beads"]
        ),
        DesignElement(
            id: "pearl_beads_white",
            displayName: "White Pearl Beads",
            category: .beads,
            weight: 0.8,
            culturalSignificance: 0.75,
            ageAppropriate: [.adult, .elder],
            compatibleGenres: [.elegant, .modern],
            promptTokens: ["pearl beads", "white pearls", "lustrous pearls", "natural pearls"]
        ),
        DesignElement(
            id: "rudraksha_beads_sacred",
            displayName: "Sacred Rudraksha Beads",
            category: .beads,
            weight: 0.95,
            culturalSignificance: 1.0,
            ageAppropriate: [.adult, .elder],
            compatibleGenres: [.spiritual, .traditional],
            promptTokens: ["rudraksha beads", "sacred beads", "spiritual beads", "holy rudraksha"]
        ),
        DesignElement(
            id: "crystal_beads_clear",
            displayName: "Clear Crystal Beads",
            category: .beads,
            weight: 0.7,
            culturalSignificance: 0.6,
            ageAppropriate: [.young, .adult],
            compatibleGenres: [.modern, .elegant],
            promptTokens: ["crystal beads", "clear crystals", "glass beads", "transparent beads"]
        ),
        DesignElement(
            id: "wooden_beads_natural",
            displayName: "Natural Wooden Beads",
            category: .beads,
            weight: 0.75,
            culturalSignificance: 0.8,
            ageAppropriate: [.any],
            compatibleGenres: [.traditional, .spiritual],
            promptTokens: ["wooden beads", "natural wood", "sandalwood beads", "carved wood beads"]
        ),
        DesignElement(
            id: "silver_beads_metallic",
            displayName: "Silver Metallic Beads",
            category: .beads,
            weight: 0.75,
            culturalSignificance: 0.7,
            ageAppropriate: [.any],
            compatibleGenres: [.elegant, .modern],
            promptTokens: ["silver beads", "metallic silver", "shiny silver beads", "chrome beads"]
        ),
        DesignElement(
            id: "gemstone_beads_mixed",
            displayName: "Mixed Gemstone Beads",
            category: .beads,
            weight: 0.8,
            culturalSignificance: 0.85,
            ageAppropriate: [.adult, .elder],
            compatibleGenres: [.traditional, .elegant],
            promptTokens: ["gemstone beads", "precious stones", "colorful gems", "mixed gems"]
        ),
        DesignElement(
            id: "coral_beads_red",
            displayName: "Red Coral Beads",
            category: .beads,
            weight: 0.85,
            culturalSignificance: 0.9,
            ageAppropriate: [.adult, .elder],
            compatibleGenres: [.traditional, .spiritual],
            promptTokens: ["coral beads", "red coral", "natural coral", "sea coral beads"]
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
