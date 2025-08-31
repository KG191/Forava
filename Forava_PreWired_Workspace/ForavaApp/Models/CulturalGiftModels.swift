import Foundation
import SwiftUI

// MARK: - Cultural Gift Models
// Models for the new multi-cultural gift system

struct CulturalGift: Identifiable, Codable {
    let id: UUID
    let designSpec: CulturalDesignSpec
    let recipient: Contact
    let generatedImages: [CulturalGiftImage]
    let aiPrompt: CulturalAIPrompt
    let culturalMetadata: CulturalGiftMetadata
    let createdAt: Date
    let status: CulturalGiftStatus

    init(
        designSpec: CulturalDesignSpec,
        recipient: Contact,
        generatedImages: [CulturalGiftImage] = [],
        aiPrompt: CulturalAIPrompt,
        culturalMetadata: CulturalGiftMetadata
    ) {
        self.id = UUID()
        self.designSpec = designSpec
        self.recipient = recipient
        self.generatedImages = generatedImages
        self.aiPrompt = aiPrompt
        self.culturalMetadata = culturalMetadata
        self.createdAt = Date()
        self.status = .generating
    }
}

struct CulturalGiftImage: Identifiable, Codable {
    let id: UUID
    let imageData: Data
    let imageURL: URL?
    let quality: CulturalImageQuality
    let culturalAccuracyScore: Double // 0.0 to 1.0
    let generationParameters: [String: String]

    init(imageData: Data, imageURL: URL? = nil, quality: CulturalImageQuality = .standard) {
        self.id = UUID()
        self.imageData = imageData
        self.imageURL = imageURL
        self.quality = quality
        self.culturalAccuracyScore = 0.85 // Mock score
        self.generationParameters = [:]
    }
}

struct CulturalAIPrompt: Codable {
    let positivePrompt: String
    let negativePrompt: String
    let culturalEnhancers: [String]
    let styleModifiers: [String]
    let qualitySettings: CulturalPromptQuality

    init(
        positivePrompt: String,
        negativePrompt: String = "",
        culturalEnhancers: [String] = [],
        styleModifiers: [String] = [],
        qualitySettings: CulturalPromptQuality = .high
    ) {
        self.positivePrompt = positivePrompt
        self.negativePrompt = negativePrompt
        self.culturalEnhancers = culturalEnhancers
        self.styleModifiers = styleModifiers
        self.qualitySettings = qualitySettings
    }
}

struct CulturalGiftMetadata: Codable {
    let culturalContext: String
    let occasion: String
    let authenticityValidated: Bool
    let culturalConsultantApproved: Bool
    let generationModel: String
    let processingTime: TimeInterval
    let culturalElements: [String]

    init(
        culturalContext: String,
        occasion: String,
        authenticityValidated: Bool = false,
        culturalConsultantApproved: Bool = false,
        generationModel: String = "SDXL-Cultural-v1",
        processingTime: TimeInterval = 0,
        culturalElements: [String] = []
    ) {
        self.culturalContext = culturalContext
        self.occasion = occasion
        self.authenticityValidated = authenticityValidated
        self.culturalConsultantApproved = culturalConsultantApproved
        self.generationModel = generationModel
        self.processingTime = processingTime
        self.culturalElements = culturalElements
    }
}

// MARK: - Supporting Enums

enum CulturalGiftStatus: String, Codable, CaseIterable {
    case generating
    case completed
    case failed
    case underReview
    case approved
    case culturallyInappropriate

    var displayName: String {
        switch self {
        case .generating: return "Generating"
        case .completed: return "Ready"
        case .failed: return "Failed"
        case .underReview: return "Under Review"
        case .approved: return "Approved"
        case .culturallyInappropriate: return "Needs Revision"
        }
    }

    var color: Color {
        switch self {
        case .generating: return .blue
        case .completed, .approved: return .green
        case .failed, .culturallyInappropriate: return .red
        case .underReview: return .orange
        }
    }
}

