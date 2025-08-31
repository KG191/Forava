import Foundation
import SwiftUI

// MARK: - Multi-Language Prompt Service
@MainActor
class MultiLanguagePromptService: ObservableObject {
    static let shared = MultiLanguagePromptService()

    @Published private(set) var isInitialized = false
    @Published var enableNativeLanguagePrompts = true

    private var promptTranslations: [String: [String: String]] = [:]
    private var culturalPromptEnhancers: [String: [String: [String]]] = [:]

    private init() {
        initializePromptTranslations()
    }

    // MARK: - Initialization

    func initialize() async {
        print("[MultiLanguagePromptService] Initializing multi-language prompt system...")

        await loadPromptTranslations()
        await loadCulturalEnhancers()

        isInitialized = true
        print("[MultiLanguagePromptService] Multi-language prompt system initialized")
    }

    private func loadPromptTranslations() async {
        // Load base prompt translations for common art generation terms
        promptTranslations = [
            // English (base)
            "en": [
                "traditional": "traditional",
                "modern": "modern",
                "beautiful": "beautiful",
                "elegant": "elegant",
                "colorful": "colorful",
                "peaceful": "peaceful",
                "sacred": "sacred",
                "festive": "festive",
                "artistic": "artistic",
                "handcrafted": "handcrafted",
                "masterpiece": "masterpiece",
                "detailed": "detailed"
            ],

            // Chinese
            "zh": [
                "traditional": "传统的",
                "modern": "现代的",
                "beautiful": "美丽的",
                "elegant": "优雅的",
                "colorful": "多彩的",
                "peaceful": "和平的",
                "sacred": "神圣的",
                "festive": "节庆的",
                "artistic": "艺术的",
                "handcrafted": "手工制作的",
                "masterpiece": "杰作",
                "detailed": "详细的"
            ],

            // Japanese
            "ja": [
                "traditional": "伝統的な",
                "modern": "現代の",
                "beautiful": "美しい",
                "elegant": "優雅な",
                "colorful": "カラフルな",
                "peaceful": "平和な",
                "sacred": "神聖な",
                "festive": "祭りの",
                "artistic": "芸術的な",
                "handcrafted": "手作りの",
                "masterpiece": "傑作",
                "detailed": "詳細な"
            ],

            // Arabic
            "ar": [
                "traditional": "تقليدي",
                "modern": "حديث",
                "beautiful": "جميل",
                "elegant": "أنيق",
                "colorful": "ملون",
                "peaceful": "سلمي",
                "sacred": "مقدس",
                "festive": "احتفالي",
                "artistic": "فني",
                "handcrafted": "صناعة يدوية",
                "masterpiece": "تحفة فنية",
                "detailed": "مفصل"
            ],

            // Hebrew
            "he": [
                "traditional": "מסורתי",
                "modern": "מודרני",
                "beautiful": "יפה",
                "elegant": "אלגנטי",
                "colorful": "צבעוני",
                "peaceful": "שלו",
                "sacred": "קדוש",
                "festive": "חגיגי",
                "artistic": "אמנותי",
                "handcrafted": "עבודת יד",
                "masterpiece": "יצירת מופת",
                "detailed": "מפורט"
            ],

            // Spanish
            "es": [
                "traditional": "tradicional",
                "modern": "moderno",
                "beautiful": "hermoso",
                "elegant": "elegante",
                "colorful": "colorido",
                "peaceful": "pacífico",
                "sacred": "sagrado",
                "festive": "festivo",
                "artistic": "artístico",
                "handcrafted": "hecho a mano",
                "masterpiece": "obra maestra",
                "detailed": "detallado"
            ],

            // Swahili (African)
            "sw": [
                "traditional": "za kitamaduni",
                "modern": "za kisasa",
                "beautiful": "nzuri",
                "elegant": "maridadi",
                "colorful": "zenye rangi nyingi",
                "peaceful": "za amani",
                "sacred": "takatifu",
                "festive": "za sherehe",
                "artistic": "za kisanaa",
                "handcrafted": "za mkono",
                "masterpiece": "kazi bora",
                "detailed": "za kina"
            ],

            // Thai (Buddhist)
            "th": [
                "traditional": "แบบดั้งเดิม",
                "modern": "ทันสมัย",
                "beautiful": "สวยงาม",
                "elegant": "หรูหรา",
                "colorful": "สีสันสดใส",
                "peaceful": "สงบ",
                "sacred": "ศักดิ์สิทธิ์",
                "festive": "เทศกาล",
                "artistic": "ศิลปะ",
                "handcrafted": "ทำด้วยมือ",
                "masterpiece": "ผลงานชิ้นเอก",
                "detailed": "ละเอียด"
            ]
        ]
    }

