import Foundation

// MARK: - Prompt Token Model
struct PromptToken {
    let token: String
    let baseWeight: Double
    
    init(token: String, baseWeight: Double = 1.0) {
        self.token = token
        self.baseWeight = baseWeight
    }
}

// MARK: - Prompt Mapping Data
struct PromptMappingData {
    static let embeddeduktMappings: [String: [PromptToken]] = [
        // Thread Elements
        "red_thread": [
            PromptToken(token: "red thread", baseWeight: 1.0),
            PromptToken(token: "mauli", baseWeight: 0.9),
            PromptToken(token: "sacred thread", baseWeight: 0.8),
            PromptToken(token: "traditional red cord", baseWeight: 0.7)
        ],
        "silk_thread": [
            PromptToken(token: "silk thread", baseWeight: 1.0),
            PromptToken(token: "smooth thread", baseWeight: 0.8),
            PromptToken(token: "lustrous thread", baseWeight: 0.7),
            PromptToken(token: "premium fiber", baseWeight: 0.6)
        ],

        // Bead Elements
        "gold_beads": [
            PromptToken(token: "gold beads", baseWeight: 1.0),
            PromptToken(token: "golden spheres", baseWeight: 0.9),
            PromptToken(token: "metallic beads", baseWeight: 0.8),
            PromptToken(token: "shimmering gold", baseWeight: 0.7)
        ],
        "pearl_beads": [
            PromptToken(token: "pearl beads", baseWeight: 1.0),
            PromptToken(token: "white pearls", baseWeight: 0.9),
            PromptToken(token: "lustrous pearls", baseWeight: 0.8),
            PromptToken(token: "iridescent beads", baseWeight: 0.7)
        ],
        "rudraksha_beads": [
            PromptToken(token: "rudraksha beads", baseWeight: 1.0),
            PromptToken(token: "sacred beads", baseWeight: 0.9),
            PromptToken(token: "spiritual beads", baseWeight: 0.8),
            PromptToken(token: "brown seed beads", baseWeight: 0.7)
        ],

        // Center Piece Elements
        "om_symbol": [
            PromptToken(token: "sanskrit syllable symbol", baseWeight: 1.0),
            PromptToken(token: "three curved lines with dot", baseWeight: 0.9),
            PromptToken(token: "ancient spiritual character", baseWeight: 0.8),
            PromptToken(token: "devanagari script emblem", baseWeight: 0.7),
            PromptToken(token: "golden curved geometry", baseWeight: 0.6)
        ],
        "om_symbol_traditional": [
            PromptToken(token: "traditional Sanskrit AUM character", baseWeight: 1.0),
            PromptToken(token: "three consciousness curves with dot", baseWeight: 0.9),
            PromptToken(token: "flowing asymmetrical sacred lines", baseWeight: 0.8),
            PromptToken(token: "crescent moon celestial geometry", baseWeight: 0.7),
            PromptToken(token: "classical meditation emblem", baseWeight: 0.6)
        ],
        "lotus_motif": [
            PromptToken(token: "lotus flower", baseWeight: 1.0),
            PromptToken(token: "lotus petals", baseWeight: 0.9),
            PromptToken(token: "sacred lotus", baseWeight: 0.8),
            PromptToken(token: "pink lotus", baseWeight: 0.7),
            PromptToken(token: "blooming lotus", baseWeight: 0.6)
        ],
        "geometric_center": [
            PromptToken(token: "geometric pattern", baseWeight: 1.0),
            PromptToken(token: "modern design", baseWeight: 0.9),
            PromptToken(token: "abstract shape", baseWeight: 0.8),
            PromptToken(token: "symmetrical design", baseWeight: 0.7),
            PromptToken(token: "contemporary motif", baseWeight: 0.6)
        ],
        "lotus_flower_pink": [
            PromptToken(token: "pink lotus flower", baseWeight: 1.0),
            PromptToken(token: "sacred pink lotus", baseWeight: 0.9),
            PromptToken(token: "blooming lotus", baseWeight: 0.8),
            PromptToken(token: "lotus centerpiece", baseWeight: 0.7)
        ],
        "ganesha_motif": [
            PromptToken(token: "ganesha motif", baseWeight: 1.0),
            PromptToken(token: "lord ganesha", baseWeight: 0.9),
            PromptToken(token: "ganpati symbol", baseWeight: 0.8),
            PromptToken(token: "elephant god", baseWeight: 0.7)
        ],
        "peacock_design": [
            PromptToken(token: "peacock design", baseWeight: 1.0),
            PromptToken(token: "indian peacock", baseWeight: 0.9),
            PromptToken(token: "colorful peacock", baseWeight: 0.8),
            PromptToken(token: "peacock motif", baseWeight: 0.7)
        ],
        "mandala_circular": [
            PromptToken(token: "circular mandala", baseWeight: 1.0),
            PromptToken(token: "geometric mandala", baseWeight: 0.9),
            PromptToken(token: "sacred mandala", baseWeight: 0.8),
            PromptToken(token: "mandala pattern", baseWeight: 0.7)
        ],

        // Decorative Elements
        "tassels": [
            PromptToken(token: "tassels", baseWeight: 1.0),
            PromptToken(token: "hanging threads", baseWeight: 0.8),
            PromptToken(token: "decorative tassels", baseWeight: 0.7),
            PromptToken(token: "flowing threads", baseWeight: 0.6)
        ],
        "mirrors": [
            PromptToken(token: "mirror work", baseWeight: 1.0),
            PromptToken(token: "reflective elements", baseWeight: 0.8),
            PromptToken(token: "shiny mirrors", baseWeight: 0.7),
            PromptToken(token: "embedded mirrors", baseWeight: 0.6),
            PromptToken(token: "glass inlay", baseWeight: 0.5)
        ],

        // Symbols (excluding problematic swastika - content filtering issues)
        "peacock_motif": [
            PromptToken(token: "peacock design", baseWeight: 1.0),
            PromptToken(token: "peacock feathers", baseWeight: 0.9),
            PromptToken(token: "colorful peacock", baseWeight: 0.8),
            PromptToken(token: "bird motif", baseWeight: 0.7),
            PromptToken(token: "ornamental bird", baseWeight: 0.6)
        ]
    ]
}