enum CulturalImageQuality: String, Codable, CaseIterable {
    case standard
    case high
    case premium
    case culturallyAuthentic

    var displayName: String {
        switch self {
        case .standard: return "Standard"
        case .high: return "High Quality"
        case .premium: return "Premium"
        case .culturallyAuthentic: return "Culturally Authentic"
        }
    }

    var resolution: (width: Int, height: Int) {
        switch self {
        case .standard: return (512, 512)
        case .high: return (768, 768)
        case .premium: return (1024, 1024)
        case .culturallyAuthentic: return (1024, 1024)
        }
    }
}

enum CulturalPromptQuality: String, Codable, CaseIterable {
    case basic
    case standard
    case high
    case culturalExpert

    var steps: Int {
        switch self {
        case .basic: return 20
        case .standard: return 30
        case .high: return 50
        case .culturalExpert: return 75
        }
    }

    var guidanceScale: Double {
        switch self {
        case .basic: return 7.5
        case .standard: return 10.0
        case .high: return 12.5
        case .culturalExpert: return 15.0
        }
    }
}

// MARK: - Cultural Age Group

struct CulturalAgeGroup: Identifiable, Codable, Hashable {
    let id: String
    let displayName: String
    let ageRange: String
    let culturalContext: String
    let appropriateElements: [String]
    let restrictedElements: [String]

    init(
        id: String,
        displayName: String,
        ageRange: String,
        culturalContext: String,
        appropriateElements: [String] = [],
        restrictedElements: [String] = []
    ) {
        self.id = id
        self.displayName = displayName
        self.ageRange = ageRange
        self.culturalContext = culturalContext
        self.appropriateElements = appropriateElements
        self.restrictedElements = restrictedElements
    }

    static func == (lhs: CulturalAgeGroup, rhs: CulturalAgeGroup) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Cultural Design Element Extensions

extension CulturalDesignElement {
    init(
        id: String,
        displayName: String,
        category: CulturalElementCategory,
        weight: Double,
        culturalSignificance: Double,
        ageAppropriate: [CulturalAgeGroup],
        compatibleGenreIds: [String],
        promptTokens: [String],
        culturalContext: String,
        description: String?
    ) {
        self.id = id
        self.displayName = displayName
        self.category = category
        self.weight = weight
        self.culturalSignificance = culturalSignificance
        self.ageAppropriate = ageAppropriate
        self.compatibleGenreIds = compatibleGenreIds
        self.promptTokens = promptTokens
        self.culturalContext = culturalContext
        self.description = description
    }
}

// MARK: - Mock Extension for Testing

extension CulturalGift {
    static func mock(for contact: Contact) -> CulturalGift {
        let designSpec = CulturalDesignSpec(
            culturalContext: "rakhi_indian",
            genre: CulturalGenre(
                id: "traditional",
                displayName: "Traditional",
                icon: "star.circle.fill",
                basePrompt: "traditional rakhi design",
                culturalContext: "rakhi_indian"
            ),
            colorPalette: CulturalColorPalette(
                id: "traditional",
                displayName: "Traditional Colors",
                colors: [],
                culturalContext: "rakhi_indian"
            ),
            targetAgeGroup: CulturalAgeGroup(
                id: "adult",
                displayName: "Adult",
                ageRange: "18-60",
                culturalContext: "rakhi_indian"
            )
        )

        let prompt = CulturalAIPrompt(
            positivePrompt: "traditional rakhi design, intricate patterns, vibrant colors",
            culturalEnhancers: ["authentic", "traditional", "sacred"]
        )

        let metadata = CulturalGiftMetadata(
            culturalContext: "rakhi_indian",
            occasion: "raksha_bandhan",
            authenticityValidated: true
        )

        return CulturalGift(
            designSpec: designSpec,
            recipient: contact,
            generatedImages: [CulturalGiftImage(imageData: Data())],
            aiPrompt: prompt,
            culturalMetadata: metadata
        )
    }
}