    private func loadCulturalEnhancers() async {
        // Load culture-specific prompt enhancers in native languages
        culturalPromptEnhancers = [
            "chinese_traditional": [
                "zh": [
                    "中国传统艺术", "风水元素", "吉祥图案", "中华文化遗产", "东方设计",
                    "手工传统艺术", "居中构图", "干净背景上孤立", "杰作品质"
                ],
                "en": [
                    "Chinese traditional art", "feng shui elements", "auspicious symbols",
                    "Chinese cultural heritage", "oriental design", "handcrafted traditional art"
                ]
            ],

            "japanese_traditional": [
                "ja": [
                    "日本の伝統芸術", "和の美学", "もののあはれ", "自然の調和", "儀式の美しさ",
                    "手作りの伝統芸術", "中央構図", "きれいな背景に分離", "傑作品質"
                ],
                "en": [
                    "Japanese traditional art", "wa aesthetic harmony", "mono no aware beauty",
                    "natural elegance", "ceremonial presentation"
                ]
            ],

            "middle_eastern_traditional": [
                "ar": [
                    "الفن الإسلامي التقليدي", "الأنماط الهندسية", "الرموز المباركة", "التراث الثقافي",
                    "التصميم الشرقي", "الفن التقليدي المصنوع يدوياً", "التركيب المركزي"
                ],
                "en": [
                    "Islamic traditional art", "geometric harmony", "sacred patterns",
                    "cultural authenticity", "divine geometry"
                ]
            ],

            "jewish_traditional": [
                "he": [
                    "אמנות יהודית מסורתית", "מורשת עברית", "סמלים קדושים", "מסורות דתיות",
                    "אמנות דתית", "אמנות מסורתית עבודת יד", "קומפוזיציה מרכזית"
                ],
                "en": [
                    "Jewish traditional art", "Hebrew cultural heritage", "religious devotion",
                    "sacred traditions", "ritual beauty"
                ]
            ],

            "christian_traditional": [
                "en": [
                    "Christian traditional art", "faith-based design", "spiritual beauty",
                    "religious devotion", "holy imagery", "sacred art"
                ],
                "es": [
                    "arte cristiano tradicional", "diseño basado en la fe", "belleza espiritual",
                    "devoción religiosa", "imágenes sagradas", "arte sacro"
                ]
            ],

            "buddhist_traditional": [
                "th": [
                    "ศิลปะพุทธศาสนาแบบดั้งเดิม", "ศิลปะสมาธิ", "ความเงียบสงบทางจิตวิญญาณ",
                    "ภาพสติ", "การใคร่ครวญอย่างสงบ", "ศิลปะธรรม"
                ],
                "en": [
                    "Buddhist traditional art", "meditation art", "spiritual serenity",
                    "mindfulness imagery", "peaceful contemplation", "dharma art"
                ]
            ],

            "african_traditional": [
                "sw": [
                    "sanaa za kitamaduni za Kiafrika", "utamaduni wa mababu", "roho ya jamii",
                    "utangamano wa asili", "sanaa za kimila za mkono"
                ],
                "en": [
                    "African traditional art", "ancestral wisdom", "community spirit",
                    "natural harmony", "tribal authenticity"
                ]
            ],

            "latin_american_traditional": [
                "es": [
                    "arte tradicional latinoamericano", "herencia cultural vibrante", "sabiduría indígena",
                    "arte folclórico colonial", "celebración familiar", "espíritu festivo"
                ],
                "en": [
                    "Latin American traditional art", "vibrant cultural heritage", "indigenous wisdom",
                    "colonial folk art", "family celebration", "festive spirit"
                ]
            ]
        ]
    }

    // MARK: - Prompt Building

    func buildMultiLanguagePrompt(
        from spec: CulturalDesignSpec,
        in context: CulturalContext
    ) -> (positive: String, negative: String) {

        let primaryLanguage = context.primaryLanguage
        let contextId = context.identifier

        // Build base prompt in English
        var positivePrompt = buildBasePrompt(from: spec, in: context)
        var negativePrompt = buildBaseNegativePrompt(for: context)

        // Add native language enhancements if available and enabled
        if enableNativeLanguagePrompts {
            if let enhancers = culturalPromptEnhancers[contextId]?[primaryLanguage] {
                positivePrompt = addNativeLanguageEnhancers(positivePrompt, enhancers: enhancers)
            }

            // Add translated aesthetic terms
            if let translations = promptTranslations[primaryLanguage] {
                positivePrompt = addTranslatedTerms(positivePrompt, translations: translations)
            }
        }

        return (positivePrompt, negativePrompt)
    }

