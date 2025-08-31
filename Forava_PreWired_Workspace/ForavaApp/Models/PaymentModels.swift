import Foundation
import SwiftUI

struct RegionPreference: Codable {
    let region: String
    let currency: String
    let localization: [String: String]
}

struct CulturalPaymentContext: Codable {
    let amount: Decimal
    let currency: String
    let regionPreference: RegionPreference
    let culturalContext: String
    let festival: String?
    let relationship: String
    let occasion: String
    let blessing: String
    let recommendedAmount: Int
    let alternativeAmounts: [Int]
    
    init(amount: Decimal, currency: String, regionPreference: RegionPreference, culturalContext: String, festival: String? = nil, relationship: String, occasion: String = "", blessing: String = "", recommendedAmount: Int = 0, alternativeAmounts: [Int] = []) {
        self.amount = amount
        self.currency = currency
        self.regionPreference = regionPreference
        self.culturalContext = culturalContext
        self.festival = festival
        self.relationship = relationship
        self.occasion = occasion
        self.blessing = blessing
        self.recommendedAmount = recommendedAmount
        self.alternativeAmounts = alternativeAmounts
    }
}