    private func buildBasePrompt(from spec: CulturalDesignSpec, in context: CulturalContext) -> String {
        var prompt = spec.genre.basePrompt

        // Add element descriptions
        let elementDescriptions = spec.elements.map { $0.promptTokens.joined(separator: ", ") }
        if !elementDescriptions.isEmpty {
            prompt += ", " + elementDescriptions.joined(separator: ", ")
        }

        // Add color palette tokens
        prompt += ", " + spec.colorPalette.promptTokens.joined(separator: ", ")

        // Add base enhancers
        prompt += ", " + context.basePromptEnhancers.joined(separator: ", ")

        return prompt
    }

    private func buildBaseNegativePrompt(for context: CulturalContext) -> String {
        return context.culturalNegativePrompts.joined(separator: ", ")
    }

    private func addNativeLanguageEnhancers(_ prompt: String, enhancers: [String]) -> String {
        return prompt + ", " + enhancers.joined(separator: ", ")
    }

    private func addTranslatedTerms(_ prompt: String, translations: [String: String]) -> String {
        var enhancedPrompt = prompt

        // Replace common English terms with native translations where appropriate
        for (english, translated) in translations {
            if enhancedPrompt.contains(english) && english != translated {
                // Add translated term alongside English for better AI understanding
                enhancedPrompt = enhancedPrompt.replacingOccurrences(
                    of: english,
                    with: "\(english) (\(translated))"
                )
            }
        }

        return enhancedPrompt
    }

    // MARK: - Language Support

    func getSupportedLanguages(for context: CulturalContext) -> [String] {
        return context.supportedLanguages
    }

    func getPromptInLanguage(_ language: String, for context: CulturalContext) -> [String]? {
        return culturalPromptEnhancers[context.identifier]?[language]
    }

    func translatePromptTerm(_ term: String, to language: String) -> String {
        return promptTranslations[language]?[term] ?? term
    }

    // MARK: - Cultural Bias Detection

    func detectCulturalBias(in prompt: String, for context: CulturalContext) -> CulturalBiasResult {
        var warnings: [String] = []
        var suggestions: [String] = []

        // Check for inappropriate cultural mixing
        let contextId = context.identifier
        let inappropriateMixing = detectInappropriateCulturalMixing(prompt, contextId: contextId)
        warnings.append(contentsOf: inappropriateMixing)

        // Check for cultural stereotypes
        let stereotypes = detectCulturalStereotypes(prompt, contextId: contextId)
        warnings.append(contentsOf: stereotypes)

        // Check for language appropriateness
        let languageIssues = detectLanguageIssues(prompt, context: context)
        warnings.append(contentsOf: languageIssues)

        // Generate suggestions for improvement
        if !warnings.isEmpty {
            suggestions = generateImprovementSuggestions(for: context, warnings: warnings)
        }

        return CulturalBiasResult(
            isAppropriate: warnings.isEmpty,
            warnings: warnings,
            suggestions: suggestions,
            confidence: calculateBiasDetectionConfidence(warnings)
        )
    }

    private func detectInappropriateCulturalMixing(_ prompt: String, contextId: String) -> [String] {
        var warnings: [String] = []

        let culturalKeywords = [
            "chinese_traditional": ["chinese", "dragon", "feng shui", "lunar"],
            "japanese_traditional": ["japanese", "zen", "sakura", "samurai"],
            "middle_eastern_traditional": ["islamic", "arabic", "mosque", "crescent"],
            "jewish_traditional": ["jewish", "hebrew", "kosher", "shabbat"],
            "christian_traditional": ["christian", "cross", "church", "biblical"],
            "buddhist_traditional": ["buddhist", "buddha", "meditation", "dharma"],
            "african_traditional": ["african", "tribal", "ancestral", "safari"],
            "latin_american_traditional": ["latin", "aztec", "mayan", "fiesta"]
        ]

        // Check for keywords from other cultures
        for (otherContextId, keywords) in culturalKeywords {
            if otherContextId != contextId {
                for keyword in keywords {
                    if prompt.lowercased().contains(keyword.lowercased()) {
                        warnings.append("Prompt contains '\(keyword)' which may not be appropriate for \(contextId)")
                    }
                }
            }
        }

        return warnings
    }

    private func detectCulturalStereotypes(_ prompt: String, contextId: String) -> [String] {
        var warnings: [String] = []

        // Define potentially problematic terms for each culture
        let problematicTerms = [
            "middle_eastern_traditional": ["terrorist", "violent", "oppressive"],
            "african_traditional": ["primitive", "savage", "underdeveloped"],
            "jewish_traditional": ["greedy", "controlling", "conspiracy"],
            "latin_american_traditional": ["lazy", "illegal", "gang"]
        ]

        if let terms = problematicTerms[contextId] {
            for term in terms {
                if prompt.lowercased().contains(term.lowercased()) {
                    warnings.append("Prompt contains potentially stereotypical term: '\(term)'")
                }
            }
        }

        return warnings
    }

    private func detectLanguageIssues(_ prompt: String, context: CulturalContext) -> [String] {
        var warnings: [String] = []

        // Check if native language terms are used appropriately
        let primaryLanguage = context.primaryLanguage

        if primaryLanguage != "en" {
            if let enhancers = culturalPromptEnhancers[context.identifier]?[primaryLanguage] {
                // Check if native terms are balanced with English
                let nativeTermCount = enhancers.filter { prompt.contains($0) }.count
                let englishTermCount = context.basePromptEnhancers.filter { prompt.contains($0) }.count

                if nativeTermCount > englishTermCount * 2 {
                    warnings.append("Prompt may be too heavily weighted toward native language terms")
                }
            }
        }

        return warnings
    }

    private func generateImprovementSuggestions(for context: CulturalContext, warnings: [String]) -> [String] {
        var suggestions: [String] = []

        suggestions.append("Consider using more culturally authentic terms from \(context.displayName)")
        suggestions.append("Balance native language terms with English for better AI understanding")
        suggestions.append("Focus on positive cultural aspects and avoid stereotypical language")

        return suggestions
    }

    private func calculateBiasDetectionConfidence(_ warnings: [String]) -> Double {
        if warnings.isEmpty {
            return 0.95 // High confidence when no issues detected
        } else {
            return max(0.3, 1.0 - (Double(warnings.count) * 0.2)) // Lower confidence with more warnings
        }
    }

    // MARK: - Prompt Optimization

    func optimizePromptForCulture(_ prompt: String, context: CulturalContext) -> String {
        var optimizedPrompt = prompt

        // Add cultural weight to important elements
        let culturalElements = context.designElements.filter { $0.culturalSignificance > 0.8 }
        for element in culturalElements.prefix(3) {
            let elementTerms = element.promptTokens.joined(separator: ", ")
            if optimizedPrompt.contains(elementTerms) {
                // Add emphasis to highly significant cultural elements
                optimizedPrompt = optimizedPrompt.replacingOccurrences(
                    of: elementTerms,
                    with: "(\(elementTerms):1.2)" // Stable Diffusion emphasis syntax
                )
            }
        }

        // Add cultural context reinforcement
        let contextEmphasis = "(\(context.displayName) cultural style:1.1)"
        optimizedPrompt = "\(contextEmphasis), \(optimizedPrompt)"

        return optimizedPrompt
    }
}

// MARK: - Supporting Types

struct CulturalBiasResult {
    let isAppropriate: Bool
    let warnings: [String]
    let suggestions: [String]
    let confidence: Double
}

// MARK: - Private Extensions

private extension MultiLanguagePromptService {
    func initializePromptTranslations() {
        // Initialize with empty dictionaries - will be populated in loadPromptTranslations
        promptTranslations = [:]
        culturalPromptEnhancers = [:]
    }
}

// MARK: - SwiftUI Integration

extension MultiLanguagePromptService {
    func getLanguageDisplayName(_ languageCode: String) -> String {
        let displayNames = [
            "en": "English",
            "zh": "中文 (Chinese)",
            "ja": "日本語 (Japanese)",
            "ar": "العربية (Arabic)",
            "he": "עברית (Hebrew)",
            "es": "Español (Spanish)",
            "sw": "Kiswahili (Swahili)",
            "th": "ไทย (Thai)",
            "hi": "हिन्दी (Hindi)",
            "fr": "Français (French)",
            "pt": "Português (Portuguese)"
        ]

        return displayNames[languageCode] ?? languageCode.uppercased()
    }
}
